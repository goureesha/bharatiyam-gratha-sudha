"""
═══════════════════════════════════════════════════════════════════════
  Bharatiyam Grantha Sudha — Automated Sanskrit Transcription Pipeline
═══════════════════════════════════════════════════════════════════════

This script processes a Sanskrit PDF book page-by-page, sending each page
to the Gemini API for transcription with shabdartha, bhavartha, and
vyakhyana — all in Kannada script.

USAGE:
  python transcribe_pipeline.py --pdf "path/to/book.pdf" \
      --start-page 31 --end-page 100 \
      --output "output_chapter.txt" \
      --api-key "YOUR_GEMINI_API_KEY"

KEY FEATURES:
  - Each page = fresh API call (no context decay)
  - Full rules repeated every call (no instruction fade)
  - Automated validation (shabdartha count, bhavartha length, etc.)
  - Auto-retry on failures (up to 3 times)
  - Progress saved after each page (resume-safe)
  - Runs for hours unattended
"""

import argparse
import json
import os
import re
import sys
import time
import fitz  # PyMuPDF

from google import genai
from google.genai import types

# ═══════════════════════════════════════════════════════════════════════
# SYSTEM PROMPT — repeated with EVERY API call to prevent instruction fade
# ═══════════════════════════════════════════════════════════════════════

SYSTEM_PROMPT = """You are a Sanskrit-Kannada scholarly transcription engine. You MUST follow every rule below with ZERO exceptions. Breaking any rule is a critical failure.

═══ INPUT ═══
You will receive an image of a page from a Sanskrit grantha (scripture) containing shlokas with vyakhyana (commentary).

═══ OUTPUT RULES (MANDATORY — NO SHORTCUTS) ═══

1. SHLOKA EXTRACTION
   - Transcribe EVERY shloka on this page EXACTLY as printed — every syllable, every word
   - Use ONLY Kannada script (zero Devanagari characters)
   - Use Kannada avagraha ಽ (not Devanagari ऽ)
   - Wrap each shloka line in **bold** markers: **shloka text here**
   - NEVER skip, merge, or paraphrase any part of the shloka
   - If the shloka spans multiple lines, include ALL lines
   - Number each shloka sequentially

2. SHABDARTHA (Word-by-Word Meaning) — MANDATORY FOR EVERY WORD
   - List EVERY word/compound from the shloka — no exceptions
   - Each word gets its own bullet point
   - Format: • **Sanskrit word** — Kannada meaning (vibhakti/grammatical form, samasa type if applicable)
   - For samasa (compounds): break into component words, explain each, then the compound meaning
   - The Sanskrit word MUST be in **bold**
   - Minimum: one bullet per word. If shloka has 12 words, there must be ≥12 bullets
   - NEVER write "ಇತ್ಯಾದಿ", "ಮುಂತಾದ", or "etc." to skip words
   - NEVER use "..." or "…" (ellipsis)

3. BHAVARTHA (Overall Meaning) — MANDATORY
   - Write a COMPLETE explanation in Kannada (minimum 100 words)
   - Must follow the logical flow of the book/chapter — connect to previous and next shlokas
   - Explain the philosophical/spiritual significance
   - Do NOT just repeat the shabdartha in sentence form — add deeper meaning
   - Include context from the vyakhyana/commentary

4. VYAKHYANA (Commentary Transcription & Translation) — MANDATORY
   - Transcribe the FULL commentary text exactly as printed (in Kannada script, NOT Devanagari)
   - Label it: "ಮೂಲ:"
   - Then provide COMPLETE Kannada translation of the commentary
   - Label it: "ಅನುವಾದ:"
   - Do NOT summarize or shorten — every sentence must be translated
   - If commentary is 20 lines, translation must cover all 20 lines

5. FORMAT
   - Each shloka block starts with: ಶ್ಲೋಕ N:
   - Sections labeled: ಭಾವಾರ್ಥ:, ಶಬ್ದಾರ್ಥ:, ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
   - Separate shloka blocks with: ----------------------------------------
   - If a page has ONLY vyakhyana (no new shloka), transcribe it fully and translate it

═══ ABSOLUTE PROHIBITIONS ═══
❌ NEVER skip any word in shabdartha
❌ NEVER write less than 2 bullet points for shabdartha
❌ NEVER use ellipsis (... or …) anywhere
❌ NEVER summarize when you should transcribe
❌ NEVER write "as mentioned above" or "as explained earlier" to skip content
❌ NEVER reduce bhavartha to less than 70 words
❌ NEVER skip the vyakhyana section
❌ NEVER use Devanagari script — ONLY Kannada script
❌ NEVER use English words in the output

═══ SELF-CHECK BEFORE RESPONDING ═══
Before outputting, verify:
□ Every word from the shloka appears in shabdartha
□ Shabdartha has ≥ [number of words in shloka] bullet points
□ Each shabda word is wrapped in **bold**
□ Each shloka line is wrapped in **bold**
□ Bhavartha is ≥ 100 words
□ Vyakhyana is fully transcribed and translated
□ Zero Devanagari characters
□ Zero ellipsis
□ Zero skipped content
□ Zero English words"""


