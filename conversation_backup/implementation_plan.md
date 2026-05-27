# Goal Description

The user requested to add some stotras to the Shiva section in the Stotras category.
To keep the digital library completely in sync and high quality, we will:
1. Add three beautiful and widely chanted Shiva stotras with full Devanagari Sanskrit, Kannada transliteration, and Kannada meanings:
   - **ಶಿವ ಪಂಚಾಕ್ಷರಿ ಸ್ತೋತ್ರಮ್ (Shiva Panchakshari Stotram)**: Praise of the five sacred syllables (Na-Ma-Shi-Va-Ya) comprising 5 verses + 1 Phala Shruti verse.
   - **ಲಿಂಗಾಷ್ಟಕಮ್ (Lingashtakam)**: Lord Shiva's Lingam worship stotra comprising 3 key verses.
   - **ಬಿಲ್ವಾಷ್ಟಕಮ್ (Bilvashtakam)**: Praise of offering Bilva leaves comprising 3 key verses.
2. Ensure both **Web (`web/js/data.js`)** and **Flutter (`lib/data/content_data.dart`)** codebases are in perfect synchronization by:
   - Syncing the library subcategory layout (simplifying to Vaiidika Grantha & Jyotisha Grantha).
   - Syncing the stotras subcategory layout (by Deity/God instead of individual stotras).
   - Adding the new Shiva stotras in both places.

## Proposed Changes

### 1. Web Data (`web/js/data.js`)

We will add three new books under `category: "stotras"`, `subcategory: "shiva"`, and `godRelated: ["shiva"]`:

#### [MODIFY] [data.js](file:///d:/bharatheeyam%20books/web/js/data.js)
- Add **Shiva Panchakshari Stotram** (id: `shiva_panchakshari`)
- Add **Lingashtakam** (id: `lingashtakam`)
- Add **Bilvashtakam** (id: `bilvashtakam`)
- Each book will bypass chapters in rendering (single chapter wrapper) and have shlokas containing `sanskrit`, `kannada`, and `meaning` (no `explanation` as per user settings).

---

### 2. Flutter Data (`lib/data/content_data.dart`)

We will update the static data classes to perfectly align with Request 7, 8, and 9:

#### [MODIFY] [content_data.dart](file:///d:/bharatheeyam%20books/lib/data/content_data.dart)
- Simplify `library` subcategories to: `vaidika_grantha` (ವೈದಿಕ ಗ್ರಂಥ) and `jyotisha_grantha` (ಜ್ಯೋತಿಷ ಗ್ರಂಥ).
- Change `stotras` subcategories to be Deity-based matching the web app (`shiva`, `vishnu`, `devi`, etc.).
- Update `bhagavad_gita` and `ishavasya` book subcategories to `vaidika_grantha` and `upanishads` subcategory references.
- Update `shiva_tandava`, `gayatri_mantra`, `vishnu_sahasranama`, and `hanuman_chalisa` to use their respective deity subcategory keys (`shiva`, `surya`, `vishnu`, `hanuman`).
- Add the three new Shiva stotras: **Shiva Panchakshari Stotram**, **Lingashtakam**, and **Bilvashtakam** with Devanagari Sanskrit, Kannada transliteration, and Kannada meanings (no explanations).

---

## Verification Plan

### Automated Build & CI
- Trigger and verify that the Flutter project builds successfully with `flutter build apk` (or using the local workspace build triggers).
- Check that the GitHub Actions build is triggered on push and succeeds.

### Manual Verification
- Launch the web prototype in a browser.
- Navigate to the **Stotras (ಸ್ತೋತ್ರಗಳು)** section.
- Select the **Shiva (ಶಿವ)** deity category.
- Verify that **ಶಿವ ತಾಂಡವ ಸ್ತೋತ್ರಮ್**, **ಶಿವ ಪಂಚಾಕ್ಷರಿ ಸ್ತೋತ್ರಮ್**, **ಲಿಂಗಾಷ್ಟಕಮ್**, and **ಬಿಲ್ವಾಷ್ಟಕಮ್** are all listed.
- Tap each stotra and verify:
  - Text is formatted cleanly.
  - Script filter (Sanskrit/Kannada/Both) works flawlessly.
  - Meaning toggle (ಅರ್ಥ ✓/✗) hides/shows meanings correctly.
  - Bookmarking works for all new shlokas.
