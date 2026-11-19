# ═══════════════════════════════════════════════════════════════════════
# MERU TANTRAM VOL 1 — TRANSCRIPTION INSTRUCTIONS FOR GEMINI
# ═══════════════════════════════════════════════════════════════════════
#
# Give these instructions to Gemini at the START of a new conversation.
# Then feed it page images one by one (or in small batches).
#
# ═══════════════════════════════════════════════════════════════════════

## What This Book Is

Meru Tantram (मेरुतन्त्रम्) — A Shaiva-Shakta tantra scripture in the form of 
a dialogue between Shiva and Parvati. This is Vol 1 covering Prakashas 1-8.

- Publisher: Chaukhamba Sura Bharati Prakashan, Varanasi
- Editor: Shrinivas Sharma  
- Commentator: Kapil Dev Narayan (Hindi भाषाभाष्य)
- Book Type: B — Devanagari shlokas + Hindi commentary

## Chapter Map

| Prakasha | Name | Pages (0-indexed) | Page Count |
|----------|------|-------------------|------------|
| 1 | व्यवस्थाप्रकाशः (ವ್ಯವಸ್ಥಾಪ್ರಕಾಶಃ) | 28-45 | 18 |
| 2 | संस्कारप्रकाशः (ಸಂಸ್ಕಾರಪ್ರಕಾಶಃ) | 46-90 | 45 |
| 3 | दीक्षाप्रकाशः (ದೀಕ್ಷಾಪ್ರಕಾಶಃ) | 91-182 | 92 |
| 4 | होमविधिप्रकाशः (ಹೋಮವಿಧಿಪ್ರಕಾಶಃ) | 183-207 | 25 |
| 5 | आह्निकप्रकाशः (ಆಹ್ನಿಕಪ್ರಕಾಶಃ) | 208-342 | 135 |
| 6 | पुरश्चर्याप्रकाशः (ಪುರಶ್ಚರ್ಯಾಪ್ರಕಾಶಃ) | 343-418 | 76 |
| 7 | सिद्धिस्थिरीकरणप्रकाशः (ಸಿದ್ಧಿಸ್ಥಿರೀಕರಣಪ್ರಕಾಶಃ) | 419-445 | 27 |
| 8 | मुद्रालक्षणप्रकाशः (ಮುದ್ರಾಲಕ್ಷಣಪ್ರಕಾಶಃ) | 446-474 | 29 |

Total: 447 content pages

---

## TRANSCRIPTION RULES (FOLLOW EXACTLY)

### 1. Script — ONLY Kannada
- ALL output must be in Kannada script (ಕನ್ನಡ ಲಿಪಿ)
- ZERO Devanagari characters anywhere in the output
- Convert every Devanagari letter to its Kannada equivalent
- Use Kannada avagraha ಽ (not Devanagari ऽ)
- Use Kannada visarga ಃ (not Devanagari ः)
- Use Kannada anusvara ಂ (not Devanagari ं)

### 2. Shloka Lines — Plain Text, Exact
- Write each shloka line as PLAIN TEXT (NO bold, NO asterisks, NO markdown formatting)
- Transcribe EXACTLY as printed — every syllable, every word
- Include the shloka number: ॥೧॥ or ॥೧೨॥
- NEVER skip, merge, or paraphrase any shloka
- ❌ Do NOT wrap shloka lines in `**...**` or any other formatting

### 3. Shabdartha (ಶಬ್ದಾರ್ಥ) — EVERY WORD
- List EVERY word/compound from the shloka as bullet points
- Format: `• ಸಂಸ್ಕೃತ ಶಬ್ದ — ಕನ್ನಡ ಅರ್ಥ (ವಿಭಕ್ತಿ/ವ್ಯಾಕರಣ, ಸಮಾಸ ಪ್ರಕಾರ)`
- Write the shabda word as PLAIN TEXT (NO bold, NO asterisks)
- For samasa (compounds): break into component words, explain each
- Minimum: one bullet per word. 10 words in shloka = ≥10 bullets
- ❌ NEVER write "ಇತ್ಯಾದಿ", "ಮುಂತಾದ", or "etc." to skip words
- ❌ NEVER use "..." or "…" (ellipsis)

### 4. Bhavartha (ಭಾವಾರ್ಥ) — MANDATORY
- Write a COMPLETE scholarly explanation in Kannada
- Minimum 100 words (preferably 120-150)
- Explain the philosophical/spiritual significance
- Connect to the flow of the chapter and the broader tantra context
- Do NOT just repeat shabdartha in sentence form — add deeper meaning

### 5. Vyakhyana (ವ್ಯಾಖ್ಯಾನ) — MANDATORY
The book has Hindi commentary (भाषाभाष्य by Kapil Dev Narayan). Handle it as:

- NO Hindi transliteration needed — skip ಮೂಲ: section entirely
- `ಅನುವಾದ:` — Write a COMPLETE Kannada translation of the Hindi commentary
  - Translate EVERY sentence into Kannada
  - Do NOT summarize or shorten

### 6. Output Format Per Shloka