# ═══════════════════════════════════════════════════════════════════════
# VALIDATION
# ═══════════════════════════════════════════════════════════════════════

def validate_output(output_text):
    """Validate the transcription output quality. Returns (pass, errors)."""
    errors = []

    # 1. Check for Devanagari characters
    devanagari = re.findall(r'[\u0900-\u097F]', output_text)
    if devanagari:
        unique = ''.join(sorted(set(devanagari)))
        errors.append(f"DEVANAGARI FOUND: {unique}")

    # 2. Check for ellipsis
    if '...' in output_text or '…' in output_text:
        errors.append("ELLIPSIS FOUND — content likely skipped")

    # 3. Count shabdartha bullets
    bullets = re.findall(r'•\s+\*\*', output_text)
    if len(bullets) < 2:
        errors.append(f"TOO FEW SHABDARTHA: only {len(bullets)} bold bullets found")

    # 4. Check for bold shloka lines
    bold_lines = re.findall(r'\*\*[^*]+\*\*', output_text)
    if len(bold_lines) < 2:
        errors.append(f"BOLD FORMATTING MISSING: only {len(bold_lines)} bold segments found")

    # 5. Check for lazy skip phrases
    lazy_phrases = ['ಇತ್ಯಾದಿ', 'ಮುಂತಾದ', 'as mentioned', 'as above',
                    'as explained', 'similarly', 'and so on', 'etc.']
    for phrase in lazy_phrases:
        if phrase.lower() in output_text.lower():
            errors.append(f"LAZY PHRASE: '{phrase}'")

    # 6. Check minimum output length (at least 500 chars for a meaningful page)
    if len(output_text) < 500:
        errors.append(f"OUTPUT TOO SHORT: {len(output_text)} chars")

    # 7. Check bhavartha section exists and has reasonable length
    bhavartha_match = re.search(r'ಭಾವಾರ್ಥ:\s*\n(.+?)(?:\n\n|\nಶಬ್ದಾರ್ಥ)', output_text, re.DOTALL)
    if bhavartha_match:
        bhavartha_len = len(bhavartha_match.group(1).strip())
        if bhavartha_len < 100:
            errors.append(f"BHAVARTHA TOO SHORT: {bhavartha_len} chars")
    # Don't flag missing bhavartha — some pages may be vyakhyana-only

    return (len(errors) == 0, errors)


# ═══════════════════════════════════════════════════════════════════════
# PIPELINE
# ═══════════════════════════════════════════════════════════════════════

def render_page(doc, page_num, dpi=300):
    """Render a PDF page to PNG bytes."""
    page = doc[page_num]
    pix = page.get_pixmap(dpi=dpi)
    return pix.tobytes("png")


def transcribe_page(client, model_name, image_bytes, page_num, retry_count=3):
    """Send one page to Gemini API and get transcription."""
    user_prompt = f"""ಈ ಪುಟವನ್ನು (ಪುಟ {page_num + 1}) ಸಂಪೂರ್ಣವಾಗಿ ಹೊರತೆಗೆಯಿರಿ.
ಪ್ರತಿಯೊಂದು ಶ್ಲೋಕವನ್ನು ಕನ್ನಡ ಲಿಪಿಯಲ್ಲಿ ಬರೆಯಿರಿ. ಪ್ರತಿ ಶಬ್ದಕ್ಕೂ ಶಬ್ದಾರ್ಥ, ಭಾವಾರ್ಥ, ಮತ್ತು ವ್ಯಾಖ್ಯಾನವನ್ನು ಬರೆಯಿರಿ.
ಒಂದೇ ಒಂದು ಶಬ್ದವನ್ನೂ ಬಿಡಬೇಡಿ. ಒಂದೇ ಒಂದು ಅಕ್ಷರವೂ ದೇವನಾಗರಿಯಲ್ಲಿ ಇರಬಾರದು.
Process this page completely. Extract EVERY shloka, provide shabdartha for EVERY word, bhavartha, and full vyakhyana with Kannada translation."""

    image_part = types.Part.from_bytes(data=image_bytes, mime_type="image/png")

    for attempt in range(retry_count):
        try:
            response = client.models.generate_content(
                model=model_name,
                contents=[
                    types.Content(
                        role="user",
                        parts=[image_part, types.Part.from_text(text=user_prompt)]
                    )
                ],
                config=types.GenerateContentConfig(
                    system_instruction=SYSTEM_PROMPT,
                    temperature=0.15,
                    top_p=0.8,
                    top_k=20,
                    max_output_tokens=8192,
                )
            )

            output = response.text
            passed, errors = validate_output(output)

            if passed:
                print(f"  ✅ Page {page_num + 1}: Validation PASSED (attempt {attempt + 1})")
                return output
            else:
                print(f"  ⚠️  Page {page_num + 1}: Validation FAILED (attempt {attempt + 1})")
                for err in errors:
                    print(f"      - {err}")
                if attempt < retry_count - 1:
                    print(f"      Retrying... ({attempt + 2}/{retry_count})")
                    time.sleep(2)  # Brief pause before retry

        except Exception as e:
            print(f"  ❌ Page {page_num + 1}: API ERROR (attempt {attempt + 1}): {e}")
            if attempt < retry_count - 1:
                wait = (attempt + 1) * 5  # Exponential backoff
                print(f"      Waiting {wait}s before retry...")
                time.sleep(wait)

    # Return last output even if validation failed (flag it)
    print(f"  🔶 Page {page_num + 1}: Using output despite validation failures")
    return output if 'output' in dir() else f"[ERROR: Failed to transcribe page {page_num + 1} after {retry_count} attempts]"


