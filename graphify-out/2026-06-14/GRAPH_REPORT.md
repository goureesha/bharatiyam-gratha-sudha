# Graph Report - bharatheeyam books  (2026-06-14)

## Corpus Check
- 30 files · ~3,779,971 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 272 nodes · 383 edges · 16 communities (15 shown, 1 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 20 edges (avg confidence: 0.89)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a907c8f2`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Navigation and Routing|Navigation and Routing]]
- [[_COMMUNITY_Admin Panel and Concepts|Admin Panel and Concepts]]
- [[_COMMUNITY_Theme and UI Components|Theme and UI Components]]
- [[_COMMUNITY_Data Models|Data Models]]
- [[_COMMUNITY_App Bootstrap and Providers|App Bootstrap and Providers]]
- [[_COMMUNITY_Firestore Service Layer|Firestore Service Layer]]
- [[_COMMUNITY_Bookmark and Preferences|Bookmark and Preferences]]
- [[_COMMUNITY_Content Data and Seed|Content Data and Seed]]
- [[_COMMUNITY_Firebase Config|Firebase Config]]
- [[_COMMUNITY_Deity Icons|Deity Icons]]
- [[_COMMUNITY_Android Build System|Android Build System]]
- [[_COMMUNITY_Web App Frontend|Web App Frontend]]
- [[_COMMUNITY_Community 15|Community 15]]

## God Nodes (most connected - your core abstractions)
1. `BookmarkService` - 11 edges
2. `State` - 6 edges
3. `_HomeTab` - 6 edges
4. `ReaderPage` - 6 edges
5. `BharatiyamApp` - 5 edges
6. `Shloka` - 5 edges
7. `_HomeScreenState` - 5 edges
8. `BookDetailPage` - 5 edges
9. `SettingsPage` - 5 edges
10. `hosting` - 4 edges

## Surprising Connections (you probably didn't know these)
- `Build APK & Backup (CI)` --implements--> `Conversation Backup & Build Artifact Strategy`  [EXTRACTED]
  .github/workflows/build.yml → scripts/push_with_backup.ps1
- `_ShlokaCardState` --inherits--> `State`  [EXTRACTED]
  lib/widgets/shloka_card.dart → admin/js/app.js
- `Build APK & Backup (CI)` --references--> `pubspec.yaml (Flutter Config)`  [INFERRED]
  .github/workflows/build.yml → pubspec.yaml
- `README.md (Project Overview)` --references--> `GitHub Pages Deployment`  [INFERRED]
  README.md → .github/workflows/deploy-web.yml
- `_HomeScreenState` --inherits--> `State`  [EXTRACTED]
  lib/screens/home_screen.dart → admin/js/app.js

## Import Cycles
- None detected.

## Communities (16 total, 1 thin omitted)

### Community 0 - "Navigation and Routing"
Cohesion: 0.07
Nodes (46): Chapter, FirebaseService, State, BharatiyamApp, MaterialPageRoute, book, BookDetailPage, BookListPage (+38 more)

### Community 1 - "Admin Panel and Concepts"
Cohesion: 0.11
Nodes (13): Conversation Backup & Build Artifact Strategy, Flutter + Web Dual-Platform Architecture, GitHub Pages Deployment, Build Log, Implementation Plan (Shiva Stotras), Task Progress Tracker, Walkthrough (Phase 4), APP_DATA (+5 more)

### Community 2 - "Theme and UI Components"
Cohesion: 0.09
Nodes (21): AppTheme, gold, goldLight, heroGradient, kannadaStyle, lotusPink, maroon, meaningStyle (+13 more)

### Community 3 - "Data Models"
Cohesion: 0.06
Nodes (35): List, AppCategory, Book, bookId, bookTitle, bookTitleEn, category, Chapter (+27 more)

### Community 4 - "App Bootstrap and Providers"
Cohesion: 0.06
Nodes (35): Book, Provider state management pattern, build, firebaseService, init, main, ../models/shloka.dart, package:firebase_core/firebase_core.dart (+27 more)

### Community 5 - "Firestore Service Layer"
Cohesion: 0.07
Nodes (27): ChangeNotifier, Offline-first architecture (bundled data + Firestore sync), ../data/content_data.dart, FirebaseFirestore?, package:cloud_firestore/cloud_firestore.dart, _books, _categories, _db (+19 more)

### Community 6 - "Bookmark and Preferences"
Cohesion: 0.08
Nodes (23): bool get, dart:convert, double get, int get, Map, package:flutter/foundation.dart, package:shared_preferences/shared_preferences.dart, _bookmarks (+15 more)

### Community 7 - "Content Data and Seed"
Cohesion: 0.14
Nodes (13): appName, appNameEn, appTagline, books, categories, ContentData, getAllShlokas, getBookById (+5 more)

### Community 8 - "Firebase Config"
Cohesion: 0.25
Nodes (7): firestore, indexes, rules, hosting, ignore, public, rewrites

### Community 9 - "Deity Icons"
Cohesion: 0.32
Nodes (8): Devi (Durga) - Hindu goddess depicted with eight arms riding a lion, holding trishul, lotus, mace, shield, chakra, and bow; red saree, gold crown and jewelry; circular gold-bordered medallion on dark background; flat vector illustration style, Ganesha - Elephant-headed Hindu deity seated in padmasana on ornate pedestal, four arms holding axe, noose, modak, and abhaya mudra; Om symbol on trunk; gold-teal-maroon color palette; circular gold-bordered medallion on dark background; flat vector illustration style, Hanuman - Monkey-faced Hindu deity in namaste pose with golden mace (gada) over shoulder; ornate crown with Om symbols, radiant halo, flower garlands; gold armor; decorative circular gold border with scrollwork on dark navy background; flat vector illustration style, Krishna - Blue-skinned Hindu deity playing the flute (bansuri) in tribhanga pose; peacock feather in golden crown, yellow dhoti, standing on lotus pedestal; circular gold-bordered medallion on black background; flat vector illustration style, Rama - Blue-skinned Hindu deity in profile holding bow (Kodanda) with quiver of arrows; golden crown with peacock feather, Vaishnava tilak, royal jewelry; circular gold-bordered medallion on dark background; flat vector illustration style, Shiva - Blue-skinned Hindu deity in deep meditation (dhyana), seated in padmasana; matted hair (jata) with crescent moon, trishul with damaru drum, rudraksha mala, third-eye marks (tripundra); circular gold double-bordered medallion on dark navy background; flat vector illustration style, Surya - Hindu sun god with radiant solar halo, holding chakra and lotus; riding golden chariot drawn by seven white horses with charioteer Aruna; ornate circular border with lotus and star motifs on dark navy background; flat vector illustration style, Vishnu - Blue-skinned four-armed Hindu deity seated on lotus in padmasana; holding Sudarshana Chakra, Panchajanya conch, Kaumodaki mace, and Padma lotus; peacock feather in crown, Vaishnava tilak; circular gold-bordered medallion on dark navy background; flat vector illustration style

### Community 10 - "Android Build System"
Cohesion: 0.33
Nodes (5): Android root build.gradle, Android settings.gradle, Android app build.gradle, FlutterActivity, MainActivity

### Community 15 - "Community 15"
Cohesion: 0.16
Nodes (10): Bookmark/Favorites System, Firestore backend (books/chapters/shlokas/categories collections), Firebase project config (hosting + firestore), fieldOverrides, indexes, App, auth, db (+2 more)

## Knowledge Gaps
- **148 isolated node(s):** `App`, `APP_DATA`, `STOTRA_DATA`, `auth`, `db` (+143 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `State` connect `Navigation and Routing` to `App Bootstrap and Providers`, `Community 15`?**
  _High betweenness centrality (0.062) - this node is a cross-community bridge._
- **Why does `SEED` connect `Community 15` to `Content Data and Seed`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **What connects `App`, `APP_DATA`, `STOTRA_DATA` to the rest of the system?**
  _148 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Navigation and Routing` be split into smaller, more focused modules?**
  _Cohesion score 0.0730804810360777 - nodes in this community are weakly interconnected._
- **Should `Admin Panel and Concepts` be split into smaller, more focused modules?**
  _Cohesion score 0.11428571428571428 - nodes in this community are weakly interconnected._
- **Should `Theme and UI Components` be split into smaller, more focused modules?**
  _Cohesion score 0.09090909090909091 - nodes in this community are weakly interconnected._
- **Should `Data Models` be split into smaller, more focused modules?**
  _Cohesion score 0.06031746031746032 - nodes in this community are weakly interconnected._