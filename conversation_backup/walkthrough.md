# Walkthrough - Admin Panel and Firebase Integration

We have implemented the admin website and Firestore integration for the Bharatiyam Grantha Sudha app.

## Summary of Changes

### 1. Data Model & Firestore Schema
- Unified the scriptures and stotras data into a simple 2-level structure:
  - **`books` collection**: Represents scriptures (Gita, Upanishads, Puranas, Smritis) and stotra categories (Main/Extras).
  - **`chapters` collection**: Represents individual chapters and stotras. We deleted the `shlokas` sub-collection tier completely, storing the text content directly inside each chapter document in the `content` field.

### 2. Admin Portal (`admin/index.html` and `admin/js/app.js`)
- Removed all references, pages, modals, forms, and statistics related to `shlokas`.
- Expanded the **Chapter Modal** with a large text area to write and edit the `content` of chapters/stotras directly.
- Rewrote the **Seed Data** mechanism to fetch the 50MB+ local asset JSON files (`scriptures_data.json` and `stotra_data.json`) dynamically on-demand, parsing and uploading them in sequential high-speed Firestore batches of 400 documents to avoid quota limits.

### 3. Firebase Deployment (`firebase.json` and `deploy_app.ps1`)
- Configured hosting rules in [firebase.json](file:///d:/bharatheeyam%20books/firebase.json) to serve the Flutter Web App from `build/web` at `/` and route all `/admin/**` sub-paths to the Admin Panel.
- Created [scripts/deploy_app.ps1](file:///d:/bharatheeyam%20books/scripts/deploy_app.ps1) to compile the Flutter Web release, inject the Admin Panel into the build folder (`build/web/admin/`), and run the Firebase deployment in a single command.

---

## Verification Plan

### 1. Verification of Seeding
- Log in to the Admin website (`/admin/`).
- Navigate to **Seed Data** page.
- Click **Seed All Data to Firestore**.
- Verify that a progress bar updates smoothly, showing batch uploads of Books and Chapters.
- Open Firebase Console and verify the collections `books`, `chapters`, and `config` are fully populated.

### 2. Live Synchronization Verification
- Open the Flutter Web app on the root path `/`.
- Navigate to any book (e.g. Shrimad Bhagavad Gita) and open a chapter.
- In the Admin Panel, select the same book/chapter and modify some text in the **Content** area.
- Save the changes in the Admin Panel.
- Refresh/reload the Flutter app, and verify the live edited text is loaded.
