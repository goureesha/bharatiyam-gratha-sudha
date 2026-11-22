# Sanskrit-Kannada Transcription Rules — STRICT ENFORCEMENT

These rules are MANDATORY and NON-NEGOTIABLE. Every single transcription output
MUST comply with EVERY rule listed below. Violation of ANY rule is a FAILURE.

---

## SECTION 1: PAGE TYPE CLASSIFICATION

Before transcribing ANY page, FIRST classify it. The classification determines
which sections are allowed.

### Type S — Shloka Page
A page that contains one or more numbered Sanskrit shlokas (verses in metre).
The shloka text is typically in Devanagari, set apart from surrounding prose.

Required output sections IN THIS EXACT ORDER:
1. [ಪುಟ: NNN] — page number in Kannada numerals
2. For EACH shloka on the page:
   a. ಶ್ಲೋಕ N: — shloka number (note: number BEFORE the colon)
   b. Full shloka text in Kannada script
   c. ಭಾವಾರ್ಥ: — philosophical commentary (COMES FIRST)
   d. ಶಬ್ದಾರ್ಥ: — word-by-word meanings with grammar (COMES AFTER Bhavartha)
3. If the page also has vyakhyana prose surrounding the shlokas:
   a. ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
   b. ಮೂಲ: — full Sanskrit commentary in Kannada script (Type A books only)
   c. ಅನುವಾದ: — full Kannada translation of the commentary

### Type V — Vyakhyana-Only Page (Prose Page)
A page that has NO shloka — only continuing Sanskrit commentary prose.

Required output sections IN THIS EXACT ORDER:
1. [ಪುಟ: NNN] — page number in Kannada numerals
2. ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
3. ಮೂಲ: — full Sanskrit commentary in Kannada script
4. ಅನುವಾದ: — full Kannada translation of the commentary

PROHIBITED on Type V pages:
- ❌ ಶ್ಲೋಕ: section — there is no shloka to transcribe
- ❌ ಶಬ್ದಾರ್ಥ: section — there are no shloka words to define
- ❌ ಭಾವಾರ್ಥ: section — Bhavartha is ONLY for shlokas

### Type D — Diagram/Yantra Page
A page that primarily contains a yantra, mandala, or diagram.

Required output:
1. [ಪುಟ: NNN]
2. [ಚಿತ್ರ: path | description]
3. If the page also contains shlokas or vyakhyana, include those per Type S/V.

### CLASSIFICATION RULE
- If you see verse text with metre and a shloka number → Type S
- If you see only running Sanskrit prose (commentary) with no verse → Type V
- If unsure → treat as Type V (conservative; never invent a shloka)

---

## SECTION 2: SHLOKA TRANSCRIPTION

- Transcribe EVERY syllable EXACTLY as printed in the PDF
- Use ONLY Kannada script — ZERO Devanagari characters
- Use Kannada avagraha ಽ (not Devanagari ऽ)
- Preserve ALL dandas as printed: use ।(single) and ॥ (double) from Devanagari danda characters
- Write as PLAIN TEXT — no bold, no asterisks, no markdown formatting
- NEVER skip, merge, combine, paraphrase, or reword any shloka text
- NEVER invent or fabricate a shloka that does not exist on the page
- Include the shloka number as printed in the book

---

## SECTION 3: SHABDARTHA (ಶಬ್ದಾರ್ಥ)

NOTE: Shabdartha comes AFTER Bhavartha. The section order per shloka is:
ಶ್ಲೋಕ → ಭಾವಾರ್ಥ → ಶಬ್ದಾರ್ಥ → ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ

### What to include
- One bullet per word or compound from the shloka
- Format: • ಸಂಸ್ಕೃತ-ಶಬ್ದ — ಕನ್ನಡ ಅರ್ಥ (ವ್ಯಾಕರಣ ವಿವರ)
- The Sanskrit word on the left (with samasa decomposition using hyphens for
  compound words), em-dash, Kannada meaning, then grammar annotation in brackets
- Every word in the shloka MUST have its own bullet. If the shloka has 12 words,
  there must be at least 12 bullets

