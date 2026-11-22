Meru Tantra Volume 2 — Transcription Instructions
===================================================

PDF: D:\books pdf\Meru Tantram Edited By Shrinivas Sharma With Commentary Of Kapil Dev Narayan, Vol 2, (9-14) - Chaukhamba Sura Bharati Prakashan, Varanasi_text.pdf
Total PDF pages: 456
Content pages: PDF page 22 onwards (Prakasha 9 starts at PDF page 22)
Book page offset: Book page N = PDF index (N + 21) approximately
Prakashas covered: 9 through 14
Book Type: B (Hindi commentary / ಭಾಷಾಭಾಷ್ಯ)

Output directory: scratch/meru_tantram_v2_transcriptions/
Per-page files: page_NNN.txt (NNN = book page number, zero-padded 3 digits)
Final chapter files: assets/data/chapters/grantha_meru_tantram_vol2_prakasha_[9-14].txt

---

RULES — READ BEFORE EVERY PAGE
================================

All rules in .gemini/rules/transcription_rules.md apply FULLY.
The following are ADDITIONAL rules specific to Meru Tantra Vol 2.

1. BOOK TYPE B — NO MULA SECTION
   The source PDF has Hindi commentary (ಭಾಷಾಭಾಷ್ಯ), not Sanskrit.
   NEVER transliterate Hindi into Kannada script.
   SKIP the ಮೂಲ: sub-section entirely.
   Only write ಅನುವಾದ: — full Kannada translation of the Hindi commentary.

   Vyakhyana structure for this book:
   ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
   ಅನುವಾದ:
   <full Kannada translation of the Hindi commentary>

2. SECTION ORDER (MANDATORY)
   For every shloka:
   ಶ್ಲೋಕ N:
   <shloka text in Kannada script>

   ಭಾವಾರ್ಥ:
   <100+ words philosophical commentary>

   ಶಬ್ದಾರ್ಥ:
   <word-by-word meanings with vyakarana/grammar in brackets>

   ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
   ಅನುವಾದ:
   <Kannada translation of Hindi commentary>

   ----------------------------------------

3. SHABDARTHA FORMAT
   Every bullet MUST include vyakarana/grammar annotation in parentheses.
   Compound words MUST be decomposed with hyphens.

   Correct:
   • ಪ್ರಯೋಗಾತ್ — ಅನುಷ್ಠಾನದಿಂದ, ಪ್ರಯೋಗದಿಂದ (ಪಂಚಮೀ ವಿಭಕ್ತಿ)
   • ಪರ-ಲೋಕೇನ — ಪರಲೋಕದಿಂದ (ತತ್ಪುರುಷ ಸಮಾಸ, ತೃತೀಯಾ ವಿಭಕ್ತಿ)
   • ಭವೇತ್ — ಆಗಬಹುದು (ವಿಧಿಲಿಙ್ ಲಕಾರ, ಪ್ರಥಮ ಪುರುಷ, ಏಕವಚನ)

   Wrong (missing grammar):
   • ಪ್ರಯೋಗಾತ್ — ಅನುಷ್ಠಾನದಿಂದ
   • ಭವೇತ್ — ಆಗಬಹುದು

4. NO BOLD / NO STAR MARKS
   ZERO ** anywhere. ZERO * anywhere. Plain text only.

5. SHLOKA TRANSCRIPTION
   Source shlokas are in Devanagari. Convert character-by-character to Kannada script.
   Preserve all dandas as printed: use Devanagari danda characters ।॥
   Include shloka number as printed.
   Header format: ಶ್ಲೋಕ N: (number before colon)

6. VYAKHYANA / ANUVADA
   The Hindi commentary on each page MUST be fully translated into Kannada.
   Do NOT transliterate Hindi — TRANSLATE it into natural Kannada.
   Do NOT skip any sentence of the Hindi commentary.
   Do NOT summarize — translate EVERY sentence fully.
   Do NOT write ಮೂಲ: section — there is no Sanskrit mula for Type B books.

7. PRAKASHA HEADERS
   At the start of each new Prakasha, include the header:
   ಅಥ [ಸಂಖ್ಯೆ] ಪ್ರಕಾಶಃ ([ಹೆಸರು])

   Prakasha 9: ಅಥ ನವಮಃ ಪ್ರಕಾಶಃ (ಪಾರ್ಥಿವಪೂಜಾವಿಧಿವರ್ಣನಪ್ರಕಾಶಃ)
   Prakasha 10: ಅಥ ದಶಮಃ ಪ್ರಕಾಶಃ
   Prakasha 11: ಅಥ ಏಕಾದಶಃ ಪ್ರಕಾಶಃ
   Prakasha 12: ಅಥ ದ್ವಾದಶಃ ಪ್ರಕಾಶಃ
   Prakasha 13: ಅಥ ತ್ರಯೋದಶಃ ಪ್ರಕಾಶಃ
   Prakasha 14: ಅಥ ಚತುರ್ದಶಃ ಪ್ರಕಾಶಃ

8. PAGE CLASSIFICATION NOTES
   Many pages in this PDF have MIXED content — shlokas interspersed with Hindi commentary.
   Classify carefully:
   - If shloka verse text is present (with metre, numbered) → Type S
   - If only Hindi commentary prose continues → Type V
   - Most pages will be Type S since shlokas are frequent in this text

9. CONTINUATION FROM VOL 1
   Vol 1 covered Prakashas 1-8. Shloka numbering restarts at 1 in Prakasha 9.
   Each Prakasha has its own shloka numbering sequence.

10. VALIDATION
    After every page, run: python scripts/validate_page.py scratch/meru_tantram_v2_transcriptions/page_NNN.txt
    Fix all errors before proceeding to the next page.
    Git commit every 10 pages.

---

PROCESS PER PAGE
=================

1. Read the PDF page image (use page.get_pixmap(dpi=150))
2. Classify: Type S or Type V
3. Transcribe following ALL rules
4. Save to scratch/meru_tantram_v2_transcriptions/page_NNN.txt
5. Validate with python scripts/validate_page.py
6. If FAIL → fix and re-validate
7. If PASS → proceed to next page
8. Git commit every 10 pages

---

STARTING POINT
===============

Begin at PDF page 22 (book page 1, Prakasha 9).
Process ONE page per turn.
Continue until all 456 pages are done or stopped.
