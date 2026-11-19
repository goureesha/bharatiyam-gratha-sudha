# =============================================================================
# MERU TANTRA VOL 1 — TRANSCRIPTION PROMPT FOR GEMINI
# =============================================================================
# Book: Meru Tantram (मेरुतन्त्रम्) Vol 1 — Prakasha 1-8
# Type: B (Devanagari shloka + Hindi vyakhyana → Kannada output)
# PDF: D:\books pdf\Meru Tantram Edited By Shrinivas Sharma With Commentary Of Kapil Dev Narayan, Vol 1, (1-8) - Chaukhamba Sura Bharati Prakashan, Varanasi_text.pdf
# Output: assets/data/chapters/
# =============================================================================

# CHAPTER MAP (0-indexed page numbers)
# ─────────────────────────────────────
# Prakasha 1: व्यवस्थाप्रकाशः    Pages 28-45   (18 pages)
# Prakasha 2: संस्कारप्रकाशः      Pages 46-90   (45 pages)
# Prakasha 3: दीक्षाप्रकाशः       Pages 91-182  (92 pages)
# Prakasha 4: होमविधिप्रकाशः      Pages 183-207 (25 pages)
# Prakasha 5: आह्निकप्रकाशः       Pages 208-342 (135 pages)
# Prakasha 6: पुरश्चर्याप्रकाशः    Pages 343-418 (76 pages)
# Prakasha 7: सिद्धिस्थिरीकरणप्रकाशः Pages 419-445 (27 pages)
# Prakasha 8: मुद्रालक्षणप्रकाशः   Pages 446-474 (29 pages)
# Total content pages: 28 to 474 (447 pages)

import fitz
import os, json, subprocess, re

# ═══════════════════════════════════════════════════════════════
# CONFIGURATION — Change these for different books/volumes
# ═══════════════════════════════════════════════════════════════
PDF_PATH = r"D:\books pdf\Meru Tantram Edited By Shrinivas Sharma With Commentary Of Kapil Dev Narayan, Vol 1, (1-8) - Chaukhamba Sura Bharati Prakashan, Varanasi_text.pdf"
WORKSPACE = r"d:\bharatheeyam books"
SCRATCH_DIR = os.path.join(WORKSPACE, "scratch", "meru_v1_transcriptions")
PAGES_DIR = os.path.join(WORKSPACE, "scratch", "meru_v1_pages")
CHAPTERS_DIR = os.path.join(WORKSPACE, "assets", "data", "chapters")
SCRIPTURE_ID = "grantha_meru_tantram_vol1"
SCRIPTURE_INDEX = os.path.join(WORKSPACE, "assets", "data", "scriptures_index.json")
PUBSPEC = os.path.join(WORKSPACE, "pubspec.yaml")
DPI = 300

# Chapter definitions: (prakasha_num, start_page, end_page, devanagari_name, kannada_name)
CHAPTERS = [
    (1,  28,  45,  "व्यवस्थाप्रकाशः",          "ವ್ಯವಸ್ಥಾಪ್ರಕಾಶಃ"),
    (2,  46,  90,  "संस्कारप्रकाशः",            "ಸಂಸ್ಕಾರಪ್ರಕಾಶಃ"),
    (3,  91,  182, "दीक्षाप्रकाशः",             "ದೀಕ್ಷಾಪ್ರಕಾಶಃ"),
    (4,  183, 207, "होमविधिप्रकाशः",            "ಹೋಮವಿಧಿಪ್ರಕಾಶಃ"),
    (5,  208, 342, "आह्निकप्रकाशः",             "ಆಹ್ನಿಕಪ್ರಕಾಶಃ"),
    (6,  343, 418, "पुरश्चर्याप्रकाशः",          "ಪುರಶ್ಚರ್ಯಾಪ್ರಕಾಶಃ"),
    (7,  419, 445, "सिद्धिस्थिरीकरणप्रकाशः",    "ಸಿದ್ಧಿಸ್ಥಿರೀಕರಣಪ್ರಕಾಶಃ"),
    (8,  446, 474, "मुद्रालक्षणप्रकाशः",         "ಮುದ್ರಾಲಕ್ಷಣಪ್ರಕಾಶಃ"),
]