### VYAKARANA / GRAMMAR ANNOTATIONS — REQUIRED
Grammar annotations in parentheses at the end of each Shabdartha bullet are
MANDATORY. Include whichever are applicable:

- Vibhakti: (ಪ್ರಥಮಾ ವಿಭಕ್ತಿ), (ದ್ವಿತೀಯಾ ವಿಭಕ್ತಿ), (ತೃತೀಯಾ ವಿಭಕ್ತಿ),
  (ಚತುರ್ಥೀ ವಿಭಕ್ತಿ), (ಪಂಚಮೀ ವಿಭಕ್ತಿ), (ಷಷ್ಠೀ ವಿಭಕ್ತಿ), (ಸಪ್ತಮೀ ವಿಭಕ್ತಿ)
- Vachana: ಏಕವಚನ, ದ್ವಿವಚನ, ಬಹುವಚನ
- Purusha: ಪ್ರಥಮ ಪುರುಷ, ಮಧ್ಯಮ ಪುರುಷ, ಉತ್ತಮ ಪುರುಷ
- Lakara (verb tense/mood): ಲಟ್ ಲಕಾರ, ಲೋಟ್ ಲಕಾರ, ವಿಧಿಲಿಙ್ ಲಕಾರ, ಲಙ್ ಲಕಾರ, etc.
- Samasa type: ತತ್ಪುರುಷ ಸಮಾಸ, ಬಹುವ್ರೀಹಿ ಸಮಾಸ, ಕರ್ಮಧಾರಯ ಸಮಾಸ,
  ದ್ವಂದ್ವ ಸಮಾಸ, ಅವ್ಯಯೀಭಾವ ಸಮಾಸ, ದ್ವಿಗು ಸಮಾಸ
- Avyaya: ಲ್ಯಬನ್ತ ಅವ್ಯಯ, ಕ್ತ್ವಾನ್ತ ಅವ್ಯಯ, etc.
- Pratyaya: ಕೃದಂತ, ತದ್ಧಿತ, etc.
- Multiple annotations may be combined: (ವಿಧಿಲಿಙ್ ಲಕಾರ, ಪ್ರಥಮ ಪುರುಷ, ಏಕವಚನ)

### Samasa decomposition
For compound words, decompose using hyphens to show individual components:
- ಶುಕ್ಲ-ಅಂಬರ-ಧರಂ (not ಶುಕ್ಲಾಂಬರಧರಂ)
- ಶಶಿ-ವರ್ಣಂ (not ಶಶಿವರ್ಣಂ)
- ಪ್ರಸನ್ನ-ವದನಂ (not ಪ್ರಸನ್ನವದನಂ)
- ಸರ್ವ-ವಿಘ್ನ-ಉಪಶಾಂತಯೇ (not ಸರ್ವವಿಘ್ನೋಪಶಾಂತಯೇ)

### CORRECT EXAMPLE:
• ಶುಕ್ಲ-ಅಂಬರ-ಧರಂ — ಪರಿಶುದ್ಧವಾದ ಶ್ವೇತವಸ್ತ್ರವನ್ನು ಧರಿಸಿರುವವನು (ಬಹುವ್ರೀಹಿ ಸಮಾಸ)
• ವಿಷ್ಣುಂ — ಸರ್ವವ್ಯಾಪಕನಾದ ಪರಮಾತ್ಮನನ್ನು (ದ್ವಿತೀಯಾ ವಿಭಕ್ತಿ)
• ಧ್ಯಾಯೇತ್ — ಏಕಾಗ್ರಚಿತ್ತದಿಂದ ಧ್ಯಾನಿಸಬೇಕು (ವಿಧಿಲಿಙ್ ಲಕಾರ, ಪ್ರಥಮ ಪುರುಷ, ಏಕವಚನ)

### WRONG EXAMPLE (NEVER DO THIS — no grammar, no decomposition):
• ನಮಃ — ನಮಸ್ಕಾರವು
• ಶಿವಾಯ — ಶಿವನಿಗೆ

