# 🕉️ ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ | Bharatiyam Gratha Sudha

> ಭಾರತೀಯ ಆಧ್ಯಾತ್ಮಿಕ ಗ್ರಂಥಗಳ ಡಿಜಿಟಲ್ ಗ್ರಂಥಾಲಯ  
> Digital Library of Indian Spiritual Texts

## ✨ Features

- 📚 **Library** — Vedas, Upanishads, Bhagavad Gita, Ramayana, Mahabharata, Puranas
- 🙏 **Gods** — Shiva, Vishnu, Devi, Ganesha, Hanuman, Surya, Krishna, Rama
- 📿 **Stotras** — Gayatri Mantra, Vishnu Sahasranama, Shiva Tandava, Hanuman Chalisa
- 📖 **Three-layer shloka display** — Sanskrit (Devanagari) → Kannada → Meaning + Explanation
- 💖 **Bookmark** — Save your favorite shlokas
- 🌙 **Dark Mode** — Beautiful spiritual dark theme
- 🔤 **Font Size** — Adjustable text size
- 📱 **Android** — Native Android APK
- 🌐 **Web** — HTML/CSS/JS web version included

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| Framework | Flutter |
| Language | Dart |
| State Management | Provider |
| Local Storage | SharedPreferences |
| Fonts | Noto Sans Devanagari + Noto Sans Kannada |
| CI/CD | GitHub Actions |

## 📁 Project Structure

```
├── lib/                    # Flutter source code
│   ├── main.dart           # App entry point
│   ├── models/             # Data models
│   ├── data/               # Content data
│   ├── services/           # Bookmark service
│   ├── screens/            # App screens
│   ├── widgets/            # Reusable widgets
│   └── theme/              # App theme
├── android/                # Android project
├── web/                    # Web prototype (HTML/CSS/JS)
├── .github/workflows/      # GitHub Actions CI/CD
├── scripts/                # Build & backup scripts
└── conversation_backup/    # Dev conversation logs
```

## 🚀 Build

### APK (via GitHub Actions)
Push to `main` branch — GitHub Actions automatically builds the APK.
Download from **Actions → Artifacts**.

### Local (requires Flutter SDK)
```bash
flutter pub get
flutter build apk --release
```

### Web Prototype
Open `web/index.html` in any browser.

## 📜 Backup Script

Push with automatic conversation backup:
```powershell
.\scripts\push_with_backup.ps1 "your commit message"
```

## 🙏 

> सर्वे भवन्तु सुखिनः सर्वे सन्तु निरामयाः  
> ಎಲ್ಲರೂ ಸುಖಿಗಳಾಗಲಿ, ಎಲ್ಲರೂ ರೋಗಮುಕ್ತರಾಗಲಿ
