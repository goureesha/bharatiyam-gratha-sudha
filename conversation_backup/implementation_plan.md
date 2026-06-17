# Implementation Plan - Firestore Integration for App & Admin Website

We will connect the Flutter web app and the separate admin portal via Google Cloud Firestore. Whatever edits are made in the admin portal will immediately reflect in the app. The app will fetch live data from Firestore when online, falling back to local JSON assets (`scriptures_data.json` and `stotra_data.json`) when offline.

---

## 1. Simplified Unified Firestore Schema
To bypass the 1MB Firestore document limit on large books (like Harivansha Purana which is 4MB+) and match the app's structure, we will use a unified 2-level hierarchy:
1. **`books` collection**: Represents both scripture books and stotra categories.
   - `id`: String (e.g., `upanishad_isha`, `shiva_stotras`)
   - `title`: String (Kannada)
   - `titleEn`: String (English)
   - `category`: String (e.g., `upanishad`, `purana`, `gita`, `smriti`, `stotra_main`, `stotra_extras`)
   - `icon`: String (emoji or path)
   - `order`: Number
2. **`chapters` collection**: Represents both scripture chapters and individual stotras.
   - `id`: String (unique identifier)
   - `bookId`: String (references the book ID)
   - `title`: String (Kannada)
   - `content`: String (large text content of the chapter/stotra)
   - `order`: Number

---

## 2. Proposed Changes

### A. Flutter App (Firebase/Firestore Client Integration)
We will add Firebase packages and modify the data services to load from Firestore when online, falling back to local files.

#### [MODIFY] [pubspec.yaml](file:///d:/bharatheeyam%20books/pubspec.yaml)
Add Firebase dependencies compatible with the Dart SDK constraints:
```yaml
dependencies:
  firebase_core: ^2.27.0
  cloud_firestore: ^4.15.8
```

#### [MODIFY] [main.dart](file:///d:/bharatheeyam%20books/lib/main.dart)
Initialize Firebase in `main()` using the existing Firebase credentials (using a try-catch block to prevent crashes if offline or configuration fails).

#### [MODIFY] [scripture_service.dart](file:///d:/bharatheeyam%20books/lib/services/scripture_service.dart)
Modify `init()` to:
1. Try fetching books and chapters from the Firestore `books` and `chapters` collections.
2. If successful, populate the local scriptures cache.
3. If it fails (network error, offline), fall back to loading from `assets/data/scriptures_data.json`.

#### [MODIFY] [stotra_service.dart](file:///d:/bharatheeyam%20books/lib/services/stotra_service.dart)
Modify `init()` to:
1. Try fetching stotra categories and items from Firestore.
2. If it fails, fall back to loading from `assets/data/stotra_data.json`.

---

### B. Admin Panel Website
We will simplify the admin panel to allow direct editing of chapter text content, removing the unnecessary `shlokas` sub-tier, and update the "Seed Data" utility.

#### [MODIFY] [index.html](file:///d:/bharatheeyam%20books/admin/index.html)
1. In the `chapter-modal` form, add a large `<textarea>` for editing the chapter/stotra `content` directly.
2. Remove the **Shlokas** section/view entirely from the navigation and UI, as all text editing will now happen inside the chapter form.

#### [MODIFY] [app.js](file:///d:/bharatheeyam%20books/admin/js/app.js)
1. Simplify CRUD operations to only support `books` and `chapters` collections (saving `content` directly on the chapter document).
2. Rewrite the **Seed Data** function to dynamically `fetch()` the local JSON assets (`/assets/data/scriptures_data.json` and `/assets/data/stotra_data.json`) and upload them to Firestore, so we don't have to hardcode 68MB of text in the JavaScript file.

---

### C. Deployment Configuration
#### [MODIFY] [firebase.json](file:///d:/bharatheeyam%20books/firebase.json)
Configure Firebase Hosting to serve the compiled Flutter web app at the root (`/`) and serve the admin portal at `/admin/`.
```json
{
  "hosting": [
    {
      "target": "app",
      "public": "build/web",
      "rewrites": [
        { "source": "/admin/**", "destination": "/admin/index.html" },
        { "source": "**", "destination": "/index.html" }
      ]
    }
  ]
}
```

---

## 3. Verification Plan

### Seeding Verification
- Log in to the admin panel, go to **Seed Data**, and run the seeding process.
- Verify in the Firebase Console that the `books` and `chapters` collections are fully populated.

### App Sync Verification
- Open the Flutter web app (locally or via hosting).
- Verify all Upanishads, Puranas, and Stotras load correctly.
- Edit a chapter text in the admin website.
- Refresh the Flutter app and verify that the edited text immediately reflects in the reader view.