### Other Shabdartha prohibitions
- NEVER write "ಇತ್ಯಾದಿ", "ಮುಂತಾದ", or "etc." to skip words
- NEVER use "..." or "..." (ellipsis) to abbreviate
- NEVER skip any word — EVERY word must be listed
- NEVER use bold or asterisks on the word

---

## SECTION 4: BHAVARTHA (ಭಾವಾರ್ಥ)

### When to write Bhavartha
- ONLY for shloka pages (Type S)
- Bhavartha comes IMMEDIATELY AFTER the shloka text, BEFORE Shabdartha
- ONE Bhavartha per shloka — NEVER two Bhavarthas for the same shloka
- NEVER write Bhavartha on vyakhyana-only (Type V) pages

### ONE BHAVARTHA PER SHLOKA — NO DUPLICATES
- Each shloka gets EXACTLY ONE ಭಾವಾರ್ಥ: section
- NEVER write ಭಾವಾರ್ಥ: twice for the same shloka
- If you have already written ಭಾವಾರ್ಥ: for a shloka, DO NOT write it again

### Content requirements
- Minimum 100 words of GENUINE, ORIGINAL philosophical commentary
- MUST explain the deeper spiritual/philosophical meaning of the shloka
- MUST connect to the broader context of the chapter/patala
- MUST be specific to THIS particular shloka's content
- Write in natural flowing Kannada prose

### What Bhavartha must NOT be
- ❌ NOT a rephrasing of Shabdartha in sentence form
- ❌ NOT a mere word-for-word paraphrase of the shloka
- ❌ NOT padded with generic filler sentences

### BANNED FILLER / BOILERPLATE PATTERNS
The following sentence patterns are BANNED. NEVER use them. They are generic
padding that could apply to any shloka and add zero value.

BANNED PATTERN LIST (do NOT use these or any variation of them):
1. "ಆಧ್ಯಾತ್ಮಿಕ ಸಾಧನೆಯ ಮಾರ್ಗದಲ್ಲಿ ಇದು ಅತ್ಯಂತ ಮಹತ್ವಪೂರ್ಣವಾಗಿದೆ"
2. "ಸಾಧಕನ ಆಧ್ಯಾತ್ಮಿಕ ಪ್ರಗತಿಗೆ ಇದು ಅನಿವಾರ್ಯವಾಗಿದೆ"
3. "ಈ ರಹಸ್ಯವನ್ನು ಅರಿತ ಸಾಧಕನು ಪರಮ ಸಿದ್ಧಿಯನ್ನು ಪಡೆಯುತ್ತಾನೆ"
4. "ತಂತ್ರಶಾಸ್ತ್ರದ ಈ ಅಮೂಲ್ಯ ರಹಸ್ಯವನ್ನು ಗುರುಮುಖೇನ ಮಾತ್ರ ತಿಳಿಯಬೇಕು"
5. "ದಿವ್ಯ ಅನುಗ್ರಹವು ಸಾಧಕನಿಗೆ ಲಭಿಸುತ್ತದೆ"
6. "ಈ ಮಹಾರಹಸ್ಯವನ್ನು ತಿಳಿದ ಸಾಧಕನು ..."
7. "ಸಾಧಕನ ಸಮಸ್ತ ಇಷ್ಟಾರ್ಥಗಳೂ ಅಡೆತಡೆಯಿಲ್ಲದೆ ಸಿದ್ಧಿಸುತ್ತವೆ"
8. "ತಂತ್ರಾಗಮಗಳ ಈ ಪರಮ ರಹಸ್ಯವು ..."
9. "ಈ ವಿದ್ಯೆಯ ಮಹಿಮೆಯು ಅಪಾರವಾಗಿದೆ"
10. "ಗುರೂಪದೇಶ ಪರಂಪರೆಯಿಂದ ಮಾತ್ರ ಈ ರಹಸ್ಯವನ್ನು ಪಡೆಯಬಹುದು"

THE TEST: If a sentence could be copy-pasted into ANY other shloka's Bhavartha
without changing it, it is GENERIC FILLER and MUST NOT be written. Every sentence
in Bhavartha must be SPECIFIC to the shloka it belongs to.

