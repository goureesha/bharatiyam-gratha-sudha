# Meru Tantram Vol 1 — Quick Start for Gemini

## Copy-paste this ENTIRE message into a NEW Gemini conversation:

---

You are helping me transcribe the Meru Tantram (मेरुतन्त्रम्) Vol 1 into Kannada script.

WORKSPACE: `d:\bharatheeyam books`
PAGE IMAGES: `d:\bharatheeyam books\scratch\meru_v1_pages\page_XXX.png`
SAVE TO: `d:\bharatheeyam books\scratch\meru_v1_transcriptions\page_XXX.txt`
RULES: `d:\bharatheeyam books\.gemini\rules\transcription_rules.md`

BOOK TYPE: B — Devanagari shlokas + Hindi commentary → ALL output in Kannada script

YOUR WORKFLOW for each page:
1. `read_file` the page PNG from `scratch/meru_v1_pages/page_XXX.png`
2. Identify shlokas (Sanskrit verses in bold/larger Devanagari) and Hindi commentary text
3. For each shloka on the page:
   - Transcribe shloka in Kannada script as PLAIN TEXT (no bold, no asterisks)
   - Write ಶಬ್ದಾರ್ಥ: with EVERY word as a plain text bullet (no bold, no asterisks)
   - Write ಭಾವಾರ್ಥ: (100+ words scholarly Kannada)
   - Write ವ್ಯಾಖ್ಯಾನ: with ಅನುವಾದ: (full Kannada translation of the Hindi commentary — NO Hindi transliteration needed)
4. `write_file` the output to `scratch/meru_v1_transcriptions/page_XXX.txt`
5. Move to next page

CRITICAL RULES:
- ZERO Devanagari in output — convert ALL to Kannada script
- ZERO markdown formatting — NO `**bold**`, NO `*italic*`, NO asterisks anywhere
- Output is PLAIN TEXT only — the only formatting: bullet `•`, separator `----------------------------------------`, section headers
- EVERY word gets shabdartha — no skipping
- Hindi commentary: just translate fully to Kannada (ಅನುವಾದ:) — NO Hindi transliteration needed
- Use `----------------------------------------` between shloka blocks

EXAMPLE FORMAT:

```
ಶ್ಲೋಕ ೧:

ಯಯಾಽಸತ್ಸದಿವಾಭಾತಿ ನ ಚ ಭಾತಿ ಕದಾಪಿ ಸತ್ ।
ಯಸ್ಮಿಞ್ಜ್ಞಾತೇ ನ ಸಾ ಭಾತಿ ತಸ್ಯೈ ತಸ್ಯೈ ನಮೋ ನಮಃ ॥೧॥

ಶಬ್ದಾರ್ಥ:

• ಯಯಾ — ಯಾವ ಪರಾಶಕ್ತಿಯಿಂದ (ಯದ್ ಸರ್ವನಾಮ, ಸ್ತ್ರೀಲಿಂಗ, ತೃತೀಯಾ ವಿಭಕ್ತಿ ಏಕವಚನ)
• ಅಸತ್ — ಮಿಥ್ಯಾರೂಪವಾದ ಪ್ರಪಂಚವು (ನಞ್ ತತ್ಪುರುಷ ಸಮಾಸ, ನಪುಂಸಕಲಿಂಗ, ಪ್ರಥಮಾ ವಿಭಕ್ತಿ ಏಕವಚನ)
• ಸದಿವ — ಸತ್ಯವಾದುದರಂತೆ (ಸತ್ + ಇವ, ಉಪಮಾವಾಚಕ ಅವ್ಯಯ)

ಭಾವಾರ್ಥ:

(100+ ಪದಗಳ ವಿದ್ವತ್ಪೂರ್ಣ ಕನ್ನಡ ವಿವರಣೆ)

ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:

ಅನುವಾದ:
(ಹಿಂದೀ ವ್ಯಾಖ್ಯಾನದ ಪೂರ್ಣ ಕನ್ನಡ ಅನುವಾದ)

----------------------------------------
```

Check progress: `python meru_v1_transcribe.py status`
Find next page: `python meru_v1_transcribe.py next`

Start by running `python meru_v1_transcribe.py status` to see where to begin, then start transcribing from the first pending page. Continue non-stop.

---

## To run as a /goal (overnight):

```
/goal

Transcribe the Meru Tantram Vol 1 book page by page.

For each page from 028 to 474:
1. Read the page image: d:\bharatheeyam books\scratch\meru_v1_pages\page_XXX.png
2. Transcribe following rules in d:\bharatheeyam books\.gemini\rules\transcription_rules.md
3. Book type B: Hindi vyakhyana — translate Hindi commentary fully to Kannada (ಅನುವಾದ: only, no Hindi transliteration)
4. Save output to: d:\bharatheeyam books\scratch\meru_v1_transcriptions\page_XXX.txt
5. Output is PLAIN TEXT only — NO bold (**), NO italic (*), NO markdown formatting

After completing all pages of a Prakasha, run:
  python meru_v1_transcribe.py assemble N

After all 8 Prakashas are assembled:
  python meru_v1_transcribe.py register
  python meru_v1_transcribe.py bump
  python meru_v1_transcribe.py commit "feat(scriptures): Add Meru Tantram Vol 1 (8 Prakashas)"

Check progress with: python meru_v1_transcribe.py status
Start from the first pending page. Continue non-stop until done.
```
