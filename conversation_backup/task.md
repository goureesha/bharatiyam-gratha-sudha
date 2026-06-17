# Task List - Admin Website & Firestore Integration

- [x] Create Firestore-compatible schemas and services in Flutter app
- [x] Configure Firebase initialization in Flutter main entry point
- [x] Modify `admin/index.html` to remove Shlokas section, adjust statistics, and update Chapter modal with a direct content field
- [x] Modify `admin/js/app.js` to support Direct Chapter Content editing and remove all Shlokas logic
- [x] Rewrite `seedData()` in `admin/js/app.js` to fetch and batch-write scriptures and stotras JSON data
- [x] Configure `firebase.json` to route `/admin/**` to the admin sub-directory
- [x] Create a deployment automation script `deploy_app.ps1` to build and deploy the project
- [ ] Run deployment script to build the project locally and verify output structure
- [ ] Perform a Git commit and push with conversation backup
- [ ] Create walkthrough documentation summarizing the changes