### How to write GOOD Bhavartha
- Explain WHAT the shloka teaches that is unique
- Explain WHY this instruction matters in the specific ritual context
- Connect to the previous shloka and the next one — show the flow
- Reference specific Sanskrit technical terms from the shloka and explain their deeper import
- If the shloka describes a mantra procedure, explain the metaphysical reason behind it
- If the shloka describes yantra placement, explain the cosmic principle involved

---

## SECTION 5: VYAKHYANA (ವ್ಯಾಖ್ಯಾನ)

### Structure
The Vyakhyana section MUST have this header:
```
ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
```

Under it, two sub-sections:
1. `ಮೂಲ:` — The original Sanskrit commentary transcribed in Kannada script
2. `ಅನುವಾದ:` — Full Kannada translation of the commentary

### Mula (ಮೂಲ:) rules
- Transcribe the FULL Sanskrit commentary text from the PDF page
- Convert from Devanagari to Kannada script — character by character
- NEVER skip, shorten, summarize, or paraphrase the commentary
- NEVER write "ಇತ್ಯಾದಿ" or "..." to skip portions
- Include EVERY sentence of commentary on that page
- If commentary continues from a previous page, start from where the previous page ended
- If commentary continues to the next page, transcribe up to the end of this page

### Anuvada (ಅನುವಾದ:) rules
- Translate EVERY sentence of the ಮೂಲ into Kannada
- Do NOT skip any sentence
- Do NOT summarize multiple sentences into one
- Do NOT shorten the translation — it must be COMPLETE
- The translation must be in natural, flowing Kannada prose
- Maintain the same order of content as the original

---

## SECTION 6: LANGUAGE RULES

### Script: Kannada ONLY
- ALL output text must be in Kannada script
- ZERO Devanagari characters (except dandas ।॥ which are shared)
- ZERO English words anywhere in the transcription output
- ZERO Hindi words
- ZERO Roman/Latin script characters

### BANNED ENGLISH WORDS (examples found in past errors)
- ❌ "the", "and", "of", "in", "is", "this", "that", "which", "for", "with"
- ❌ "mantra", "yantra", "tantra" (use ಮಂತ್ರ, ಯಂತ್ರ, ತಂತ್ರ)
- ❌ "deity", "ritual", "worship" (use ದೇವತೆ, ವಿಧಿ, ಪೂಜೆ)
- ❌ "etc.", "i.e.", "e.g.", "viz."
- ❌ ANY English word at all — if you catch yourself writing in English, STOP and rewrite in Kannada

---

## SECTION 7: FORMATTING RULES

### Plain text ONLY
- ❌ NEVER use `**...**` (markdown bold)
- ❌ NEVER use `*...*` (markdown italic)
- ❌ NEVER use `# heading` markdown
- ❌ NEVER use any markdown formatting in the output
- The output is PLAIN TEXT

### Separators
- Use EXACTLY one line of 40 hyphens between shloka blocks:
  `----------------------------------------`
- NEVER use double separators (two separator lines with only whitespace between them)
- NEVER use `---` (three hyphens) — always use the full 40-hyphen line

### WRONG (double separator):
```
----------------------------------------

----------------------------------------
```

### CORRECT (single separator):
```
----------------------------------------
```

### Section headers
- Write section headers as plain text, no formatting:
  - ಶ್ಲೋಕ N: (number before colon, e.g. ಶ್ಲೋಕ 1:)
  - ಭಾವಾರ್ಥ:
  - ಶಬ್ದಾರ್ಥ:
  - `ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:`
  - `ಮೂಲ:`
  - `ಅನುವಾದ:`

### Page marker
- First line of every file: `[ಪುಟ: NNN]` with page number in Kannada numerals
- Use Kannada numerals: ೧, ೨, ೩, ೪, ೫, ೬, ೭, ೮, ೯, ೦

### Diagram/Image marker
- Format: `[ಚಿತ್ರ: path | description]`
- Use only when the page contains a yantra, mandala, or diagram

---

## SECTION 8: STRUCTURAL INTEGRITY

