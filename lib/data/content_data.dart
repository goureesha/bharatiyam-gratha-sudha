import '../models/shloka.dart';

/// Static content data — mirrors the web version's data.js
class ContentData {
  static const appName = 'ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ';
  static const appNameEn = 'Bharatiyam Gratha Sudha';
  static const appTagline = 'ಭಾರತೀಯ ಆಧ್ಯಾತ್ಮಿಕ ಗ್ರಂಥಗಳ ಡಿಜಿಟಲ್ ಗ್ರಂಥಾಲಯ';

  // ── Categories ──────────────────────────────────────────────
  static const categories = <String, AppCategory>{
    'library': AppCategory(
      id: 'library', title: 'ಗ್ರಂಥಾಲಯ', titleEn: 'Library', icon: '📚',
      description: 'ವೇದ, ಉಪನಿಷತ್, ಗೀತೆ ಮತ್ತು ಇತರ ಗ್ರಂಥಗಳು',
      subcategories: [
        SubCategory(id: 'vedas', title: 'ವೇದಗಳು', titleEn: 'Vedas', icon: '🕉️'),
        SubCategory(id: 'upanishads', title: 'ಉಪನಿಷತ್ತುಗಳು', titleEn: 'Upanishads', icon: '📜'),
        SubCategory(id: 'bhagavad_gita', title: 'ಭಗವದ್ಗೀತೆ', titleEn: 'Bhagavad Gita', icon: '🎯'),
        SubCategory(id: 'ramayana', title: 'ರಾಮಾಯಣ', titleEn: 'Ramayana', icon: '🏹'),
        SubCategory(id: 'mahabharata', title: 'ಮಹಾಭಾರತ', titleEn: 'Mahabharata', icon: '⚔️'),
        SubCategory(id: 'puranas', title: 'ಪುರಾಣಗಳು', titleEn: 'Puranas', icon: '📖'),
      ],
    ),
    'gods': AppCategory(
      id: 'gods', title: 'ದೇವತೆಗಳು', titleEn: 'Gods', icon: '🙏',
      description: 'ದೇವರ ಸ್ತುತಿ ಮತ್ತು ಮಹಿಮೆ',
      subcategories: [
        SubCategory(id: 'shiva', title: 'ಶಿವ', titleEn: 'Lord Shiva', icon: '🔱'),
        SubCategory(id: 'vishnu', title: 'ವಿಷ್ಣು', titleEn: 'Lord Vishnu', icon: '🪷'),
        SubCategory(id: 'devi', title: 'ದೇವಿ', titleEn: 'Devi', icon: '🌺'),
        SubCategory(id: 'ganesha', title: 'ಗಣೇಶ', titleEn: 'Lord Ganesha', icon: '🐘'),
        SubCategory(id: 'hanuman', title: 'ಹನುಮಂತ', titleEn: 'Lord Hanuman', icon: '🐒'),
        SubCategory(id: 'surya', title: 'ಸೂರ್ಯ', titleEn: 'Lord Surya', icon: '☀️'),
        SubCategory(id: 'krishna', title: 'ಕೃಷ್ಣ', titleEn: 'Lord Krishna', icon: '🦚'),
        SubCategory(id: 'rama', title: 'ರಾಮ', titleEn: 'Lord Rama', icon: '🏹'),
      ],
    ),
    'stotras': AppCategory(
      id: 'stotras', title: 'ಸ್ತೋತ್ರಗಳು', titleEn: 'Stotras', icon: '📿',
      description: 'ಪವಿತ್ರ ಸ್ತೋತ್ರಗಳು ಮತ್ತು ಮಂತ್ರಗಳು',
      subcategories: [
        SubCategory(id: 'gayatri', title: 'ಗಾಯತ್ರೀ ಮಂತ್ರ', titleEn: 'Gayatri Mantra', icon: '☀️'),
        SubCategory(id: 'vishnu_sahasranama', title: 'ವಿಷ್ಣು ಸಹಸ್ರನಾಮ', titleEn: 'Vishnu Sahasranama', icon: '🪷'),
        SubCategory(id: 'lalita_sahasranama', title: 'ಲಲಿತಾ ಸಹಸ್ರನಾಮ', titleEn: 'Lalita Sahasranama', icon: '🌺'),
        SubCategory(id: 'shiva_tandava', title: 'ಶಿವ ತಾಂಡವ ಸ್ತೋತ್ರ', titleEn: 'Shiva Tandava Stotram', icon: '🔱'),
        SubCategory(id: 'hanuman_chalisa', title: 'ಹನುಮಾನ್ ಚಾಲೀಸಾ', titleEn: 'Hanuman Chalisa', icon: '🐒'),
        SubCategory(id: 'aditya_hridaya', title: 'ಆದಿತ್ಯ ಹೃದಯ', titleEn: 'Aditya Hridayam', icon: '☀️'),
      ],
    ),
  };