# ═══════════════════════════════════════════════════════════════
# STEP 1: Pre-render all content pages as PNGs
# ═══════════════════════════════════════════════════════════════
def render_pages():
    """Render all content pages (28-474) as PNG images at 300 DPI."""
    os.makedirs(PAGES_DIR, exist_ok=True)
    os.makedirs(SCRATCH_DIR, exist_ok=True)
    
    doc = fitz.open(PDF_PATH)
    total = 474 - 28 + 1
    rendered = 0
    skipped = 0
    
    for pg in range(28, 475):
        out_path = os.path.join(PAGES_DIR, f"page_{pg:03d}.png")
        if os.path.exists(out_path):
            skipped += 1
            continue
        pix = doc[pg].get_pixmap(dpi=DPI)
        pix.save(out_path)
        rendered += 1
        if rendered % 50 == 0:
            print(f"  Rendered {rendered}/{total - skipped} pages...")
    
    doc.close()
    print(f"Done! Rendered {rendered} new pages, skipped {skipped} existing. Total: {total}")
    return True


# ═══════════════════════════════════════════════════════════════
# STEP 2: Transcription Prompt Template (for Gemini)
# ═══════════════════════════════════════════════════════════════
TRANSCRIPTION_PROMPT = """
You are transcribing the Meru Tantram (मेरुतन्त्रम्) — a tantric scripture with 
Devanagari shlokas and Hindi commentary (भाषाभाष्य).

## YOUR TASK
Read the attached page image carefully. Transcribe it into Kannada script following 
these STRICT rules:

## RULES

### Script
- Output ONLY in Kannada script (ಕನ್ನಡ). ZERO Devanagari characters anywhere.
- Convert ALL Devanagari text → Kannada equivalent
- Use Kannada avagraha ಽ (not Devanagari ऽ)

### Shloka Lines — PLAIN TEXT
- Write each shloka line as PLAIN TEXT — NO bold, NO asterisks, NO markdown
- Transcribe EXACTLY as printed — every syllable, every word
- Include the shloka number
- ❌ Do NOT wrap shloka lines in `**...**`

### Shabdartha (ಶಬ್ದಾರ್ಥ) — EVERY WORD
- List EVERY word/compound from the shloka as bullet points
- Format: `• ಸಂಸ್ಕೃತ ಶಬ್ದ — ಕನ್ನಡ ಅರ್ಥ (ವಿಭಕ್ತಿ/ವ್ಯಾಕರಣ, ಸಮಾಸ ಪ್ರಕಾರ)`
- Write shabda word as PLAIN TEXT — NO bold, NO asterisks
- NEVER skip any word. NEVER write "ಇತ್ಯಾದಿ" or "ಮುಂತಾದ" to skip.
- NEVER use "..." or "…" (ellipsis)

### Bhavartha (ಭಾವಾರ್ಥ) — MANDATORY
- Write a COMPLETE explanation in Kannada (minimum 100 words)
- Explain the philosophical/spiritual significance
- Connect to the flow of the chapter

### Vyakhyana (ವ್ಯಾಖ್ಯಾನ) — MANDATORY  
- The Hindi commentary (भाषाभाष्य) must be TRANSLATED to Kannada
- NO Hindi transliteration needed — skip ಮೂಲ: section entirely
- Write ONLY `ಅನುವಾದ:` — Complete Kannada translation of the Hindi commentary
- Translate EVERY sentence of the Hindi commentary into Kannada
- Do NOT summarize — translate the FULL commentary

### Format
```
ಶ್ಲೋಕ N:

ಶ್ಲೋಕ ಮೊದಲ ಸಾಲು ।
ಶ್ಲೋಕ ಎರಡನೇ ಸಾಲು ॥N॥

ಶಬ್ದಾರ್ಥ:

• ಶಬ್ದ೧ — ಅರ್ಥ (ವಿಭಕ್ತಿ, ಸಮಾಸ)
• ಶಬ್ದ೨ — ಅರ್ಥ (ವಿಭಕ್ತಿ)

ಭಾವಾರ್ಥ:

(100+ words scholarly Kannada explanation)

ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:

ಅನುವಾದ:
(Full Kannada translation of the Hindi commentary)

----------------------------------------
```

### NO MARKDOWN FORMATTING
- ❌ Do NOT use `**...**` (bold) anywhere in the output
- ❌ Do NOT use `*...*` (italic) anywhere in the output
- ❌ Output is PLAIN TEXT only

### ABSOLUTE PROHIBITIONS
- ❌ NEVER skip any word in shabdartha
- ❌ NEVER use ellipsis (... or …)  
- ❌ NEVER summarize when you should transcribe
- ❌ NEVER write "as mentioned above" to skip content
- ❌ NEVER reduce bhavartha below 70 words
- ❌ NEVER use Devanagari script
- ❌ NEVER use English words in output
- ❌ NEVER skip the vyakhyana section
- ❌ NEVER use bold/italic markdown (`**`, `*`)

## PAGE INFO
This is page {page_num} of Meru Tantram Vol 1, from {chapter_name} (Prakasha {prakasha_num}).
Previous page ended with: {prev_context}

Now transcribe this page image completely:
"""