```
ಶ್ಲೋಕ N:

ಶ್ಲೋಕದ ಮೊದಲ ಸಾಲು ।
ಶ್ಲೋಕದ ಎರಡನೇ ಸಾಲು ॥N॥

ಶಬ್ದಾರ್ಥ:

• ಶಬ್ದ೧ — ಅರ್ಥ (ವಿಭಕ್ತಿ, ಸಮಾಸ)
• ಶಬ್ದ೨ — ಅರ್ಥ (ವಿಭಕ್ತಿ)
• ಶಬ್ದ೩ — ಅರ್ಥ (ವಿಭಕ್ತಿ, ಸಮಾಸ)

ಭಾವಾರ್ಥ:

(100+ ಪದಗಳ ವಿದ್ವತ್ಪೂರ್ಣ ಕನ್ನಡ ವಿವರಣೆ)

ವಿಶೇಷ ವಿವರಣೆ / ವ್ಯಾಖ್ಯಾನ:

ಅನುವಾದ:
(ಹಿಂದೀ ವ್ಯಾಖ್ಯಾನದ ಪೂರ್ಣ ಕನ್ನಡ ಅನುವಾದ)

----------------------------------------
```

### 7. FORMATTING — NO MARKDOWN
- ❌ Do NOT use `**...**` (bold) anywhere in the output
- ❌ Do NOT use `*...*` (italic) anywhere in the output
- ❌ Do NOT use any markdown formatting — output is PLAIN TEXT only
- The only formatting allowed: bullet `•`, separator `----------------------------------------`, section headers like `ಶಬ್ದಾರ್ಥ:` and `ಭಾವಾರ್ಥ:`

### 8. ABSOLUTE PROHIBITIONS
- ❌ NEVER skip any word in shabdartha
- ❌ NEVER use ellipsis (... or …)
- ❌ NEVER summarize when you should transcribe
- ❌ NEVER write "ಮೇಲೆ ಹೇಳಿದಂತೆ" to skip content
- ❌ NEVER reduce bhavartha below 70 words
- ❌ NEVER output ANY Devanagari character
- ❌ NEVER use English words in the transcription output
- ❌ NEVER skip the vyakhyana section
- ❌ NEVER output empty sections
- ❌ NEVER use bold/italic markdown (`**`, `*`)

---

## HOW TO USE THIS WITH GEMINI

### Step-by-step workflow:

1. Start a new Gemini conversation
2. Paste these instructions as the first message
3. Read the page image:
   ```
   Read this page image and transcribe it following the rules above.
   This is page XX from Prakasha N (ವ್ಯವಸ್ಥಾಪ್ರಕಾಶಃ).
   ```
4. Attach the PNG image from `scratch/meru_v1_pages/page_XXX.png`
5. Copy the Gemini output and save it:
   ```
   Save the output to: scratch/meru_v1_transcriptions/page_XXX.txt
   ```
6. Repeat for the next page
7. After completing all pages of a Prakasha, run:
   ```
   python meru_v1_transcribe.py assemble N
   ```
   (where N = Prakasha number)
8. Register and commit:
   ```
   python meru_v1_transcribe.py register
   python meru_v1_transcribe.py bump
   python meru_v1_transcribe.py commit "feat(scriptures): Add Meru Tantram Vol 1 Prakasha N"
   ```

### OR — Give Gemini the full automated instruction:

```
/goal

Transcribe the Meru Tantram Vol 1 book.

PDF images are pre-rendered at: d:\bharatheeyam books\scratch\meru_v1_pages\page_XXX.png
Pages: 028 to 474
Book type: B (Hindi vyakhyana)

For each page:
1. Read the page image with read_file
2. Transcribe following the rules in this conversation
3. Save to: d:\bharatheeyam books\scratch\meru_v1_transcriptions\page_XXX.txt

After each prakasha (chapter) is complete:
1. Run: python meru_v1_transcribe.py assemble N
2. Run: python meru_v1_transcribe.py register  
3. Run: python meru_v1_transcribe.py bump
4. Git add, commit, push

Follow the transcription rules in d:\bharatheeyam books\.gemini\rules\transcription_rules.md
Continue non-stop until the full book is done.
Start from the first pending page (check with: python meru_v1_transcribe.py status).
```

### Check progress anytime:
```
python meru_v1_transcribe.py status
```

---

## DEVANAGARI → KANNADA QUICK REFERENCE

| Devanagari | Kannada | Devanagari | Kannada |
|------------|---------|------------|---------|
| अ आ इ ई   | ಅ ಆ ಇ ಈ | उ ऊ ऋ ॠ   | ಉ ಊ ಋ ೠ |
| ए ऐ ओ औ   | ಏ ಐ ಓ ಔ | अं अः       | ಅಂ ಅಃ   |
| क ख ग घ ङ | ಕ ಖ ಗ ಘ ಙ | च छ ज झ ञ | ಚ ಛ ಜ ಝ ಞ |
| ट ठ ड ढ ण | ಟ ಠ ಡ ಢ ಣ | त थ द ध न | ತ ಥ ದ ಧ ನ |
| प फ ब भ म | ಪ ಫ ಬ ಭ ಮ | य र ल व   | ಯ ರ ಲ ವ |
| श ष स ह   | ಶ ಷ ಸ ಹ | क्ष त्र ज्ञ | ಕ್ಷ ತ್ರ ಜ್ಞ |
| ् (virama) | ್        | ं (anusvara) | ಂ      |
| ः (visarga) | ಃ       | ़ (nukta)   | (drop)  |

### Hindi-specific letters → Kannada
| Hindi | Kannada equivalent |
|-------|-------------------|
| क़ ख़ ग़ | ಕ ಖ ಗ |
| ज़ फ़ | ಜ಼ ಫ |
| ड़ ढ़ | ಡ ಢ |