def save_progress(output_path, progress_path, all_text, last_page):
    """Save current transcription and progress."""
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(all_text)

    with open(progress_path, 'w', encoding='utf-8') as f:
        json.dump({"last_completed_page": last_page}, f)


def load_progress(progress_path):
    """Load last completed page from progress file."""
    if os.path.exists(progress_path):
        with open(progress_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            return data.get("last_completed_page", -1)
    return -1


def main():
    parser = argparse.ArgumentParser(description="Automated Sanskrit Transcription Pipeline")
    parser.add_argument("--pdf", required=True, help="Path to the source PDF")
    parser.add_argument("--start-page", type=int, required=True, help="First page to process (0-indexed)")
    parser.add_argument("--end-page", type=int, required=True, help="Last page to process (0-indexed, inclusive)")
    parser.add_argument("--output", required=True, help="Output .txt file path")
    parser.add_argument("--api-key", required=True, help="Gemini API key")
    parser.add_argument("--model", default="gemini-2.5-flash", help="Gemini model name (default: gemini-2.5-flash)")
    parser.add_argument("--dpi", type=int, default=300, help="Render DPI (default: 300)")
    parser.add_argument("--delay", type=float, default=3.0, help="Delay between API calls in seconds (default: 3)")
    parser.add_argument("--resume", action="store_true", help="Resume from last saved progress")
    args = parser.parse_args()

    # Setup
    progress_path = args.output + ".progress.json"
    client = genai.Client(api_key=args.api_key)

    # Open PDF
    print(f"📖 Opening PDF: {args.pdf}")
    doc = fitz.open(args.pdf)
    total_pages = len(doc)
    print(f"   Total pages: {total_pages}")

    start = args.start_page
    end = min(args.end_page, total_pages - 1)

    # Resume support
    if args.resume:
        last_done = load_progress(progress_path)
        if last_done >= start:
            print(f"📌 Resuming from page {last_done + 1} (pages {start}-{last_done} already done)")
            # Load existing output
            if os.path.exists(args.output):
                with open(args.output, 'r', encoding='utf-8') as f:
                    all_text = f.read()
            else:
                all_text = ""
            start = last_done + 1
        else:
            all_text = ""
    else:
        all_text = ""

    print(f"🚀 Processing pages {start} to {end} ({end - start + 1} pages)")
    print(f"   Model: {args.model}")
    print(f"   DPI: {args.dpi}")
    print(f"   Delay: {args.delay}s between calls")
    print(f"   Output: {args.output}")
    print(f"{'='*60}")

    success_count = 0
    fail_count = 0

    for page_num in range(start, end + 1):
        elapsed_pages = page_num - args.start_page
        total_to_do = end - args.start_page + 1
        pct = (elapsed_pages / total_to_do) * 100 if total_to_do > 0 else 0

        print(f"\n📄 Page {page_num + 1}/{total_pages} [{pct:.0f}% done]")

        # Render page
        image_bytes = render_page(doc, page_num, args.dpi)

        # Transcribe
        output = transcribe_page(client, args.model, image_bytes, page_num)

        # Append to result
        if all_text:
            all_text += "\n\n"
        all_text += output

        # Save progress after each page
        save_progress(args.output, progress_path, all_text, page_num)

        if "[ERROR:" not in output:
            success_count += 1
        else:
            fail_count += 1

        # Rate limiting delay
        if page_num < end:
            time.sleep(args.delay)

    doc.close()

    # Final summary
    print(f"\n{'='*60}")
    print(f"✅ COMPLETE!")
    print(f"   Pages processed: {end - args.start_page + 1}")
    print(f"   Successful: {success_count}")
    print(f"   Failed: {fail_count}")
    print(f"   Output: {args.output}")
    print(f"   Size: {len(all_text):,} chars")

    # Cleanup progress file on completion
    if fail_count == 0 and os.path.exists(progress_path):
        os.remove(progress_path)
        print(f"   Progress file cleaned up")


if __name__ == "__main__":
    main()