  // ── Books ───────────────────────────────────────────────────
  static const books = <Book>[
    // ── BHAGAVAD GITA ─────────────────────────────────────────
    Book(
      id: 'bhagavad_gita', title: 'ಶ್ರೀಮದ್ ಭಗವದ್ಗೀತೆ',
      titleSanskrit: 'श्रीमद् भगवद्गीता', titleEn: 'Shrimad Bhagavad Gita',
      category: 'library', subcategory: 'bhagavad_gita',
      godRelated: ['krishna', 'vishnu'],
      description: 'ಕುರುಕ್ಷೇತ್ರ ಯುದ್ಧಭೂಮಿಯಲ್ಲಿ ಶ್ರೀ ಕೃಷ್ಣನು ಅರ್ಜುನನಿಗೆ ಬೋಧಿಸಿದ ಪವಿತ್ರ ಉಪದೇಶ',
      chapters: [
        Chapter(id: 'bg_ch1', number: 1, title: 'ಅರ್ಜುನ ವಿಷಾದ ಯೋಗ',
          titleSanskrit: 'अर्जुन विषाद योग', titleEn: 'Arjuna Vishada Yoga',
          shlokas: [
            Shloka(id: 'bg_1_1', number: '1.1',
              sanskrit: 'धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः ।\nमामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ॥',
              kannada: 'ಧರ್ಮಕ್ಷೇತ್ರೇ ಕುರುಕ್ಷೇತ್ರೇ ಸಮವೇತಾ ಯುಯುತ್ಸವಃ ।\nಮಾಮಕಾಃ ಪಾಂಡವಾಶ್ಚೈವ ಕಿಮಕುರ್ವತ ಸಂಜಯ ॥',
              meaning: 'ಧೃತರಾಷ್ಟ್ರನು ಹೇಳಿದನು — ಹೇ ಸಂಜಯನೇ, ಧರ್ಮಭೂಮಿಯಾದ ಕುರುಕ್ಷೇತ್ರದಲ್ಲಿ ಯುದ್ಧ ಮಾಡಲು ಒಟ್ಟುಗೂಡಿದ ನನ್ನ ಮಕ್ಕಳು ಮತ್ತು ಪಾಂಡುವಿನ ಮಕ್ಕಳು ಏನು ಮಾಡಿದರು?',
              explanation: 'ಈ ಶ್ಲೋಕವು ಭಗವದ್ಗೀತೆಯ ಮೊದಲ ಶ್ಲೋಕವಾಗಿದೆ. ಧೃತರಾಷ್ಟ್ರನು ಕುರುಡನಾಗಿದ್ದರಿಂದ ಯುದ್ಧವನ್ನು ನೋಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. \'ಧರ್ಮಕ್ಷೇತ್ರ\' ಎಂಬ ಪದವು ಈ ಯುದ್ಧಭೂಮಿಯ ಪಾವಿತ್ರ್ಯವನ್ನು ಸೂಚಿಸುತ್ತದೆ.',
            ),
            Shloka(id: 'bg_1_2', number: '1.2',
              sanskrit: 'सञ्जय उवाच ।\nदृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।\nआचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ॥',
              kannada: 'ಸಂಜಯ ಉವಾಚ ।\nದೃಷ್ಟ್ವಾ ತು ಪಾಂಡವಾನೀಕಂ ವ್ಯೂಢಂ ದುರ್ಯೋಧನಸ್ತದಾ ।\nಆಚಾರ್ಯಮುಪಸಂಗಮ್ಯ ರಾಜಾ ವಚನಮಬ್ರವೀತ್ ॥',
              meaning: 'ಸಂಜಯನು ಹೇಳಿದನು — ಪಾಂಡವರ ಸೈನ್ಯವು ವ್ಯೂಹ ರಚನೆಯಲ್ಲಿ ನಿಂತಿರುವುದನ್ನು ನೋಡಿ, ರಾಜ ದುರ್ಯೋಧನನು ತನ್ನ ಗುರು ದ್ರೋಣಾಚಾರ್ಯರ ಬಳಿ ಹೋಗಿ ಈ ಮಾತನ್ನು ಹೇಳಿದನು.',
              explanation: 'ದುರ್ಯೋಧನನು ಪಾಂಡವರ ಬಲಿಷ್ಠ ಸೈನ್ಯವನ್ನು ನೋಡಿ ಆತಂಕಗೊಂಡು ತನ್ನ ಗುರುವಿನ ಬಳಿ ಹೋಗುತ್ತಾನೆ.',
            ),
            Shloka(id: 'bg_1_3', number: '1.3',
              sanskrit: 'पश्यैतां पाण्डुपुत्राणामाचार्य महतीं चमूम् ।\nव्यूढां द्रुपदपुत्रेण तव शिष्येण धीमता ॥',
              kannada: 'ಪಶ್ಯೈತಾಂ ಪಾಂಡುಪುತ್ರಾಣಾಮಾಚಾರ್ಯ ಮಹತೀಂ ಚಮೂಮ್ ।\nವ್ಯೂಢಾಂ ದ್ರುಪದಪುತ್ರೇಣ ತವ ಶಿಷ್ಯೇಣ ಧೀಮತಾ ॥',
              meaning: 'ಹೇ ಆಚಾರ್ಯರೇ, ಪಾಂಡವರ ಈ ಮಹಾ ಸೈನ್ಯವನ್ನು ನೋಡಿರಿ. ನಿಮ್ಮ ಬುದ್ಧಿವಂತ ಶಿಷ್ಯನಾದ ದ್ರುಪದ ಪುತ್ರ ಧೃಷ್ಟದ್ಯುಮ್ನನು ಈ ಸೈನ್ಯವನ್ನು ವ್ಯೂಹ ರಚನೆಯಲ್ಲಿ ನಿಲ್ಲಿಸಿದ್ದಾನೆ.',
              explanation: 'ದುರ್ಯೋಧನನು ದ್ರೋಣಾಚಾರ್ಯರನ್ನು ಪ್ರಚೋದಿಸಲು ಪ್ರಯತ್ನಿಸುತ್ತಿದ್ದಾನೆ.',
            ),
          ],
        ),
        Chapter(id: 'bg_ch2', number: 2, title: 'ಸಾಂಖ್ಯ ಯೋಗ',
          titleSanskrit: 'सांख्य योग', titleEn: 'Sankhya Yoga',
          shlokas: [
            Shloka(id: 'bg_2_47', number: '2.47',
              sanskrit: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन ।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि ॥',
              kannada: 'ಕರ್ಮಣ್ಯೇವಾಧಿಕಾರಸ್ತೇ ಮಾ ಫಲೇಷು ಕದಾಚನ ।\nಮಾ ಕರ್ಮಫಲಹೇತುರ್ಭೂರ್ಮಾ ತೇ ಸಂಗೋಽಸ್ತ್ವಕರ್ಮಣಿ ॥',
              meaning: 'ನಿನಗೆ ಕರ್ಮ ಮಾಡುವ ಅಧಿಕಾರ ಮಾತ್ರ ಇದೆ, ಕರ್ಮಫಲದ ಮೇಲೆ ಎಂದಿಗೂ ಅಧಿಕಾರವಿಲ್ಲ.',
              explanation: 'ಇದು ಭಗವದ್ಗೀತೆಯ ಅತ್ಯಂತ ಪ್ರಸಿದ್ಧ ಶ್ಲೋಕ. ಫಲಾಪೇಕ್ಷೆ ಇಲ್ಲದೆ ಕರ್ಮ ಮಾಡುವುದೇ ನಿಜವಾದ ಯೋಗ.',
            ),
            Shloka(id: 'bg_2_48', number: '2.48',
              sanskrit: 'योगस्थः कुरु कर्माणि सङ्गं त्यक्त्वा धनञ्जय ।\nसिद्ध्यसिद्ध्योः समो भूत्वा समत्वं योग उच्यते ॥',
              kannada: 'ಯೋಗಸ್ಥಃ ಕುರು ಕರ್ಮಾಣಿ ಸಂಗಂ ತ್ಯಕ್ತ್ವಾ ಧನಂಜಯ ।\nಸಿದ್ಧ್ಯಸಿದ್ಧ್ಯೋಃ ಸಮೋ ಭೂತ್ವಾ ಸಮತ್ವಂ ಯೋಗ ಉಚ್ಯತೇ ॥',
              meaning: 'ಹೇ ಧನಂಜಯ, ಯೋಗದಲ್ಲಿ ಸ್ಥಿರವಾಗಿ ನಿಂತು, ಆಸಕ್ತಿಯನ್ನು ತ್ಯಜಿಸಿ ಕರ್ಮಗಳನ್ನು ಮಾಡು. ಸಮಭಾವವೇ ಯೋಗ.',
              explanation: 'ಸಮತ್ವ ಭಾವನೆ — ಗೆಲುವು ಮತ್ತು ಸೋಲು ಎರಡರಲ್ಲೂ ಸಮಾನ ಮನಸ್ಸಿನಿಂದ ಇರುವುದೇ ನಿಜವಾದ ಯೋಗ.',
            ),
            Shloka(id: 'bg_2_62', number: '2.62',
              sanskrit: 'ध्यायतो विषयान्पुंसः सङ्गस्तेषूपजायते ।\nसङ्गात्सञ्जायते कामः कामात्क्रोधोऽभिजायते ॥',
              kannada: 'ಧ್ಯಾಯತೋ ವಿಷಯಾನ್ಪುಂಸಃ ಸಂಗಸ್ತೇಷೂಪಜಾಯತೇ ।\nಸಂಗಾತ್ಸಂಜಾಯತೇ ಕಾಮಃ ಕಾಮಾತ್ಕ್ರೋಧೋಽಭಿಜಾಯತೇ ॥',
              meaning: 'ವಿಷಯಗಳ ಬಗ್ಗೆ ಚಿಂತಿಸುವ ಮನುಷ್ಯನಿಗೆ ಅವುಗಳಲ್ಲಿ ಆಸಕ್ತಿ ಹುಟ್ಟುತ್ತದೆ. ಆಸಕ್ತಿಯಿಂದ ಕಾಮನೆ, ಕಾಮನೆಯಿಂದ ಕ್ರೋಧ ಹುಟ್ಟುತ್ತದೆ.',
              explanation: 'ಮನಸ್ಸಿನ ಪತನದ ಹಂತಗಳು: ಚಿಂತನೆ → ಆಸಕ್ತಿ → ಕಾಮ → ಕ್ರೋಧ → ಮೋಹ → ಸ್ಮೃತಿ ನಾಶ → ಬುದ್ಧಿ ನಾಶ → ಸರ್ವನಾಶ.',
            ),
          ],
        ),
        Chapter(id: 'bg_ch12', number: 12, title: 'ಭಕ್ತಿ ಯೋಗ',
          titleSanskrit: 'भक्ति योग', titleEn: 'Bhakti Yoga',
          shlokas: [
            Shloka(id: 'bg_12_13', number: '12.13',
              sanskrit: 'अद्वेष्टा सर्वभूतानां मैत्रः करुण एव च ।\nनिर्ममो निरहङ्कारः समदुःखसुखः क्षमी ॥',
              kannada: 'ಅದ್ವೇಷ್ಟಾ ಸರ್ವಭೂತಾನಾಂ ಮೈತ್ರಃ ಕರುಣ ಏವ ಚ ।\nನಿರ್ಮಮೋ ನಿರಹಂಕಾರಃ ಸಮದುಃಖಸುಖಃ ಕ್ಷಮೀ ॥',
              meaning: 'ಎಲ್ಲ ಪ್ರಾಣಿಗಳ ಮೇಲೆ ದ್ವೇಷವಿಲ್ಲದ, ಎಲ್ಲರಿಗೂ ಮಿತ್ರನಾದ, ಕರುಣೆಯುಳ್ಳ ಭಕ್ತನು ನನಗೆ ಪ್ರಿಯನಾಗಿದ್ದಾನೆ.',
              explanation: 'ಕೃಷ್ಣನು ತನ್ನ ಪ್ರಿಯ ಭಕ್ತನ ಲಕ್ಷಣಗಳನ್ನು ವಿವರಿಸುತ್ತಿದ್ದಾನೆ.',
            ),
          ],
        ),
      ],
    ),

    // ── GAYATRI MANTRA ─────────────────────────────────────────
    Book(
      id: 'gayatri_mantra', title: 'ಗಾಯತ್ರೀ ಮಂತ್ರ',
      titleSanskrit: 'गायत्री मन्त्र', titleEn: 'Gayatri Mantra',
      category: 'stotras', subcategory: 'gayatri', godRelated: ['surya'],
      description: 'ವೇದಗಳ ಮಾತೆ ಎಂದು ಕರೆಯಲ್ಪಡುವ ಅತ್ಯಂತ ಪವಿತ್ರ ಮಂತ್ರ',
      chapters: [
        Chapter(id: 'gayatri_ch1', number: 1, title: 'ಗಾಯತ್ರೀ ಮಂತ್ರ',
          titleSanskrit: 'गायत्री मन्त्र', titleEn: 'Gayatri Mantra',
          shlokas: [
            Shloka(id: 'gayatri_1', number: '1',
              sanskrit: 'ॐ भूर्भुवः स्वः\nतत्सवितुर्वरेण्यं\nभर्गो देवस्य धीमहि\nधियो यो नः प्रचोदयात् ॥',
              kannada: 'ಓಂ ಭೂರ್ಭುವಃ ಸ್ವಃ\nತತ್ಸವಿತುರ್ವರೇಣ್ಯಂ\nಭರ್ಗೋ ದೇವಸ್ಯ ಧೀಮಹಿ\nಧಿಯೋ ಯೋ ನಃ ಪ್ರಚೋದಯಾತ್ ॥',
              meaning: 'ಓಂ — ಸವಿತೃ ದೇವನ ಆ ಶ್ರೇಷ್ಠವಾದ ತೇಜಸ್ಸನ್ನು ನಾವು ಧ್ಯಾನಿಸುತ್ತೇವೆ. ಆ ದೇವನು ನಮ್ಮ ಬುದ್ಧಿಯನ್ನು ಸನ್ಮಾರ್ಗದಲ್ಲಿ ಪ್ರೇರೇಪಿಸಲಿ.',
              explanation: 'ಗಾಯತ್ರೀ ಮಂತ್ರವು ಋಗ್ವೇದದ ಅತ್ಯಂತ ಪವಿತ್ರ ಮಂತ್ರ. ಇದನ್ನು ವೇದಮಾತೆ ಎಂದು ಕರೆಯುತ್ತಾರೆ.',
            ),
          ],
        ),
      ],
    ),

    // ── SHIVA TANDAVA ──────────────────────────────────────────
    Book(
      id: 'shiva_tandava', title: 'ಶಿವ ತಾಂಡವ ಸ್ತೋತ್ರಮ್',
      titleSanskrit: 'शिव ताण्डव स्तोत्रम्', titleEn: 'Shiva Tandava Stotram',
      category: 'stotras', subcategory: 'shiva_tandava', godRelated: ['shiva'],
      description: 'ರಾವಣನಿಂದ ರಚಿತವಾದ ಶಿವನ ತಾಂಡವ ನೃತ್ಯದ ಮಹಾ ಸ್ತೋತ್ರ',
      chapters: [
        Chapter(id: 'st_ch1', number: 1, title: 'ಶಿವ ತಾಂಡವ ಸ್ತೋತ್ರಮ್',
          titleSanskrit: 'शिव ताण्डव स्तोत्रम्', titleEn: 'Shiva Tandava Stotram',
          shlokas: [
            Shloka(id: 'st_1', number: '1',
              sanskrit: 'जटाटवीगलज्जलप्रवाहपावितस्थले\nगलेऽवलम्ब्य लम्बितां भुजङ्गतुङ्गमालिकाम् ।\nडमड्डमड्डमड्डमन्निनादवड्डमर्वयं\nचकार चण्डताण्डवं तनोतु नः शिवः शिवम् ॥',
              kannada: 'ಜಟಾಟವೀಗಲಜ್ಜಲಪ್ರವಾಹಪಾವಿತಸ್ಥಲೇ\nಗಲೇಽವಲಂಬ್ಯ ಲಂಬಿತಾಂ ಭುಜಂಗತುಂಗಮಾಲಿಕಾಮ್ ।\nಡಮಡ್ಡಮಡ್ಡಮಡ್ಡಮನ್ನಿನಾದವಡ್ಡಮರ್ವಯಂ\nಚಕಾರ ಚಂಡತಾಂಡವಂ ತನೋತು ನಃ ಶಿವಃ ಶಿವಮ್ ॥',
              meaning: 'ಡಮರುಗದ ನಾದದೊಂದಿಗೆ ಪ್ರಚಂಡ ತಾಂಡವ ನೃತ್ಯ ಮಾಡುವ ಶಿವನು ನಮಗೆ ಮಂಗಳವನ್ನುಂಟು ಮಾಡಲಿ.',
              explanation: 'ಶಿವ ತಾಂಡವ ಸ್ತೋತ್ರವನ್ನು ಲಂಕಾಧಿಪತಿ ರಾವಣನು ರಚಿಸಿದನೆಂದು ಹೇಳಲಾಗುತ್ತದೆ.',
            ),
            Shloka(id: 'st_2', number: '2',
              sanskrit: 'जटाकटाहसम्भ्रमभ्रमन्निलिम्पनिर्झरी-\nविलोलवीचिवल्लरीविराजमानमूर्धनि ।\nधगद्धगद्धगज्ज्वलल्ललाटपट्टपावके\nकिशोरचन्द्रशेखरे रतिः प्रतिक्षणं मम ॥',
              kannada: 'ಜಟಾಕಟಾಹಸಂಭ್ರಮಭ್ರಮನ್ನಿಲಿಂಪನಿರ್ಝರೀ-\nವಿಲೋಲವೀಚಿವಲ್ಲರೀವಿರಾಜಮಾನಮೂರ್ಧನಿ ।\nಧಗದ್ಧಗದ್ಧಗಜ್ಜ್ವಲಲ್ಲಲಾಟಪಟ್ಟಪಾವಕೇ\nಕಿಶೋರಚಂದ್ರಶೇಖರೇ ರತಿಃ ಪ್ರತಿಕ್ಷಣಂ ಮಮ ॥',
              meaning: 'ಬಾಲಚಂದ್ರನನ್ನು ಶಿರಸ್ಸಿನಲ್ಲಿ ಧರಿಸಿರುವ ಶಿವನಲ್ಲಿ ಪ್ರತಿ ಕ್ಷಣವೂ ನನ್ನ ಪ್ರೀತಿ ಇರಲಿ.',
              explanation: 'ಶಿವನ ಶಿರಸ್ಸಿನ ಸೌಂದರ್ಯ — ಗಂಗೆ, ಅಗ್ನಿ ಮತ್ತು ಚಂದ್ರ ಒಟ್ಟಿಗೆ ಶೋಭಿಸುವ ಅದ್ಭುತ ದೃಶ್ಯ.',
            ),
          ],
        ),
      ],
    ),

    // ── VISHNU SAHASRANAMA ─────────────────────────────────────
    Book(
      id: 'vishnu_sahasranama', title: 'ವಿಷ್ಣು ಸಹಸ್ರನಾಮ',
      titleSanskrit: 'विष्णु सहस्रनाम', titleEn: 'Vishnu Sahasranama',
      category: 'stotras', subcategory: 'vishnu_sahasranama', godRelated: ['vishnu'],
      description: 'ಮಹಾಭಾರತದ ಅನುಶಾಸನ ಪರ್ವದಲ್ಲಿ ಬರುವ ವಿಷ್ಣುವಿನ ಸಾವಿರ ನಾಮಗಳ ಸ್ತೋತ್ರ',
      chapters: [
        Chapter(id: 'vs_ch1', number: 1, title: 'ಪೂರ್ವ ಪೀಠಿಕಾ',
          titleSanskrit: 'पूर्व पीठिका', titleEn: 'Introduction',
          shlokas: [
            Shloka(id: 'vs_1', number: '1',
              sanskrit: 'शुक्लाम्बरधरं विष्णुं शशिवर्णं चतुर्भुजम् ।\nप्रसन्नवदनं ध्यायेत् सर्वविघ्नोपशान्तये ॥',
              kannada: 'ಶುಕ್ಲಾಂಬರಧರಂ ವಿಷ್ಣುಂ ಶಶಿವರ್ಣಂ ಚತುರ್ಭುಜಮ್ ।\nಪ್ರಸನ್ನವದನಂ ಧ್ಯಾಯೇತ್ ಸರ್ವವಿಘ್ನೋಪಶಾಂತಯೇ ॥',
              meaning: 'ಬಿಳಿ ಬಟ್ಟೆ ಧರಿಸಿರುವ, ಚಂದ್ರನಂತೆ ಬಣ್ಣವುಳ್ಳ, ನಾಲ್ಕು ಕೈಗಳಿರುವ ವಿಷ್ಣುವನ್ನು ಧ್ಯಾನಿಸಬೇಕು.',
              explanation: 'ಇದು ವಿಷ್ಣು ಸಹಸ್ರನಾಮದ ಧ್ಯಾನ ಶ್ಲೋಕ.',
            ),
            Shloka(id: 'vs_2', number: '2',
              sanskrit: 'यस्य स्मरणमात्रेण जन्मसंसारबन्धनात् ।\nविमुच्यते नमस्तस्मै विष्णवे प्रभविष्णवे ॥',
              kannada: 'ಯಸ್ಯ ಸ್ಮರಣಮಾತ್ರೇಣ ಜನ್ಮಸಂಸಾರಬಂಧನಾತ್ ।\nವಿಮುಚ್ಯತೇ ನಮಸ್ತಸ್ಮೈ ವಿಷ್ಣವೇ ಪ್ರಭವಿಷ್ಣವೇ ॥',
              meaning: 'ಯಾರ ಸ್ಮರಣೆ ಮಾತ್ರದಿಂದಲೇ ಸಂಸಾರ ಬಂಧನದಿಂದ ಮುಕ್ತಿ, ಆ ವಿಷ್ಣುವಿಗೆ ನಮಸ್ಕಾರ.',
              explanation: 'ವಿಷ್ಣುವಿನ ನಾಮಸ್ಮರಣೆಯ ಮಹಿಮೆ.',
            ),
          ],
        ),
      ],
    ),

    // ── HANUMAN CHALISA ────────────────────────────────────────
    Book(
      id: 'hanuman_chalisa', title: 'ಹನುಮಾನ್ ಚಾಲೀಸಾ',
      titleSanskrit: 'हनुमान चालीसा', titleEn: 'Hanuman Chalisa',
      category: 'stotras', subcategory: 'hanuman_chalisa', godRelated: ['hanuman', 'rama'],
      description: 'ತುಲಸೀದಾಸರು ರಚಿಸಿದ ಹನುಮಂತನ ಸ್ತುತಿಗೀತೆ',
      chapters: [
        Chapter(id: 'hc_ch1', number: 1, title: 'ಹನುಮಾನ್ ಚಾಲೀಸಾ',
          titleSanskrit: 'हनुमान चालीसा', titleEn: 'Hanuman Chalisa',
          shlokas: [
            Shloka(id: 'hc_1', number: 'ದೋಹಾ 1',
              sanskrit: 'श्रीगुरु चरन सरोज रज निज मनु मुकुरु सुधारि ।\nबरनउँ रघुबर बिमल जसु जो दायकु फल चारि ॥',
              kannada: 'ಶ್ರೀಗುರು ಚರಣ ಸರೋಜ ರಜ ನಿಜ ಮನು ಮುಕುರು ಸುಧಾರಿ ।\nಬರನಉँ ರಘುಬರ ಬಿಮಲ ಜಸು ಜೋ ದಾಯಕು ಫಲ ಚಾರಿ ॥',
              meaning: 'ಗುರುವಿನ ಚರಣ ಕಮಲದ ಧೂಳಿನಿಂದ ಮನಸ್ಸೆಂಬ ಕನ್ನಡಿಯನ್ನು ಶುಚಿಗೊಳಿಸಿ, ಶ್ರೀ ರಘುನಾಥನ ಯಶಸ್ಸನ್ನು ವರ್ಣಿಸುತ್ತೇನೆ.',
              explanation: 'ಮೊದಲ ದೋಹಾದಲ್ಲಿ ಗುರುವಿಗೆ ವಂದಿಸಿ, ಶ್ರೀ ರಾಮನ ಯಶಸ್ಸನ್ನು ಹಾಡಲು ಅನುಮತಿ ಕೋರುತ್ತಾರೆ.',
            ),
            Shloka(id: 'hc_2', number: 'ದೋಹಾ 2',
              sanskrit: 'बुद्धिहीन तनु जानिके सुमिरौं पवन कुमार ।\nबल बुद्धि बिद्या देहु मोहिं हरहु कलेस बिकार ॥',
              kannada: 'ಬುದ್ಧಿಹೀನ ತನು ಜಾನಿಕೇ ಸುಮಿರೌಂ ಪವನ ಕುಮಾರ ।\nಬಲ ಬುದ್ಧಿ ಬಿದ್ಯಾ ದೇಹು ಮೋಹಿಂ ಹರಹು ಕಲೇಸ ಬಿಕಾರ ॥',
              meaning: 'ಹೇ ಪವನ ಕುಮಾರ ಹನುಮಂತನೇ, ನನಗೆ ಬಲ, ಬುದ್ಧಿ, ವಿದ್ಯೆಯನ್ನು ನೀಡು.',
              explanation: 'ತುಲಸೀದಾಸರು ಹನುಮಂತನಲ್ಲಿ ಬಲ, ಬುದ್ಧಿ ಮತ್ತು ವಿದ್ಯೆಯನ್ನು ಬೇಡುತ್ತಾರೆ.',
            ),
            Shloka(id: 'hc_3', number: 'ಚೌಪಾಈ 1',
              sanskrit: 'जय हनुमान ज्ञान गुन सागर ।\nजय कपीस तिहुँ लोक उजागर ॥',
              kannada: 'ಜಯ ಹನುಮಾನ ಜ್ಞಾನ ಗುಣ ಸಾಗರ ।\nಜಯ ಕಪೀಶ ತಿಹುँ ಲೋಕ ಉಜಾಗರ ॥',
              meaning: 'ಜ್ಞಾನ ಮತ್ತು ಗುಣಗಳ ಸಾಗರನಾದ ಹನುಮಂತನಿಗೆ ಜಯವಾಗಲಿ.',
              explanation: 'ಹನುಮಂತನನ್ನು ಜ್ಞಾನಸಾಗರ ಮತ್ತು ತ್ರಿಲೋಕ ಪ್ರಕಾಶಕ ಎಂದು ವರ್ಣಿಸಲಾಗಿದೆ.',
            ),
          ],
        ),
      ],
    ),

    // ── ISHAVASYA UPANISHAD ────────────────────────────────────
    Book(
      id: 'ishavasya', title: 'ಈಶಾವಾಸ್ಯ ಉಪನಿಷತ್',
      titleSanskrit: 'ईशावास्य उपनिषद्', titleEn: 'Ishavasya Upanishad',
      category: 'library', subcategory: 'upanishads', godRelated: [],
      description: 'ಯಜುರ್ವೇದದ ಅತ್ಯಂತ ಪ್ರಮುಖ ಮತ್ತು ಸಂಕ್ಷಿಪ್ತ ಉಪನಿಷತ್ತು',
      chapters: [
        Chapter(id: 'isha_ch1', number: 1, title: 'ಈಶಾವಾಸ್ಯ ಉಪನಿಷತ್',
          titleSanskrit: 'ईशावास्य उपनिषद्', titleEn: 'Ishavasya Upanishad',
          shlokas: [
            Shloka(id: 'isha_1', number: '1',
              sanskrit: 'ॐ ईशावास्यमिदं सर्वं यत्किञ्च जगत्यां जगत् ।\nतेन त्यक्तेन भुञ्जीथा मा गृधः कस्यस्विद्धनम् ॥',
              kannada: 'ಓಂ ಈಶಾವಾಸ್ಯಮಿದಂ ಸರ್ವಂ ಯತ್ಕಿಂಚ ಜಗತ್ಯಾಂ ಜಗತ್ ।\nತೇನ ತ್ಯಕ್ತೇನ ಭುಂಜೀಥಾ ಮಾ ಗೃಧಃ ಕಸ್ಯಸ್ವಿದ್ಧನಮ್ ॥',
              meaning: 'ಈ ಜಗತ್ತಿನಲ್ಲಿ ಅದೆಲ್ಲವೂ ಈಶ್ವರನಿಂದ ಆವೃತ. ತ್ಯಾಗದಿಂದ ಅನುಭವಿಸು. ಯಾರ ಧನವನ್ನೂ ಬಯಸಬೇಡ.',
              explanation: 'ಎಲ್ಲವೂ ದೈವಮಯ ಎಂಬ ಸಂದೇಶ. ತ್ಯಾಗ ಮತ್ತು ಅನಾಸಕ್ತಿಯಿಂದ ಜೀವಿಸಬೇಕೆಂಬ ಉಪದೇಶ.',
            ),
            Shloka(id: 'isha_2', number: '2',
              sanskrit: 'कुर्वन्नेवेह कर्माणि जिजीविषेच्छतँ समाः ।\nएवं त्वयि नान्यथेतोऽस्ति न कर्म लिप्यते नरे ॥',
              kannada: 'ಕುರ್ವನ್ನೇವೇಹ ಕರ್ಮಾಣಿ ಜಿಜೀವಿಷೇಚ್ಛತಂ ಸಮಾಃ ।\nಏವಂ ತ್ವಯಿ ನಾನ್ಯಥೇತೋಽಸ್ತಿ ನ ಕರ್ಮ ಲಿಪ್ಯತೇ ನರೇ ॥',
              meaning: 'ಕರ್ಮಗಳನ್ನು ಮಾಡುತ್ತಲೇ ನೂರು ವರ್ಷ ಬಾಳಬೇಕು. ಅನಾಸಕ್ತಿಯಿಂದ ಮಾಡಿದಾಗ ಕರ್ಮವು ಅಂಟುವುದಿಲ್ಲ.',
              explanation: 'ಅನಾಸಕ್ತ ಕರ್ಮವೇ ಮೋಕ್ಷದ ಮಾರ್ಗ.',
            ),
          ],
        ),
      ],
    ),
  ];

