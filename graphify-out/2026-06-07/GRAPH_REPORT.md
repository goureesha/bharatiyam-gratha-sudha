# Graph Report - .  (2026-06-06)

## Corpus Check
- 48 files · ~380,573 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 279 nodes · 397 edges · 15 communities (14 shown, 1 thin omitted)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 23 edges (avg confidence: 0.89)
- Token cost: 0 input · 0 output

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

## God Nodes (most connected - your core abstractions)
1. `BookmarkService` - 11 edges
2. `Admin Panel App (app.js)` - 9 edges
3. `State` - 7 edges
4. `_HomeTab` - 6 edges
5. `ReaderPage` - 6 edges
6. `BharatiyamApp` - 5 edges
7. `Shloka` - 5 edges
8. `_HomeScreenState` - 5 edges
9. `BookDetailPage` - 5 edges
10. `SettingsPage` - 5 edges

## Surprising Connections (you probably didn't know these)
- `_ShlokaCardState` --inherits--> `State`  [EXTRACTED]
  lib/widgets/shloka_card.dart → admin/js/app.js
- `App object (admin CRUD logic)` --references--> `SEED`  [EXTRACTED]
  D:/bharatheeyam books/admin/js/app.js → admin/js/app.js
- `App object (admin CRUD logic)` --references--> `State`  [EXTRACTED]
  D:/bharatheeyam books/admin/js/app.js → admin/js/app.js
- `_HomeScreenState` --inherits--> `State`  [EXTRACTED]
  lib/screens/home_screen.dart → admin/js/app.js
- `_HomeTabState` --inherits--> `State`  [EXTRACTED]
  lib/screens/home_screen.dart → admin/js/app.js

## Import Cycles
- None detected.

## Communities (15 total, 1 thin omitted)

### Community 0 - "Navigation and Routing"
Cohesion: 0.08
Nodes (40): Chapter, FirebaseService, App object (admin CRUD logic), State, MaterialPageRoute, book, BookDetailPage, BookListPage (+32 more)

### Community 1 - "Admin Panel and Concepts"
Cohesion: 0.07
Nodes (28): Admin Panel (index.html), Bookmark/Favorites System, Category Hierarchy (library/mantras/stotras → subcategory → book → chapter → shloka), Conversation Backup & Build Artifact Strategy, Deity-Based Content Organization, Firebase Backend (Auth + Firestore), Firestore backend (books/chapters/shlokas/categories collections), Flutter + Web Dual-Platform Architecture (+20 more)

### Community 2 - "Theme and UI Components"
Cohesion: 0.06
Nodes (34): Book, ../models/shloka.dart, package:flutter/material.dart, package:google_fonts/google_fonts.dart, SubCategory, AppTheme, ../theme/app_theme.dart, gold (+26 more)

### Community 3 - "Data Models"
Cohesion: 0.06
Nodes (34): AppCategory, Book, bookId, bookTitle, bookTitleEn, category, Chapter, chapters (+26 more)

### Community 4 - "App Bootstrap and Providers"
Cohesion: 0.08
Nodes (29): Provider state management pattern, BharatiyamApp, build, firebaseService, init, main, package:firebase_core/firebase_core.dart, package:provider/provider.dart (+21 more)

### Community 5 - "Firestore Service Layer"
Cohesion: 0.07
Nodes (26): ChangeNotifier, Offline-first architecture (bundled data + Firestore sync), ../data/content_data.dart, FirebaseFirestore?, List, package:cloud_firestore/cloud_firestore.dart, _books, _categories (+18 more)

### Community 6 - "Bookmark and Preferences"
Cohesion: 0.08
Nodes (23): bool get, dart:convert, double get, int get, Map, package:flutter/foundation.dart, package:shared_preferences/shared_preferences.dart, _bookmarks (+15 more)

### Community 7 - "Content Data and Seed"
Cohesion: 0.11
Nodes (17): App, appName, appNameEn, appTagline, books, categories, ContentData, getAllShlokas (+9 more)

### Community 8 - "Firebase Config"
Cohesion: 0.25
Nodes (7): firestore, indexes, rules, hosting, ignore, public, rewrites

### Community 9 - "Deity Icons"
Cohesion: 0.32
Nodes (8): Devi (Durga) - Hindu goddess depicted with eight arms riding a lion, holding trishul, lotus, mace, shield, chakra, and bow; red saree, gold crown and jewelry; circular gold-bordered medallion on dark background; flat vector illustration style, Ganesha - Elephant-headed Hindu deity seated in padmasana on ornate pedestal, four arms holding axe, noose, modak, and abhaya mudra; Om symbol on trunk; gold-teal-maroon color palette; circular gold-bordered medallion on dark background; flat vector illustration style, Hanuman - Monkey-faced Hindu deity in namaste pose with golden mace (gada) over shoulder; ornate crown with Om symbols, radiant halo, flower garlands; gold armor; decorative circular gold border with scrollwork on dark navy background; flat vector illustration style, Krishna - Blue-skinned Hindu deity playing the flute (bansuri) in tribhanga pose; peacock feather in golden crown, yellow dhoti, standing on lotus pedestal; circular gold-bordered medallion on black background; flat vector illustration style, Rama - Blue-skinned Hindu deity in profile holding bow (Kodanda) with quiver of arrows; golden crown with peacock feather, Vaishnava tilak, royal jewelry; circular gold-bordered medallion on dark background; flat vector illustration style, Shiva - Blue-skinned Hindu deity in deep meditation (dhyana), seated in padmasana; matted hair (jata) with crescent moon, trishul with damaru drum, rudraksha mala, third-eye marks (tripundra); circular gold double-bordered medallion on dark navy background; flat vector illustration style, Surya - Hindu sun god with radiant solar halo, holding chakra and lotus; riding golden chariot drawn by seven white horses with charioteer Aruna; ornate circular border with lotus and star motifs on dark navy background; flat vector illustration style, Vishnu - Blue-skinned four-armed Hindu deity seated on lotus in padmasana; holding Sudarshana Chakra, Panchajanya conch, Kaumodaki mace, and Padma lotus; peacock feather in crown, Vaishnava tilak; circular gold-bordered medallion on dark navy background; flat vector illustration style

### Community 10 - "Android Build System"
Cohesion: 0.33
Nodes (5): Android root build.gradle, Android settings.gradle, Android app build.gradle, FlutterActivity, MainActivity

## Knowledge Gaps
- **145 isolated node(s):** `auth`, `db`, `App`, `public`, `ignore` (+140 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Shloka` connect `Data Models` to `App Bootstrap and Providers`, `Firestore Service Layer`, `Bookmark and Preferences`?**
  _High betweenness centrality (0.032) - this node is a cross-community bridge._
- **What connects `auth`, `db`, `App` to the rest of the system?**
  _145 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Navigation and Routing` be split into smaller, more focused modules?**
  _Cohesion score 0.07804878048780488 - nodes in this community are weakly interconnected._
- **Should `Admin Panel and Concepts` be split into smaller, more focused modules?**
  _Cohesion score 0.07112375533428165 - nodes in this community are weakly interconnected._
- **Should `Theme and UI Components` be split into smaller, more focused modules?**
  _Cohesion score 0.06306306306306306 - nodes in this community are weakly interconnected._
- **Should `Data Models` be split into smaller, more focused modules?**
  _Cohesion score 0.06218487394957983 - nodes in this community are weakly interconnected._
- **Should `App Bootstrap and Providers` be split into smaller, more focused modules?**
  _Cohesion score 0.07956989247311828 - nodes in this community are weakly interconnected._