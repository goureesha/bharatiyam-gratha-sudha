# Srimad Bhagavata Purana: Skandha 4 (Chapters 1 & 2) Translation Plan

## Overview
Continue the translation and enrichment of **ಶ್ರೀಮದ್ಭಾಗವತ ಪುರಾಣ (Srimad Bhagavata Purana)** starting from **ಚತುರ್ಥ ಸ್ಕಂಧ (Skandha 4)** according to the established **17-Rule Gold Standard**.

### Scope
- **Chapter 1** (`purana_bhagavata_skandha4_ch_2.txt`): 66 Shlokas — *ಸ್ವಾಯಂಭುವಮನುವಂಶವರ್ಣನಂ (ಅತ್ರಿ, ಕರ್ದಮ, ದಕ್ಷ ಸಂತತಿ, ನರ-ನಾರಾಯಣ ಅವತಾರ, ಸತೀದೇವಿ)*.
- **Chapter 2** (`purana_bhagavata_skandha4_ch_4.txt`): 35 Shlokas — *ದಕ್ಷಶಾಪೋ ನಾಮ (ದಕ್ಷ-ಶಿವ ವೈರವರ್ಣನಂ, ನಂದೀಶ್ವರ ಮತ್ತು ಭೃಗು ಮುನಿಗಳ ಪರಸ್ಪರ ಶಾಪಗಳು)*.
- **Index Update** (`assets/data/scriptures_index.json`): Update chapter titles with clear, descriptive Kannada titles.

---

## The 17 Master Rules & Gold Standard Requirements
1. **Three-Tier Structure**:
   - Original Sanskrit Shloka in Kannada script with traditional danda markings (`॥ ೧ ॥`).
   - `ಶಬ್ದಾರ್ಥ:` with bullet points (`• <Sanskrit word> - <Kannada meaning>`).
   - `ಭಾವಾರ್ಥ:` with deep, grammatically flawless, natural Kannada sentence explanation.
2. **Zero Template / Forbidden Words**: No filler phrases like `ವಿಷಯವು`, `ಸಂದರ್ಭದಲ್ಲಿ`, `ವಿವರಣೆ`, `ವಿಷಯನಿಂದ`, `ವಿಷಯದಲ್ಲಿ`.
3. **Punctuation Standard**: Non-terminal shabdartha bullets end without periods (or with commas); the terminal shabdartha bullet must end with a single period (`.`).
4. **Clean Scripts**: Zero English / ASCII characters in Kannada fields; zero corrupted agglutinations (e.g., `ನನ್ನುನನ್ನು`, `ನ್ನ್ನು`).
5. **Colophon**: Faithful preservation of chapter concluding colophons.

---

## Proposed Changes

### Content & Data Layer

#### [MODIFY] [purana_bhagavata_skandha4_ch_2.txt](file:///d:/bharatheeyam%20books/assets/data/chapters/purana_bhagavata_skandha4_ch_2.txt)
- Full word-by-word `ಶಬ್ದಾರ್ಥ` and authentic `ಭಾವಾರ್ಥ` for all 66 shlokas of Skandha 4 Chapter 1.

#### [MODIFY] [purana_bhagavata_skandha4_ch_4.txt](file:///d:/bharatheeyam%20books/assets/data/chapters/purana_bhagavata_skandha4_ch_4.txt)
- Full word-by-word `ಶಬ್ದಾರ್ಥ` and authentic `ಭಾವಾರ್ಥ` for all 35 shlokas of Skandha 4 Chapter 2.

#### [MODIFY] [scriptures_index.json](file:///d:/bharatheeyam%20books/assets/data/scriptures_index.json)
- Update chapter titles for `purana_bhagavata_skandha4_ch_2` and `purana_bhagavata_skandha4_ch_4`.

---

## Verification Plan

### Automated Validation
- Run a dedicated audit script verifying all 17 Master Rules against the new chapters:
  - Block count and integrity
  - Forbidden phrases check
  - Shabdartha bullet duplicate check
  - Bullet punctuation period rule check
  - Bhavartha uniqueness check
  - English characters check

```powershell
python scratch/audit_skandha4_ch1_2.py
```