### Order of sections per shloka on a shloka page
1. ಶ್ಲೋಕ N: (shloka text)
2. ಭಾವಾರ್ಥ: (philosophical commentary — COMES FIRST)
3. ಶಬ್ದಾರ್ಥ: (word meanings with grammar — COMES AFTER Bhavartha)

Then, if the page has vyakhyana prose:
4. ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
5. ಮೂಲ: (Type A books only — skip for Type B)
6. ಅನುವಾದ:

Then a single separator line, then the next shloka.

### Order of sections on a vyakhyana-only page
1. [ಪುಟ: NNN]
2. ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
3. ಮೂಲ: (Type A books only — skip for Type B)
4. ಅನುವಾದ:
5. Single separator line

### NEVER invert the order
- Shloka must come first
- Bhavartha must come BEFORE Shabdartha
- Shabdartha must come AFTER Bhavartha
- Anuvada must come after Mula (if Mula exists)

---

## SECTION 9: WHAT NEVER TO DO — ABSOLUTE PROHIBITIONS

1. ❌ NEVER add Shabdartha to a vyakhyana-only page
2. ❌ NEVER add Bhavartha to a vyakhyana-only page
3. ❌ NEVER write TWO Bhavarthas for the same shloka
4. NEVER put Shabdartha BEFORE Bhavartha — Bhavartha comes first
5. ❌ NEVER use English words in the output
6. ❌ NEVER use Devanagari script (except dandas)
7. ❌ NEVER use markdown bold/italic/heading formatting
8. ❌ NEVER use ellipsis (... or ...)
9. ❌ NEVER write "ಇತ್ಯಾದಿ" to skip content
10. ❌ NEVER write "as mentioned above" to skip content
11. ❌ NEVER use double separator lines
12. ❌ NEVER use generic boilerplate filler sentences in Bhavartha
13. ❌ NEVER skip words in Shabdartha
14. ❌ NEVER shorten or summarize the Vyakhyana Mula or Anuvada
15. ❌ NEVER invent a shloka that does not exist on the PDF page
16. ❌ NEVER skip the Vyakhyana section when commentary exists on the page
17. ❌ NEVER reduce Bhavartha below 100 words
18. ❌ NEVER write Bhavartha that is just a paraphrase of the Shabdartha

---

## SECTION 10: SELF-CHECK BEFORE SAVING

Before saving ANY page transcription, mentally verify ALL of the following.
If ANY check fails, FIX the problem before saving.

### Checklist:
1. PAGE TYPE: Did I correctly identify this as Type S or Type V?
2. SPURIOUS SECTIONS: If Type V, did I accidentally add Shabdartha or Bhavartha? REMOVE THEM.
3. DUPLICATE BHAVARTHA: Does any shloka have TWO ಭಾವಾರ್ಥ: sections? If yes, REMOVE the duplicate.
4. VYAKARANA BRACKETS: Scan every Shabdartha bullet — does it have grammar in parentheses? If NOT, ADD IT.
5. ENGLISH WORDS: Scan the entire output — is there ANY English word? REWRITE in Kannada.
6. DEVANAGARI: Is there ANY Devanagari character (other than dandas)? CONVERT to Kannada.
7. MARKDOWN: Is there ANY `**`, `*`, or `#` formatting? REMOVE IT.
8. DOUBLE SEPARATORS: Are there two separator lines with only whitespace between them? REMOVE one.
9. BHAVARTHA QUALITY: Is the Bhavartha at least 100 words? Is it SPECIFIC to this shloka? Does it contain any banned filler sentence?
10. SHABDARTHA COMPLETENESS: Does every word in the shloka have a Shabdartha bullet?
11. VYAKHYANA COMPLETENESS: Is the Mula complete? Is the Anuvada complete? Nothing skipped?
12. SECTION ORDER: Are sections in the correct order?
13. ELLIPSIS: Is there ANY "..." or "..." or "ಇತ್ಯಾದಿ" used to skip content? EXPAND IT.
14. PAGE NUMBER: Is the [ಪುಟ: NNN] line present with correct Kannada numerals?

---