# ═══════════════════════════════════════════════════════════════
# STEP 3: Process one page (called by Gemini)
# ═══════════════════════════════════════════════════════════════
def get_chapter_for_page(page_num):
    """Return (prakasha_num, devanagari_name, kannada_name) for a given page."""
    for pnum, start, end, dname, kname in CHAPTERS:
        if start <= page_num <= end:
            return pnum, dname, kname
    return None, None, None


def get_prev_context(page_num):
    """Read last 2 lines of previous page transcription for context."""
    prev_file = os.path.join(SCRATCH_DIR, f"page_{page_num - 1:03d}.txt")
    if os.path.exists(prev_file):
        with open(prev_file, 'r', encoding='utf-8') as f:
            lines = [l.strip() for l in f.readlines() if l.strip()]
            return ' '.join(lines[-2:]) if len(lines) >= 2 else lines[-1] if lines else "(start of chapter)"
    return "(start of chapter or previous page not yet transcribed)"


def save_page_transcription(page_num, text):
    """Save a single page transcription to scratch."""
    os.makedirs(SCRATCH_DIR, exist_ok=True)
    path = os.path.join(SCRATCH_DIR, f"page_{page_num:03d}.txt")
    with open(path, 'w', encoding='utf-8') as f:
        f.write(text)
    print(f"Saved: {path}")


def get_pending_pages():
    """List pages that haven't been transcribed yet."""
    done = set()
    if os.path.exists(SCRATCH_DIR):
        for fname in os.listdir(SCRATCH_DIR):
            if fname.startswith("page_") and fname.endswith(".txt"):
                num = int(fname[5:8])
                # Check file isn't empty
                fpath = os.path.join(SCRATCH_DIR, fname)
                if os.path.getsize(fpath) > 50:
                    done.add(num)
    
    pending = []
    for pnum, start, end, dname, kname in CHAPTERS:
        for pg in range(start, end + 1):
            if pg not in done:
                pending.append(pg)
    
    return pending, done


# ═══════════════════════════════════════════════════════════════
# STEP 4: Assemble chapter files from per-page transcriptions
# ═══════════════════════════════════════════════════════════════
def assemble_chapter(prakasha_num):
    """Assemble all page transcriptions for a prakasha into one chapter file."""
    for pnum, start, end, dname, kname in CHAPTERS:
        if pnum != prakasha_num:
            continue
        
        chapter_text = []
        chapter_text.append(f"॥ ಶ್ರೀಃ ॥\n")
        chapter_text.append(f"॥ ಶ್ರೀಮಹಾಮಾಯಾ-ಮಹಾಕಾಲಾನುಮತ ಮೇರುತಂತ್ರಮ್ ॥\n")
        chapter_text.append(f"ಅಥ ಪ್ರಕಾಶಃ {pnum} — {kname}\n")
        chapter_text.append("=" * 50 + "\n\n")
        
        missing = []
        for pg in range(start, end + 1):
            page_file = os.path.join(SCRATCH_DIR, f"page_{pg:03d}.txt")
            if os.path.exists(page_file) and os.path.getsize(page_file) > 50:
                with open(page_file, 'r', encoding='utf-8') as f:
                    chapter_text.append(f.read().strip())
                    chapter_text.append("\n\n")
            else:
                missing.append(pg)
        
        if missing:
            print(f"WARNING: Missing pages for Prakasha {pnum}: {missing}")
            print(f"Assemble aborted. Complete these pages first.")
            return False
        
        # Write chapter file
        os.makedirs(CHAPTERS_DIR, exist_ok=True)
        chapter_id = f"{SCRIPTURE_ID}_prakasha_{pnum}"
        chapter_path = os.path.join(CHAPTERS_DIR, f"{chapter_id}.txt")
        
        with open(chapter_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(chapter_text))
        
        print(f"Assembled Prakasha {pnum} ({end - start + 1} pages) → {chapter_path}")
        return True
    
    print(f"Prakasha {prakasha_num} not found!")
    return False