  // ── Helper Methods ──────────────────────────────────────────

  static List<Shloka> getAllShlokas() {
    final shlokas = <Shloka>[];
    for (final book in books) {
      for (final chapter in book.chapters) {
        for (final shloka in chapter.shlokas) {
          shlokas.add(shloka.copyWith(
            bookId: book.id, bookTitle: book.title,
            bookTitleEn: book.titleEn, chapterTitle: chapter.title,
            category: book.category, subcategory: book.subcategory,
          ));
        }
      }
    }
    return shlokas;
  }

  static List<Book> getBooksByCategory(String categoryId) =>
      books.where((b) => b.category == categoryId).toList();

  static List<Book> getBooksBySubcategory(String subcategoryId) =>
      books.where((b) => b.subcategory == subcategoryId).toList();

  static List<Book> getBooksByGod(String godId) =>
      books.where((b) => b.godRelated.contains(godId)).toList();

  static Book? getBookById(String bookId) {
    try { return books.firstWhere((b) => b.id == bookId); }
    catch (_) { return null; }
  }

  static List<Shloka> searchShlokas(String query) {
    final q = query.toLowerCase();
    final results = <Shloka>[];
    for (final book in books) {
      for (final chapter in book.chapters) {
        for (final shloka in chapter.shlokas) {
          if (shloka.sanskrit.toLowerCase().contains(q) ||
              shloka.kannada.toLowerCase().contains(q) ||
              shloka.meaning.toLowerCase().contains(q) ||
              (shloka.explanation?.toLowerCase().contains(q) ?? false) ||
              book.title.toLowerCase().contains(q) ||
              book.titleEn.toLowerCase().contains(q)) {
            results.add(shloka.copyWith(
              bookId: book.id, bookTitle: book.title,
              bookTitleEn: book.titleEn, chapterTitle: chapter.title,
              category: book.category, subcategory: book.subcategory,
            ));
          }
        }
      }
    }
    return results;
  }
}