## SECTION 11: BOOK TYPE HANDLING

### Type A: Sanskrit Vyakhyana (e.g., Prapanchasara Sarasangraha)
- Source PDF has: Devanagari shlokas + Sanskrit commentary in Devanagari
- Vyakhyana ಮೂಲ: = Sanskrit commentary transcribed into Kannada script
- Vyakhyana ಅನುವಾದ: = Kannada translation of the Sanskrit commentary

### Type B: Hindi Vyakhyana (e.g., Meru Tantram)
- Source PDF has: Devanagari shlokas + Hindi commentary (ಭಾಷಾಭಾಷ್ಯ)
- NO Hindi transliteration needed — SKIP ಮೂಲ: section
- Vyakhyana ಅನುವಾದ: = Full Kannada translation of the Hindi commentary
- Translate EVERY sentence — do NOT summarize

### Type C: Shloka Only
- Source PDF has: Only Devanagari shlokas, no commentary
- Still provide full Shabdartha and Bhavartha
- Vyakhyana section: Write scholarly commentary from knowledge

---

## SECTION 12: PER-PAGE FILE SAVING

- Save EACH page transcription to: `page_NNN.txt` (zero-padded 3-digit page number)
- Directory: `scratch/prapanchasara_sarasangraha_v1_transcriptions/`
- One file per PDF page — this enables resume from any point
- End each file with a single separator line
- Use the assemble command to combine pages into chapter files

---

## SECTION 13: CONSISTENCY ACROSS PAGES

- Shloka numbering must be CONTINUOUS across pages — check the previous page's last shloka number
- Vyakhyana text that starts on one page and continues on the next must be split cleanly at page boundaries
- If a shloka spans two pages, include the full shloka on the page where it starts
- Section header spelling must be IDENTICAL on every page — do not vary the spelling

---

## QUICK REFERENCE CARD

```
SHLOKA PAGE (Type S):
[ಪುಟ: NNN]
ಶ್ಲೋಕ 1:
<full shloka in Kannada script, plain text>

ಭಾವಾರ್ಥ:
<100+ words, specific, no filler>

ಶಬ್ದಾರ್ಥ:
• ಶುಕ್ಲ-ಅಂಬರ-ಧರಂ — ಪರಿಶುದ್ಧವಾದ ಶ್ವೇತವಸ್ತ್ರವನ್ನು ಧರಿಸಿರುವವನು (ಬಹುವ್ರೀಹಿ ಸಮಾಸ)
• ವಿಷ್ಣುಂ — ಸರ್ವವ್ಯಾಪಕನಾದ ಪರಮಾತ್ಮನನ್ನು (ದ್ವಿತೀಯಾ ವಿಭಕ್ತಿ)
• ಧ್ಯಾಯೇತ್ — ಏಕಾಗ್ರಚಿತ್ತದಿಂದ ಧ್ಯಾನಿಸಬೇಕು (ವಿಧಿಲಿಙ್ ಲಕಾರ, ಪ್ರಥಮ ಪುರುಷ, ಏಕವಚನ)
• ಸರ್ವ-ವಿಘ್ನ-ಉಪಶಾಂತಯೇ — ಸಮಸ್ತ ವಿಘ್ನಗಳ ಶಾಂತಿಗಾಗಿ (ತತ್ಪುರುಷ ಸಮಾಸ, ಚತುರ್ಥೀ ವಿಭಕ್ತಿ)

ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
ಮೂಲ: (Type A only)
<full Sanskrit commentary in Kannada script>
ಅನುವಾದ:
<full Kannada translation>
----------------------------------------

VYAKHYANA-ONLY PAGE (Type V):
[ಪುಟ: NNN]
ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
ಮೂಲ: (Type A only)
<full Sanskrit commentary in Kannada script>
ಅನುವಾದ:
<full Kannada translation>
----------------------------------------
```

---

## CANONICAL REFERENCE PATTERN

This is the EXACT format every shloka transcription must follow. Study it.