# ═══════════════════════════════════════════════════════════════
# STEP 5: Register in scriptures_index.json
# ═══════════════════════════════════════════════════════════════
def register_scripture():
    """Add or update Meru Tantram Vol 1 entry in scriptures_index.json with assembled chapters only."""
    with open(SCRIPTURE_INDEX, 'r', encoding='utf-8') as f:
        index = json.load(f)
    
    # Build chapter list for assembled chapters only
    chapters_list = []
    for pnum, start, end, dname, kname in CHAPTERS:
        chapter_id = f"{SCRIPTURE_ID}_prakasha_{pnum}"
        chapter_path = os.path.join(CHAPTERS_DIR, f"{chapter_id}.txt")
        if os.path.exists(chapter_path):
            chapters_list.append({
                "id": chapter_id,
                "title": f"ಅಥ ಪ್ರಕಾಶಃ {pnum} — {kname}"
            })
    
    if not chapters_list:
        print("No assembled chapter files found to register.")
        return False

    # Update existing entry or append new one
    for entry in index:
        if entry["id"] == SCRIPTURE_ID:
            entry["chapters"] = chapters_list
            with open(SCRIPTURE_INDEX, 'w', encoding='utf-8') as f:
                json.dump(index, f, ensure_ascii=False, indent=2)
            print(f"Updated {SCRIPTURE_ID} with {len(chapters_list)} assembled chapter(s)")
            return True
    
    new_entry = {
        "id": SCRIPTURE_ID,
        "title": "ಮೇರುತಂತ್ರಮ್ (ಭಾಗ ೧)",
        "titleEn": "Meru Tantram Vol 1",
        "category": "grantha",
        "icon": "📜",
        "chapters": chapters_list
    }
    
    index.append(new_entry)
    
    with open(SCRIPTURE_INDEX, 'w', encoding='utf-8') as f:
        json.dump(index, f, ensure_ascii=False, indent=2)
    
    print(f"Registered {SCRIPTURE_ID} with {len(chapters_list)} assembled chapter(s)")
    return True


# ═══════════════════════════════════════════════════════════════
# STEP 6: Bump version in pubspec.yaml
# ═══════════════════════════════════════════════════════════════
def bump_version():
    """Increment build number in pubspec.yaml."""
    with open(PUBSPEC, 'r', encoding='utf-8') as f:
        content = f.read()
    
    match = re.search(r'version:\s*(\d+\.\d+\.\d+)\+(\d+)', content)
    if not match:
        print("Could not find version in pubspec.yaml!")
        return False
    
    version = match.group(1)
    build = int(match.group(2))
    new_build = build + 1
    new_version_str = f"version: {version}+{new_build}"
    
    content = re.sub(r'version:\s*\d+\.\d+\.\d+\+\d+', new_version_str, content)
    
    with open(PUBSPEC, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"Version bumped: {version}+{build} → {version}+{new_build}")
    return True


# ═══════════════════════════════════════════════════════════════
# STEP 7: Git commit and push
# ═══════════════════════════════════════════════════════════════
def git_commit_push(message):
    """Stage, commit, and push changes."""
    os.chdir(WORKSPACE)
    
    # Stage specific files
    subprocess.run(["git", "add", "assets/data/chapters/", "assets/data/scriptures_index.json", "pubspec.yaml"], check=True)
    
    # Commit
    result = subprocess.run(["git", "commit", "-m", message], capture_output=True, text=True)
    print(result.stdout)
    
    # Push
    result = subprocess.run(["git", "push", "origin", "main"], capture_output=True, text=True)
    print(result.stdout or result.stderr)
    
    return True


