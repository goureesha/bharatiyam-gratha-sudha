# Sanskrit-Kannada Transcription Rules

These rules apply to ALL Sanskrit/Kannada transcription work in this project.

## Shloka Extraction
- Transcribe EVERY shloka EXACTLY as printed — every syllable, every word
- Use ONLY Kannada script (zero Devanagari characters anywhere)
- Use Kannada avagraha ಽ (not Devanagari ऽ)
- Write each shloka line as PLAIN TEXT — no bold, no asterisks, no markdown
- NEVER skip, merge, or paraphrase any part of the shloka

## Shabdartha (ಶಬ್ದಾರ್ಥ) — MANDATORY FOR EVERY WORD
- List EVERY word/compound from the shloka — no exceptions
- Format: `• ಸಂಸ್ಕೃತ ಶಬ್ದ — ಕನ್ನಡ ಅರ್ಥ (ವಿಭಕ್ತಿ/ವ್ಯಾಕರಣ, ಸಮಾಸ ಪ್ರಕಾರ)`
- Write the shabda word as PLAIN TEXT — no bold, no asterisks
- For samasa (compounds): break into component words, explain each
- Minimum: one bullet per word. 12 words = ≥12 bullets
- NEVER write "ಇತ್ಯಾದಿ", "ಮುಂತಾದ", or "etc." to skip words
- NEVER use "..." or "…" (ellipsis)

## Bhavartha (ಭಾವಾರ್ಥ) — MANDATORY
- Write a COMPLETE explanation in Kannada (minimum 100 words)
- Follow the logical flow of the book — connect to previous and next shlokas
- Explain philosophical/spiritual significance
- Do NOT just repeat shabdartha in sentence form — add deeper meaning

## Vyakhyana (ವ್ಯಾಖ್ಯಾನ) — MANDATORY
- Transcribe FULL commentary text in Kannada script (NOT Devanagari)
- Label original: "ಮೂಲ:"
- Provide COMPLETE Kannada translation labeled: "ಅನುವಾದ:"
- Do NOT summarize or shorten — every sentence must be translated

## Format
- Each shloka block: `ಶ್ಲೋಕ N:`
- Section labels: `ಭಾವಾರ್ಥ:`, `ಶಬ್ದಾರ್ಥ:`, `ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:`
- Separate blocks with: `----------------------------------------`

## NO MARKDOWN FORMATTING
- ❌ Do NOT use `**...**` (bold) anywhere in the output
- ❌ Do NOT use `*...*` (italic) anywhere in the output
- ❌ Do NOT use any markdown — output is PLAIN TEXT only
- The only formatting: bullet `•`, separator `----------------------------------------`, section headers

## ABSOLUTE PROHIBITIONS
- ❌ NEVER skip any word in shabdartha
- ❌ NEVER use ellipsis (... or …)
- ❌ NEVER summarize when you should transcribe
- ❌ NEVER write "as mentioned above" to skip content
- ❌ NEVER reduce bhavartha below 70 words
- ❌ NEVER use Devanagari script
- ❌ NEVER use English words in output
- ❌ NEVER skip the vyakhyana section
- ❌ NEVER use bold/italic markdown (`**`, `*`)

## Book Type Handling

### Type A: Sanskrit Vyakhyana (e.g., Prapanchasara Sarasangraha)
- Source: Devanagari shlokas + Sanskrit commentary
- Vyakhyana ಮೂಲ: = Sanskrit commentary in Kannada script
- Vyakhyana ಅನುವಾದ: = Kannada translation of the Sanskrit commentary

### Type B: Hindi Vyakhyana (e.g., Meru Tantram)
- Source: Devanagari shlokas + Hindi commentary (भाषाभाष्य)
- NO Hindi transliteration needed — skip ಮೂಲ: section
- Vyakhyana ಅನುವಾದ: = Full Kannada translation of the Hindi commentary
- Translate EVERY sentence — do not summarize

### Type C: Shloka Only
- Source: Only Devanagari shlokas, no commentary
- Vyakhyana section: Write scholarly commentary from knowledge
- Still provide full shabdartha and bhavartha

## Per-Page Saving
- Save EACH page transcription to its own file: `page_NNN.txt`
- This enables resume from any page if context is lost
- Use the `assemble` command to combine pages into chapter files