```
ಶ್ಲೋಕ 1:
ಶುಕ್ಲಾಂಬರಧರಂ ವಿಷ್ಣುಂ ಶಶಿವರ್ಣಂ ಚತುರ್ಭುಜಮ್ ।
ಪ್ರಸನ್ನವದನಂ ಧ್ಯಾಯೇತ್ ಸರ್ವವಿಘ್ನೋಪಶಾಂತಯೇ ॥ ೧ ॥

ಭಾವಾರ್ಥ:
ಶುಭ್ರವಾದ ಶ್ವೇತವಸ್ತ್ರವನ್ನು ಧರಿಸಿರುವವನೂ, ಚಂದ್ರನಂತೆ ಪರಿಶುದ್ಧ ಪ್ರಕಾಶಮಾನವಾದ
ತೇಜಸ್ಸುಳ್ಳವನೂ, ನಾಲ್ಕು ಭುಜಗಳಿಂದ ಶೋಭಿಸುವವನೂ, ಪ್ರಸನ್ನ ಗಂಭೀರ ಮುಖಕಮಲವುಳ್ಳವನೂ,
ಸರ್ವವ್ಯಾಪಿಯೂ ಆದ ಶ್ರೀಮನ್ಮಹಾವಿಷ್ಣುವನ್ನು ಹಾಗೂ ವಿಘ್ನನಿವಾರಕ ಮಹಾಗಣಪತಿಯನ್ನು
ಸಕಲ ವಿಘ್ನಗಳ ಪರಿಹಾರಕ್ಕಾಗಿ ಭಕ್ತಿಯಿಂದ ಧ್ಯಾನಿಸಬೇಕು.

ಶಬ್ದಾರ್ಥ:
• ಶುಕ್ಲ-ಅಂಬರ-ಧರಂ — ಪರಿಶುದ್ಧವಾದ ಶ್ವೇತವಸ್ತ್ರವನ್ನು ಧರಿಸಿರುವವನು (ಬಹುವ್ರೀಹಿ ಸಮಾಸ)
• ವಿಷ್ಣುಂ — ಸರ್ವವ್ಯಾಪಕನಾದ ಪರಮಾತ್ಮನನ್ನು (ದ್ವಿತೀಯಾ ವಿಭಕ್ತಿ)
• ಶಶಿ-ವರ್ಣಂ — ಪೂರ್ಣಚಂದ್ರನಂತೆ ಶಾಂತವೂ ತೇಜೋಮಯವೂ ಆದ ಕಾಂತಿಯುಳ್ಳವನು (ಕರ್ಮಧಾರಯ ಸಮಾಸ)
• ಚತುರ್ಭುಜಮ್ — ಶಂಖ, ಚಕ್ರ, ಗದಾ, ಪದ್ಮಗಳನ್ನು ಧರಿಸಿದ ನಾಲ್ಕು ಭುಜಗಳುಳ್ಳವನು (ಬಹುವ್ರೀಹಿ ಸಮಾಸ)
• ಪ್ರಸನ್ನ-ವದನಂ — ಕೃಪಾಪೂರ್ಣವೂ ಮಂದಹಾಸಯುಕ್ತವೂ ಆದ ಪ್ರಸನ್ನ ಮುಖವುಳ್ಳವನು (ಬಹುವ್ರೀಹಿ ಸಮಾಸ)
• ಧ್ಯಾಯೇತ್ — ಏಕಾಗ್ರಚಿತ್ತದಿಂದ ಧ್ಯಾನಿಸಬೇಕು (ವಿಧಿಲಿಙ್ ಲಕಾರ, ಪ್ರಥಮ ಪುರುಷ, ಏಕವಚನ)
• ಸರ್ವ-ವಿಘ್ನ-ಉಪಶಾಂತಯೇ — ಸಮಸ್ತ ವಿಘ್ನಗಳ ಮತ್ತು ಅಡ್ಡಿ-ಆತಂಕಗಳ ಶಾಂತಿಗಾಗಿ (ತತ್ಪುರುಷ ಸಮಾಸ, ಚತುರ್ಥೀ ವಿಭಕ್ತಿ)

ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:
<Mula + Anuvada or just Anuvada depending on book type>

----------------------------------------
```