# ═══════════════════════════════════════════════════════════════
# STEP 8: Status check
# ═══════════════════════════════════════════════════════════════
def status():
    """Print current progress."""
    pending, done = get_pending_pages()
    total = sum(end - start + 1 for _, start, end, _, _ in CHAPTERS)
    
    print(f"\n{'='*60}")
    print(f"MERU TANTRAM VOL 1 — TRANSCRIPTION STATUS")
    print(f"{'='*60}")
    print(f"Total pages:      {total}")
    print(f"Completed:        {len(done)}")
    print(f"Pending:          {len(pending)}")
    print(f"Progress:         {len(done)/total*100:.1f}%")
    
    print(f"\nPer-chapter breakdown:")
    for pnum, start, end, dname, kname in CHAPTERS:
        ch_total = end - start + 1
        ch_done = len([p for p in range(start, end + 1) if p in done])
        bar = "█" * int(ch_done/ch_total * 20) + "░" * (20 - int(ch_done/ch_total * 20))
        status_str = "✅" if ch_done == ch_total else "🔄" if ch_done > 0 else "⏳"
        print(f"  {status_str} Prakasha {pnum}: {kname}")
        print(f"     [{bar}] {ch_done}/{ch_total} pages")
    
    if pending:
        next_page = pending[0]
        pnum, dname, kname = get_chapter_for_page(next_page)
        print(f"\n→ NEXT: Page {next_page} (Prakasha {pnum} — {kname})")
        print(f"  Image: {PAGES_DIR}\\page_{next_page:03d}.png")
    else:
        print(f"\n🎉 ALL PAGES TRANSCRIBED!")
    
    print(f"{'='*60}\n")


# ═══════════════════════════════════════════════════════════════
# MAIN — Run from command line
# ═══════════════════════════════════════════════════════════════
if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python meru_v1_transcribe.py render       — Pre-render all pages as PNG")
        print("  python meru_v1_transcribe.py status       — Show progress")
        print("  python meru_v1_transcribe.py next         — Show next page to transcribe")
        print("  python meru_v1_transcribe.py assemble N   — Assemble Prakasha N")
        print("  python meru_v1_transcribe.py register     — Register in scriptures_index.json")
        print("  python meru_v1_transcribe.py bump         — Bump pubspec.yaml version")
        print("  python meru_v1_transcribe.py commit MSG   — Git commit and push")
        print("  python meru_v1_transcribe.py prompt N     — Generate transcription prompt for page N")
        sys.exit(0)
    
    cmd = sys.argv[1]
    
    if cmd == "render":
        render_pages()
    
    elif cmd == "status":
        status()
    
    elif cmd == "next":
        pending, _ = get_pending_pages()
        if pending:
            pg = pending[0]
            pnum, dname, kname = get_chapter_for_page(pg)
            print(f"Next page: {pg}")
            print(f"Chapter: Prakasha {pnum} — {kname}")
            print(f"Image: {PAGES_DIR}\\page_{pg:03d}.png")
        else:
            print("All done!")
    
    elif cmd == "assemble":
        if len(sys.argv) < 3:
            print("Usage: python meru_v1_transcribe.py assemble <prakasha_number>")
        else:
            assemble_chapter(int(sys.argv[2]))
    
    elif cmd == "register":
        register_scripture()
    
    elif cmd == "bump":
        bump_version()
    
    elif cmd == "commit":
        msg = ' '.join(sys.argv[2:]) if len(sys.argv) > 2 else "feat(scriptures): Add Meru Tantram Vol 1 chapter"
        git_commit_push(msg)
    
    elif cmd == "prompt":
        if len(sys.argv) < 3:
            print("Usage: python meru_v1_transcribe.py prompt <page_number>")
        else:
            pg = int(sys.argv[2])
            pnum, dname, kname = get_chapter_for_page(pg)
            prev = get_prev_context(pg)
            prompt = TRANSCRIPTION_PROMPT.format(
                page_num=pg,
                chapter_name=kname,
                prakasha_num=pnum,
                prev_context=prev
            )
            print(prompt)
    
    else:
        print(f"Unknown command: {cmd}")
