/* ═══════════════════════════════════════════════════════════════
   Bharatiyam Gratha Sudha — Admin Panel Application
   Firebase Firestore CRUD + Auth + Seed Data
   ═══════════════════════════════════════════════════════════════ */

// ── Firebase Init ──────────────────────────────────────────────
firebase.initializeApp({
  apiKey: "AIzaSyC-Xqs_9z5hWQObGqPVUvo0jmWzQjUuo0k",
  authDomain: "bharatiyam-grantha-sudha.firebaseapp.com",
  projectId: "bharatiyam-grantha-sudha",
  storageBucket: "bharatiyam-grantha-sudha.firebasestorage.app",
  messagingSenderId: "396596689592",
  appId: "1:396596689592:web:e24a32f238b6546432924d",
  measurementId: "G-LS7BG9X2P6"
});

const auth = firebase.auth();
const db = firebase.firestore();

// ── App State ──────────────────────────────────────────────────
const State = {
  currentPage: 'dashboard',
  currentBookId: null,
  currentChapterId: null,
  editingBookId: null,
};

// ── SEED DATA (all existing content) ───────────────────────────
const SEED = {
  categories: {
    library: {
      id: 'library', title: 'ಗ್ರಂಥಾಲಯ', titleEn: 'Library', icon: '📚',
      description: 'ವೈದಿಕ ಮತ್ತು ಜ್ಯೋತಿಷ ಗ್ರಂಥಗಳು',
      subcategories: [
        { id: 'vaidika_grantha', title: 'ವೈದಿಕ ಗ್ರಂಥ', titleEn: 'Vaidika Grantha', icon: '🕉️' },
        { id: 'jyotisha_grantha', title: 'ಜ್ಯೋತಿಷ ಗ್ರಂಥ', titleEn: 'Jyotisha Grantha', icon: '🔮' },
      ],
    },
    gods: {
      id: 'gods', title: 'ಮಂತ್ರಗಳು', titleEn: 'Mantras', icon: '🙏',
      description: 'ದೇವರ ಮಂತ್ರಗಳು ಮತ್ತು ಜಪ',
      subcategories: [
        { id: 'shiva', title: 'ಶಿವ', titleEn: 'Lord Shiva', icon: 'images/shiva.png' },
        { id: 'vishnu', title: 'ವಿಷ್ಣು', titleEn: 'Lord Vishnu', icon: 'images/vishnu.png' },
        { id: 'devi', title: 'ದೇವಿ', titleEn: 'Devi', icon: 'images/devi.png' },
        { id: 'ganesha', title: 'ಗಣೇಶ', titleEn: 'Lord Ganesha', icon: 'images/ganesha.png' },
        { id: 'hanuman', title: 'ಹನುಮಂತ', titleEn: 'Lord Hanuman', icon: 'images/hanuman.png' },
        { id: 'surya', title: 'ಸೂರ್ಯ', titleEn: 'Lord Surya', icon: 'images/surya.png' },
        { id: 'krishna', title: 'ಕೃಷ್ಣ', titleEn: 'Lord Krishna', icon: 'images/krishna.png' },
        { id: 'rama', title: 'ರಾಮ', titleEn: 'Lord Rama', icon: 'images/rama.png' },
      ],
    },
    stotras: {
      id: 'stotras', title: 'ಸ್ತೋತ್ರಗಳು', titleEn: 'Stotras', icon: '📿',
      description: 'ದೇವರ ಪವಿತ್ರ ಸ್ತೋತ್ರಗಳು',
      subcategories: [
        { id: 'shiva', title: 'ಶಿವ', titleEn: 'Lord Shiva', icon: 'images/shiva.png' },
        { id: 'vishnu', title: 'ವಿಷ್ಣು', titleEn: 'Lord Vishnu', icon: 'images/vishnu.png' },
        { id: 'devi', title: 'ದೇವಿ', titleEn: 'Devi', icon: 'images/devi.png' },
        { id: 'ganesha', title: 'ಗಣೇಶ', titleEn: 'Lord Ganesha', icon: 'images/ganesha.png' },
        { id: 'hanuman', title: 'ಹನುಮಂತ', titleEn: 'Lord Hanuman', icon: 'images/hanuman.png' },
        { id: 'surya', title: 'ಸೂರ್ಯ', titleEn: 'Lord Surya', icon: 'images/surya.png' },
        { id: 'krishna', title: 'ಕೃಷ್ಣ', titleEn: 'Lord Krishna', icon: 'images/krishna.png' },
        { id: 'rama', title: 'ರಾಮ', titleEn: 'Lord Rama', icon: 'images/rama.png' },
      ],
    },
  },
  books: [
    {
      id: 'bhagavad_gita', title: 'ಶ್ರೀಮದ್ ಭಗವದ್ಗೀತೆ', titleSanskrit: 'श्रीमद् भगवद्गीता', titleEn: 'Shrimad Bhagavad Gita',
      category: 'library', subcategory: 'vaidika_grantha', godRelated: ['krishna','vishnu'],
      description: 'ಕುರುಕ್ಷೇತ್ರ ಯುದ್ಧಭೂಮಿಯಲ್ಲಿ ಶ್ರೀ ಕೃಷ್ಣನು ಅರ್ಜುನನಿಗೆ ಬೋಧಿಸಿದ ಪವಿತ್ರ ಉಪದೇಶ',
      isPremium: false, order: 1,
      chapters: [
        { id: 'bg_ch1', number: 1, title: 'ಅರ್ಜುನ ವಿಷಾದ ಯೋಗ', titleSanskrit: 'अर्जुन विषाद योग', titleEn: 'Arjuna Vishada Yoga',
          shlokas: [
            { id:'bg_1_1', number:'1.1', sanskrit:'धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः ।\nमामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ॥', kannada:'ಧರ್ಮಕ್ಷೇತ್ರೇ ಕುರುಕ್ಷೇತ್ರೇ ಸಮವೇತಾ ಯುಯುತ್ಸವಃ ।\nಮಾಮಕಾಃ ಪಾಂಡವಾಶ್ಚೈವ ಕಿಮಕುರ್ವತ ಸಂಜಯ ॥', meaning:'ಧೃತರಾಷ್ಟ್ರನು ಹೇಳಿದನು — ಹೇ ಸಂಜಯನೇ, ಧರ್ಮಭೂಮಿಯಾದ ಕುರುಕ್ಷೇತ್ರದಲ್ಲಿ ಯುದ್ಧ ಮಾಡಲು ಒಟ್ಟುಗೂಡಿದ ನನ್ನ ಮಕ್ಕಳು ಮತ್ತು ಪಾಂಡುವಿನ ಮಕ್ಕಳು ಏನು ಮಾಡಿದರು?', explanation:'ಈ ಶ್ಲೋಕವು ಭಗವದ್ಗೀತೆಯ ಮೊದಲ ಶ್ಲೋಕವಾಗಿದೆ.' },
            { id:'bg_1_2', number:'1.2', sanskrit:'सञ्जय उवाच ।\nदृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।\nआचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ॥', kannada:'ಸಂಜಯ ಉವಾಚ ।\nದೃಷ್ಟ್ವಾ ತು ಪಾಂಡವಾನೀಕಂ ವ್ಯೂಢಂ ದುರ್ಯೋಧನಸ್ತದಾ ।\nಆಚಾರ್ಯಮುಪಸಂಗಮ್ಯ ರಾಜಾ ವಚನಮಬ್ರವೀತ್ ॥', meaning:'ಸಂಜಯನು ಹೇಳಿದನು — ಪಾಂಡವರ ಸೈನ್ಯವು ವ್ಯೂಹ ರಚನೆಯಲ್ಲಿ ನಿಂತಿರುವುದನ್ನು ನೋಡಿ, ರಾಜ ದುರ್ಯೋಧನನು ತನ್ನ ಗುರು ದ್ರೋಣಾಚಾರ್ಯರ ಬಳಿ ಹೋಗಿ ಈ ಮಾತನ್ನು ಹೇಳಿದನು.', explanation:'ದುರ್ಯೋಧನನು ಪಾಂಡವರ ಬಲಿಷ್ಠ ಸೈನ್ಯವನ್ನು ನೋಡಿ ಆತಂಕಗೊಂಡು ತನ್ನ ಗುರುವಿನ ಬಳಿ ಹೋಗುತ್ತಾನೆ.' },
            { id:'bg_1_3', number:'1.3', sanskrit:'पश्यैतां पाण्डुपुत्राणामाचार्य महतीं चमूम् ।\nव्यूढां द्रुपदपुत्रेण तव शिष्येण धीमता ॥', kannada:'ಪಶ್ಯೈತಾಂ ಪಾಂಡುಪುತ್ರಾಣಾಮಾಚಾರ್ಯ ಮಹತೀಂ ಚಮೂಮ್ ।\nವ್ಯೂಢಾಂ ದ್ರುಪದಪುತ್ರೇಣ ತವ ಶಿಷ್ಯೇಣ ಧೀಮತಾ ॥', meaning:'ಹೇ ಆಚಾರ್ಯರೇ, ಪಾಂಡವರ ಈ ಮಹಾ ಸೈನ್ಯವನ್ನು ನೋಡಿರಿ.', explanation:'ದುರ್ಯೋಧನನು ದ್ರೋಣಾಚಾರ್ಯರನ್ನು ಪ್ರಚೋದಿಸಲು ಪ್ರಯತ್ನಿಸುತ್ತಿದ್ದಾನೆ.' },
          ]
        },
        { id: 'bg_ch2', number: 2, title: 'ಸಾಂಖ್ಯ ಯೋಗ', titleSanskrit: 'सांख्य योग', titleEn: 'Sankhya Yoga',
          shlokas: [
            { id:'bg_2_47', number:'2.47', sanskrit:'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन ।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि ॥', kannada:'ಕರ್ಮಣ್ಯೇವಾಧಿಕಾರಸ್ತೇ ಮಾ ಫಲೇಷು ಕದಾಚನ ।\nಮಾ ಕರ್ಮಫಲಹೇತುರ್ಭೂರ್ಮಾ ತೇ ಸಂಗೋಽಸ್ತ್ವಕರ್ಮಣಿ ॥', meaning:'ನಿನಗೆ ಕರ್ಮ ಮಾಡುವ ಅಧಿಕಾರ ಮಾತ್ರ ಇದೆ, ಕರ್ಮಫಲದ ಮೇಲೆ ಎಂದಿಗೂ ಅಧಿಕಾರವಿಲ್ಲ.', explanation:'ಇದು ಭಗವದ್ಗೀತೆಯ ಅತ್ಯಂತ ಪ್ರಸಿದ್ಧ ಶ್ಲೋಕ.' },
            { id:'bg_2_48', number:'2.48', sanskrit:'योगस्थः कुरु कर्माणि सङ्गं त्यक्त्वा धनञ्जय ।\nसिद्ध्यसिद्ध्योः समो भूत्वा समत्वं योग उच्यते ॥', kannada:'ಯೋಗಸ್ಥಃ ಕುರು ಕರ್ಮಾಣಿ ಸಂಗಂ ತ್ಯಕ್ತ್ವಾ ಧನಂಜಯ ।\nಸಿದ್ಧ್ಯಸಿದ್ಧ್ಯೋಃ ಸಮೋ ಭೂತ್ವಾ ಸಮತ್ವಂ ಯೋಗ ಉಚ್ಯತೇ ॥', meaning:'ಹೇ ಧನಂಜಯ, ಯೋಗದಲ್ಲಿ ಸ್ಥಿರವಾಗಿ ನಿಂತು ಕರ್ಮಗಳನ್ನು ಮಾಡು. ಸಮಭಾವವೇ ಯೋಗ.', explanation:'ಸಮತ್ವ ಭಾವನೆ — ಗೆಲುವು ಮತ್ತು ಸೋಲು ಎರಡರಲ್ಲೂ ಸಮಾನ ಮನಸ್ಸಿನಿಂದ ಇರುವುದೇ ನಿಜವಾದ ಯೋಗ.' },
            { id:'bg_2_62', number:'2.62', sanskrit:'ध्यायतो विषयान्पुंसः सङ्गस्तेषूपजायते ।\nसङ्गात्सञ्जायते कामः कामात्क्रोधोऽभिजायते ॥', kannada:'ಧ್ಯಾಯತೋ ವಿಷಯಾನ್ಪುಂಸಃ ಸಂಗಸ್ತೇಷೂಪಜಾಯತೇ ।\nಸಂಗಾತ್ಸಂಜಾಯತೇ ಕಾಮಃ ಕಾಮಾತ್ಕ್ರೋಧೋಽಭಿಜಾಯತೇ ॥', meaning:'ವಿಷಯಗಳ ಬಗ್ಗೆ ಚಿಂತಿಸುವ ಮನುಷ್ಯನಿಗೆ ಅವುಗಳಲ್ಲಿ ಆಸಕ್ತಿ ಹುಟ್ಟುತ್ತದೆ.', explanation:'ಮನಸ್ಸಿನ ಪತನದ ಹಂತಗಳು: ಚಿಂತನೆ → ಆಸಕ್ತಿ → ಕಾಮ → ಕ್ರೋಧ.' },
          ]
        },
        { id: 'bg_ch12', number: 12, title: 'ಭಕ್ತಿ ಯೋಗ', titleSanskrit: 'भक्ति योग', titleEn: 'Bhakti Yoga',
          shlokas: [
            { id:'bg_12_13', number:'12.13', sanskrit:'अद्वेष्टा सर्वभूतानां मैत्रः करुण एव च ।\nनिर्ममो निरहङ्कारः समदुःखसुखः क्षमी ॥', kannada:'ಅದ್ವೇಷ್ಟಾ ಸರ್ವಭೂತಾನಾಂ ಮೈತ್ರಃ ಕರುಣ ಏವ ಚ ।\nನಿರ್ಮಮೋ ನಿರಹಂಕಾರಃ ಸಮದುಃಖಸುಖಃ ಕ್ಷಮೀ ॥', meaning:'ಎಲ್ಲ ಪ್ರಾಣಿಗಳ ಮೇಲೆ ದ್ವೇಷವಿಲ್ಲದ ಭಕ್ತನು ನನಗೆ ಪ್ರಿಯನಾಗಿದ್ದಾನೆ.', explanation:'ಕೃಷ್ಣನು ತನ್ನ ಪ್ರಿಯ ಭಕ್ತನ ಲಕ್ಷಣಗಳನ್ನು ವಿವರಿಸುತ್ತಿದ್ದಾನೆ.' },
          ]
        },
      ]
    },
    {
      id: 'gayatri_mantra', title: 'ಗಾಯತ್ರೀ ಮಂತ್ರ', titleSanskrit: 'गायत्री मन्त्र', titleEn: 'Gayatri Mantra',
      category: 'stotras', subcategory: 'surya', godRelated: ['surya'],
      description: 'ವೇದಗಳ ಮಾತೆ ಎಂದು ಕರೆಯಲ್ಪಡುವ ಅತ್ಯಂತ ಪವಿತ್ರ ಮಂತ್ರ', isPremium: false, order: 2,
      chapters: [{ id:'gayatri_ch1', number:1, title:'ಗಾಯತ್ರೀ ಮಂತ್ರ', titleSanskrit:'गायत्री मन्त्र', titleEn:'Gayatri Mantra',
        shlokas: [{ id:'gayatri_1', number:'1', sanskrit:'ॐ भूर्भुवः स्वः\nतत्सवितुर्वरेण्यं\nभर्गो देवस्य धीमहि\nधियो यो नः प्रचोदयात् ॥', kannada:'ಓಂ ಭೂರ್ಭುವಃ ಸ್ವಃ\nತತ್ಸವಿತುರ್ವರೇಣ್ಯಂ\nಭರ್ಗೋ ದೇವಸ್ಯ ಧೀಮಹಿ\nಧಿಯೋ ಯೋ ನಃ ಪ್ರಚೋದಯಾತ್ ॥', meaning:'ಸವಿತೃ ದೇವನ ಶ್ರೇಷ್ಠವಾದ ತೇಜಸ್ಸನ್ನು ನಾವು ಧ್ಯಾನಿಸುತ್ತೇವೆ.', explanation:'ಗಾಯತ್ರೀ ಮಂತ್ರವು ಋಗ್ವೇದದ ಅತ್ಯಂತ ಪವಿತ್ರ ಮಂತ್ರ.' }]
      }]
    },
    {
      id: 'shiva_tandava', title: 'ಶಿವ ತಾಂಡವ ಸ್ತೋತ್ರಮ್', titleSanskrit: 'शिव ताण्डव स्तोत्रम्', titleEn: 'Shiva Tandava Stotram',
      category: 'stotras', subcategory: 'shiva', godRelated: ['shiva'],
      description: 'ರಾವಣನಿಂದ ರಚಿತವಾದ ಶಿವನ ತಾಂಡವ ನೃತ್ಯದ ಮಹಾ ಸ್ತೋತ್ರ', isPremium: false, order: 3,
      chapters: [{ id:'st_ch1', number:1, title:'ಶಿವ ತಾಂಡವ ಸ್ತೋತ್ರಮ್', titleSanskrit:'शिव ताण्डव स्तोत्रम्', titleEn:'Shiva Tandava Stotram',
        shlokas: [
          { id:'st_1', number:'1', sanskrit:'जटाटवीगलज्जलप्रवाहपावितस्थले\nगलेऽवलम्ब्य लम्बितां भुजङ्गतुङ्गमालिकाम् ।\nडमड्डमड्डमड्डमन्निनादवड्डमर्वयं\nचकार चण्डताण्डवं तनोतु नः शिवः शिवम् ॥', kannada:'ಜಟಾಟವೀಗಲಜ್ಜಲಪ್ರವಾಹಪಾವಿತಸ್ಥಲೇ\nಗಲೇಽವಲಂಬ್ಯ ಲಂಬಿತಾಂ ಭುಜಂಗತುಂಗಮಾಲಿಕಾಮ್ ।\nಡಮಡ್ಡಮಡ್ಡಮಡ್ಡಮನ್ನಿನಾದವಡ್ಡಮರ್ವಯಂ\nಚಕಾರ ಚಂಡತಾಂಡವಂ ತನೋತು ನಃ ಶಿವಃ ಶಿವಮ್ ॥', meaning:'ಡಮರುಗದ ನಾದದೊಂದಿಗೆ ಪ್ರಚಂಡ ತಾಂಡವ ನೃತ್ಯ ಮಾಡುವ ಶಿವನು ನಮಗೆ ಮಂಗಳವನ್ನುಂಟು ಮಾಡಲಿ.', explanation:'ಶಿವ ತಾಂಡವ ಸ್ತೋತ್ರವನ್ನು ಲಂಕಾಧಿಪತಿ ರಾವಣನು ರಚಿಸಿದನೆಂದು ಹೇಳಲಾಗುತ್ತದೆ.' },
          { id:'st_2', number:'2', sanskrit:'जटाकटाहसम्भ्रमभ्रमन्निलिम्पनिर्झरी-\nविलोलवीचिवल्लरीविराजमानमूर्धनि ।\nधगद्धगद्धगज्ज्वलल्ललाटपट्टपावके\nकिशोरचन्द्रशेखरे रतिः प्रतिक्षणं मम ॥', kannada:'ಜಟಾಕಟಾಹಸಂಭ್ರಮಭ್ರಮನ್ನಿಲಿಂಪನಿರ್ಝರೀ-\nವಿಲೋಲವೀಚಿವಲ್ಲರೀವಿರಾಜಮಾನಮೂರ್ಧನಿ ।\nಧಗದ್ಧಗದ್ಧಗಜ್ಜ್ವಲಲ್ಲಲಾಟಪಟ್ಟಪಾವಕೇ\nಕಿಶೋರಚಂದ್ರಶೇಖರೇ ರತಿಃ ಪ್ರತಿಕ್ಷಣಂ ಮಮ ॥', meaning:'ಬಾಲಚಂದ್ರನನ್ನು ಶಿರಸ್ಸಿನಲ್ಲಿ ಧರಿಸಿರುವ ಶಿವನಲ್ಲಿ ಪ್ರತಿ ಕ್ಷಣವೂ ನನ್ನ ಪ್ರೀತಿ ಇರಲಿ.', explanation:'ಶಿವನ ಶಿರಸ್ಸಿನ ಸೌಂದರ್ಯ — ಗಂಗೆ, ಅಗ್ನಿ ಮತ್ತು ಚಂದ್ರ ಒಟ್ಟಿಗೆ ಶೋಭಿಸುವ ಅದ್ಭುತ ದೃಶ್ಯ.' },
        ]
      }]
    },
    {
      id: 'vishnu_sahasranama', title: 'ವಿಷ್ಣು ಸಹಸ್ರನಾಮ', titleSanskrit: 'विष्णु सहस्रनाम', titleEn: 'Vishnu Sahasranama',
      category: 'stotras', subcategory: 'vishnu', godRelated: ['vishnu'],
      description: 'ಮಹಾಭಾರತದ ಅನುಶಾಸನ ಪರ್ವದಲ್ಲಿ ಬರುವ ವಿಷ್ಣುವಿನ ಸಾವಿರ ನಾಮಗಳ ಸ್ತೋತ್ರ', isPremium: false, order: 4,
      chapters: [{ id:'vs_ch1', number:1, title:'ಪೂರ್ವ ಪೀಠಿಕಾ', titleSanskrit:'पूर्व पीठिका', titleEn:'Introduction',
        shlokas: [
          { id:'vs_1', number:'1', sanskrit:'शुक्लाम्बरधरं विष्णुं शशिवर्णं चतुर्भुजम् ।\nप्रसन्नवदनं ध्यायेत् सर्वविघ्नोपशान्तये ॥', kannada:'ಶುಕ್ಲಾಂಬರಧರಂ ವಿಷ್ಣುಂ ಶಶಿವರ್ಣಂ ಚತುರ್ಭುಜಮ್ ।\nಪ್ರಸನ್ನವದನಂ ಧ್ಯಾಯೇತ್ ಸರ್ವವಿಘ್ನೋಪಶಾಂತಯೇ ॥', meaning:'ಬಿಳಿ ಬಟ್ಟೆ ಧರಿಸಿರುವ ವಿಷ್ಣುವನ್ನು ಧ್ಯಾನಿಸಬೇಕು.', explanation:'ಇದು ವಿಷ್ಣು ಸಹಸ್ರನಾಮದ ಧ್ಯಾನ ಶ್ಲೋಕ.' },
          { id:'vs_2', number:'2', sanskrit:'यस्य स्मरणमात्रेण जन्मसंसारबन्धनात् ।\nविमुच्यते नमस्तस्मै विष्णवे प्रभविष्णवे ॥', kannada:'ಯಸ್ಯ ಸ್ಮರಣಮಾತ್ರೇಣ ಜನ್ಮಸಂಸಾರಬಂಧನಾತ್ ।\nವಿಮುಚ್ಯತೇ ನಮಸ್ತಸ್ಮೈ ವಿಷ್ಣವೇ ಪ್ರಭವಿಷ್ಣವೇ ॥', meaning:'ಯಾರ ಸ್ಮರಣೆ ಮಾತ್ರದಿಂದಲೇ ಸಂಸಾರ ಬಂಧನದಿಂದ ಮುಕ್ತಿ.', explanation:'ವಿಷ್ಣುವಿನ ನಾಮಸ್ಮರಣೆಯ ಮಹಿಮೆ.' },
        ]
      }]
    },
    {
      id: 'hanuman_chalisa', title: 'ಹನುಮಾನ್ ಚಾಲೀಸಾ', titleSanskrit: 'हनुमान चालीसा', titleEn: 'Hanuman Chalisa',
      category: 'stotras', subcategory: 'hanuman', godRelated: ['hanuman','rama'],
      description: 'ತುಲಸೀದಾಸರು ರಚಿಸಿದ ಹನುಮಂತನ ಸ್ತುತಿಗೀತೆ', isPremium: false, order: 5,
      chapters: [{ id:'hc_ch1', number:1, title:'ಹನುಮಾನ್ ಚಾಲೀಸಾ', titleSanskrit:'हनुमान चालीसा', titleEn:'Hanuman Chalisa',
        shlokas: [
          { id:'hc_1', number:'ದೋಹಾ 1', sanskrit:'श्रीगुरु चरन सरोज रज निज मनु मुकुरु सुधारि ।\nबरनउँ रघुबर बिमल जसु जो दायकु फल चारि ॥', kannada:'ಶ್ರೀಗುರು ಚರಣ ಸರೋಜ ರಜ ನಿಜ ಮನು ಮುಕುರು ಸುಧಾರಿ ।\nಬರನಉँ ರಘುಬರ ಬಿಮಲ ಜಸು ಜೋ ದಾಯಕು ಫಲ ಚಾರಿ ॥', meaning:'ಗುರುವಿನ ಚರಣ ಕಮಲದ ಧೂಳಿನಿಂದ ಮನಸ್ಸೆಂಬ ಕನ್ನಡಿಯನ್ನು ಶುಚಿಗೊಳಿಸಿ, ಶ್ರೀ ರಘುನಾಥನ ಯಶಸ್ಸನ್ನು ವರ್ಣಿಸುತ್ತೇನೆ.', explanation:'ಮೊದಲ ದೋಹಾದಲ್ಲಿ ಗುರುವಿಗೆ ವಂದಿಸಿ ಅನುಮತಿ ಕೋರುತ್ತಾರೆ.' },
          { id:'hc_2', number:'ದೋಹಾ 2', sanskrit:'बुद्धिहीन तनु जानिके सुमिरौं पवन कुमार ।\nबल बुद्धि बिद्या देहु मोहिं हरहु कलेस बिकार ॥', kannada:'ಬುದ್ಧಿಹೀನ ತನು ಜಾನಿಕೇ ಸುಮಿರೌಂ ಪವನ ಕುಮಾರ ।\nಬಲ ಬುದ್ಧಿ ಬಿದ್ಯಾ ದೇಹು ಮೋಹಿಂ ಹರಹು ಕಲೇಸ ಬಿಕಾರ ॥', meaning:'ಹೇ ಪವನ ಕುಮಾರ, ನನಗೆ ಬಲ, ಬುದ್ಧಿ, ವಿದ್ಯೆಯನ್ನು ನೀಡು.', explanation:'ತುಲಸೀದಾಸರು ಹನುಮಂತನಲ್ಲಿ ಬಲ, ಬುದ್ಧಿ ಮತ್ತು ವಿದ್ಯೆಯನ್ನು ಬೇಡುತ್ತಾರೆ.' },
          { id:'hc_3', number:'ಚೌಪಾಈ 1', sanskrit:'जय हनुमान ज्ञान गुन सागर ।\nजय कपीस तिहुँ लोक उजागर ॥', kannada:'ಜಯ ಹನುಮಾನ ಜ್ಞಾನ ಗುಣ ಸಾಗರ ।\nಜಯ ಕಪೀಶ ತಿಹुँ ಲೋಕ ಉಜಾಗರ ॥', meaning:'ಜ್ಞಾನ ಮತ್ತು ಗುಣಗಳ ಸಾಗರನಾದ ಹನುಮಂತನಿಗೆ ಜಯವಾಗಲಿ.', explanation:'ಹನುಮಂತನನ್ನು ಜ್ಞಾನಸಾಗರ ಮತ್ತು ತ್ರಿಲೋಕ ಪ್ರಕಾಶಕ ಎಂದು ವರ್ಣಿಸಲಾಗಿದೆ.' },
        ]
      }]
    },
    {
      id: 'ishavasya', title: 'ಈಶಾವಾಸ್ಯ ಉಪನಿಷತ್', titleSanskrit: 'ईशावास्य उपनिषद्', titleEn: 'Ishavasya Upanishad',
      category: 'library', subcategory: 'vaidika_grantha', godRelated: [],
      description: 'ಯಜುರ್ವೇದದ ಅತ್ಯಂತ ಪ್ರಮುಖ ಮತ್ತು ಸಂಕ್ಷಿಪ್ತ ಉಪನಿಷತ್ತು', isPremium: false, order: 6,
      chapters: [{ id:'isha_ch1', number:1, title:'ಈಶಾವಾಸ್ಯ ಉಪನಿಷತ್', titleSanskrit:'ईशावास्य उपनिषद्', titleEn:'Ishavasya Upanishad',
        shlokas: [
          { id:'isha_1', number:'1', sanskrit:'ॐ ईशावास्यमिदं सर्वं यत्किञ्च जगत्यां जगत् ।\nतेन त्यक्तेन भुञ्जीथा मा गृधः कस्यस्विद्धनम् ॥', kannada:'ಓಂ ಈಶಾವಾಸ್ಯಮಿದಂ ಸರ್ವಂ ಯತ್ಕಿಂಚ ಜಗತ್ಯಾಂ ಜಗತ್ ।\nತೇನ ತ್ಯಕ್ತೇನ ಭುಂಜೀಥಾ ಮಾ ಗೃಧಃ ಕಸ್ಯಸ್ವಿದ್ಧನಮ್ ॥', meaning:'ಈ ಜಗತ್ತಿನಲ್ಲಿ ಅದೆಲ್ಲವೂ ಈಶ್ವರನಿಂದ ಆವೃತ. ತ್ಯಾಗದಿಂದ ಅನುಭವಿಸು.', explanation:'ಎಲ್ಲವೂ ದೈವಮಯ ಎಂಬ ಸಂದೇಶ.' },
          { id:'isha_2', number:'2', sanskrit:'कुर्वन्नेवेह कर्माणि जिजीविषेच्छतँ समाः ।\nएवं त्वयि नान्यथेतोऽस्ति न कर्म लिप्यते नरे ॥', kannada:'ಕುರ್ವನ್ನೇವೇಹ ಕರ್ಮಾಣಿ ಜಿಜೀವಿಷೇಚ್ಛತಂ ಸಮಾಃ ।\nಏವಂ ತ್ವಯಿ ನಾನ್ಯಥೇತೋಽಸ್ತಿ ನ ಕರ್ಮ ಲಿಪ್ಯತೇ ನರೇ ॥', meaning:'ಕರ್ಮಗಳನ್ನು ಮಾಡುತ್ತಲೇ ನೂರು ವರ್ಷ ಬಾಳಬೇಕು.', explanation:'ಅನಾಸಕ್ತ ಕರ್ಮವೇ ಮೋಕ್ಷದ ಮಾರ್ಗ.' },
        ]
      }]
    },
    {
      id: 'shiva_panchakshari', title: 'ಶಿವ ಪಂಚಾಕ್ಷರಿ ಸ್ತೋತ್ರಮ್', titleSanskrit: 'शिव पञ्चाक्षर स्तोत्रम्', titleEn: 'Shiva Panchakshari Stotram',
      category: 'stotras', subcategory: 'shiva', godRelated: ['shiva'],
      description: 'ಆದಿ ಶಂಕರಾಚಾರ್ಯ ವಿರಚಿತ ಪಂಚಾಕ್ಷರಿ ಸ್ತೋತ್ರ', isPremium: false, order: 7,
      chapters: [{ id:'sp_ch1', number:1, title:'ಶಿವ ಪಂಚಾಕ್ಷರಿ ಸ್ತೋತ್ರಮ್', titleSanskrit:'शिव पञ्चाक्षर स्तोत्रम्', titleEn:'Shiva Panchakshari Stotram',
        shlokas: [
          { id:'sp_1', number:'1 (ನ)', sanskrit:'नागेन्द्रहाराय त्रिलोचनाय\nभस्माङ्गरागाय महेश्वराय ।\nनित्याय शुद्धाय दिगम्बराय\nतस्मै नकाराय नमः शिवाय ॥', kannada:'ನಾಗೇಂದ್ರಹಾರಾಯ ತ್ರಿಲೋಚನಾಯ\nಭಸ್ಮಾಂಗರಾಗಾಯ ಮಹೇಶ್ವರಾಯ ।\nನಿತ್ಯಾಯ ಶುದ್ಧಾಯ ದಿಗಂಬರಾಯ\nತಸ್ಮೈ ನಕಾರಾಯ ನಮಃ ಶಿವಾಯ ॥', meaning:'ನಾಗೇಂದ್ರನನ್ನು ಕೊರಳಿನಲ್ಲಿ ಹಾರವಾಗಿ ಧರಿಸಿರುವ ಶಿವನಿಗೆ ನಮಸ್ಕಾರ.' },
          { id:'sp_2', number:'2 (ಮ)', sanskrit:'मन्दाकिनीसलिलचन्दनचर्चिताय\nनन्दीश्वरप्रमथनाथमहेश्वराय ।\nमन्दारपुष्पबहुपुष्पसुपूजिताय\nतस्मै मकाराय नमः शिवाय ॥', kannada:'ಮಂದಾಕಿನೀಸಲಿಲಚಂದನಚರ್ಚಿತಾಯ\nನಂದೀಶ್ವರಪ್ರಮಥನಾಥಮಹೇಶ್ವರಾಯ ।\nಮಂದಾರಪುಷ್ಪಬಹುಪುಷ್ಪಸುಪೂಜಿತಾಯ\nತಸ್ಮೈ ಮಕಾರಾಯ ನಮಃ ಶಿವಾಯ ॥', meaning:'ಮಂದಾಕಿನಿ ಜಲ ಮತ್ತು ಚಂದನದಿಂದ ಅರ್ಚಿಸಲ್ಪಟ್ಟ ಶಿವನಿಗೆ ನಮಸ್ಕಾರ.' },
          { id:'sp_3', number:'3 (ಶಿ)', sanskrit:'शिवाय गौरीवदनाब्जबाल-\nसूर्याय दक्षाध्वरनाशकाय ।\nश्रीनीलकण्ठाय वृषध्वजाय\nतस्मै शिकाराय नमः शिवाय ॥', kannada:'ಶಿವಾಯ ಗೌರಿವದನಾಬ್ಜಬಾಲ-\nಸೂರ್ಯಾಯ ದಕ್ಷಾಧ್ವರನಾಶಕಾಯ ।\nಶ್ರೀನೀಲಕಂಠಾಯ ವೃಷಧ್ವಜಾಯ\nತಸ್ಮೈ ಶಿಕಾರಾಯ ನಮಃ ಶಿವಾಯ ॥', meaning:'ಮಂಗಳಸ್ವರೂಪ ಶ್ರೀ ನೀಲಕಂಠನಾದ ಶಿವನಿಗೆ ನಮಸ್ಕಾರ.' },
          { id:'sp_4', number:'4 (ವ)', sanskrit:'वसिष्ठकुम्भोद्भवगौतमार्य-\nमुनीन्द्रदेवार्चितशेखराय ।\nचन्द्रार्कवैश्वानरलोचनाय\nतस्मै वकाराय नमः शिवाय ॥', kannada:'ವಸಿಷ್ಠಕುಂಭೋದ್ಭವಗೌತಮಾರ್ಯ-\nಮುನೀಂದ್ರದೇವಾರ್ಚಿತಶೇಖರಾಯ ।\nಚಂದ್ರಾರ್ಕವೈಶ್ವಾನರಲೋಚನಾಯ\nತಸ್ಮೈ ವಕಾರಾಯ ನಮಃ ಶಿವಾಯ ॥', meaning:'ಮಹಾ ಮುನಿಗಳಿಂದ ಪೂಜಿಸಲ್ಪಟ್ಟ ಶಿವನಿಗೆ ನಮಸ್ಕಾರ.' },
          { id:'sp_5', number:'5 (ಯ)', sanskrit:'यक्षस्वरूपाय जटाधराय\nपिनाकहस्ताय सनातनाय ।\nदिव्याय देवाय दिगम्बराय\nतस्मै यकाराय नमः शिवाय ॥', kannada:'ಯಕ್ಷಸ್ವರೂಪಾಯ ಜಟಾಧರಾಯ\nಪಿನಾಕಹಸ್ತಾಯ ಸನಾತನಾಯ ।\nದಿವ್ಯಾಯ ದೇವಾಯ ದಿಗಂಬರಾಯ\nತಸ್ಮೈ ಯಕಾರಾಯ ನಮಃ ಶಿವಾಯ ॥', meaning:'ಸನಾತನನಾದ ದಿವ್ಯ ಶಿವನಿಗೆ ನಮಸ್ಕಾರ.' },
          { id:'sp_6', number:'ಫಲಶ್ರುತಿ', sanskrit:'पञ्चाक्षरमिदं पुण्यं यः पठेच्छिवसंनिधौ ।\nशिवलोकमवाप्नोति शिवेन सह मोदते ॥', kannada:'ಪಂಚಾಕ್ಷರಮಿದಂ ಪುಣ್ಯಂ ಯಃ ಪಠೇಚ್ಛಿವಸನ್ನಿಧೌ ।\nಶಿವಲೋಕಮವಾಪ್ನೋತಿ ಶಿವೇನ ಸಹ ಮೋದತೇ ॥', meaning:'ಶಿವನ ಸನ್ನಿಧಿಯಲ್ಲಿ ಪಂಚಾಕ್ಷರಿ ಪಠಿಸಿದವರು ಶಿವಲೋಕವನ್ನು ಹೊಂದುತ್ತಾರೆ.' },
        ]
      }]
    },
    {
      id: 'lingashtakam', title: 'ಲಿಂಗಾಷ್ಟಕಮ್', titleSanskrit: 'लिङ्गाष्टकम्', titleEn: 'Lingashtakam',
      category: 'stotras', subcategory: 'shiva', godRelated: ['shiva'],
      description: 'ಶಿವಲಿಂಗದ ಮಹಿಮೆಯನ್ನು ಸ್ತುತಿಸುವ ಅಷ್ಟಕ', isPremium: false, order: 8,
      chapters: [{ id:'la_ch1', number:1, title:'ಲಿಂಗಾಷ್ಟಕಮ್', titleSanskrit:'लिङ्गाष्टकम्', titleEn:'Lingashtakam',
        shlokas: [
          { id:'la_1', number:'1', sanskrit:'ब्रह्ममुरारिसुरार्चितलिङ्गं निर्मलभासितशोभितलिङ्गम् ।\nजन्मजदुःखविनाशकलिङ्गं तत्प्रणमामि सदाशिवलिङ्गम् ॥', kannada:'ಬ್ರಹ್ಮಮುರಾರಿಸುರಾರ್ಚಿತಲಿಂಗಂ ನಿರ್ಮಲಭಾಸಿತಶೋಭಿತಲಿಂಗಮ್ ।\nಜನ್ಮಜದುಃಖವಿನಾಶಕಲಿಂಗಂ ತತ್ಪ್ರಣಮಾಮಿ ಸದಾಶಿವಲಿಂಗಮ್ ॥', meaning:'ಬ್ರಹ್ಮ ವಿಷ್ಣು ಮತ್ತು ದೇವತೆಗಳಿಂದ ಪೂಜಿಸಲ್ಪಟ್ಟ ಸದಾಶಿವಲಿಂಗಕ್ಕೆ ಪ್ರಣಾಮ.' },
          { id:'la_2', number:'2', sanskrit:'देवमुनिप्रवरार्चितलिङ्गं कामदहं करुणाकरलिङ्गम् ।\nरावणदर्पविनाशनलिङ्गं तत्प्रणमामि सदाशिवलिङ्गम् ॥', kannada:'ದೇವಮುನಿಪ್ರವರಾರ್ಚಿತಲಿಂಗಂ ಕಾಮದಹಂ ಕರುಣಾಕರಲಿಂಗಮ್ ।\nರಾವಣದರ್ಪವಿನಾಶನಲಿಂಗಂ ತತ್ಪ್ರಣಮಾಮಿ ಸದಾಶಿವಲಿಂಗಮ್ ॥', meaning:'ಕಾಮದೇವನನ್ನು ದಹಿಸಿದ ಕರುಣಾಮಯ ಸದಾಶಿವಲಿಂಗಕ್ಕೆ ಪ್ರಣಾಮ.' },
          { id:'la_3', number:'3', sanskrit:'सर्वसुगन्धिसुलेपितलिङ्गं बुद्धिविवर्धनकारणलिङ्गम् ।\nसिद्धसुरासुरवन्दितलिङ्गं तत्प्रणमामि सदाशिवलिङ्गम् ॥', kannada:'ಸರ್ವಸುಗಂಧಿಸುಲೇಪಿತಲಿಂಗಂ ಬುದ್ಧಿವಿವರ್ಧನಕಾರಣಲಿಂಗಮ್ ।\nಸಿದ್ಧಸುರಾಸುರವಂದಿತಲಿಂಗಂ ತತ್ಪ್ರಣಮಾಮಿ ಸದಾಶಿವಲಿಂಗಮ್ ॥', meaning:'ಸುಗಂಧ ದ್ರವ್ಯಗಳಿಂದ ಲೇಪಿತ ಸದಾಶಿವಲಿಂಗಕ್ಕೆ ಪ್ರಣಾಮ.' },
          { id:'la_4', number:'4', sanskrit:'कनकमहामणिभूषितलिङ्गं फणिपतिवेष्टितशोभितलिङ्गम् ।\nदक्षसुयज्ञविनाशनलिङ्गं तत्प्रणमामि सदाशिवलिङ्गम् ॥', kannada:'ಕನಕಮಹಾಮಣಿಭೂಷಿತಲಿಂಗಂ ಫಣಿಪತಿವೇಷ್ಟಿತಶೋಭಿತಲಿಂಗಮ್ ।\nದಕ್ಷಸುಯಜ್ಞವಿನಾಶನಲಿಂಗಂ ತತ್ಪ್ರಣಮಾಮಿ ಸದಾಶಿವಲಿಂಗಮ್ ॥', meaning:'ಚಿನ್ನ ಮಣಿಗಳಿಂದ ಅಲಂಕೃತ ಸದಾಶಿವಲಿಂಗಕ್ಕೆ ಪ್ರಣಾಮ.' },
          { id:'la_5', number:'5', sanskrit:'कुङ्कुमचन्दनलेपितलिङ्गं पङ्कजहारसुशोभितलिङ्गम् ।\nसञ्चितपापविनाशनलिङ्गं तत्प्रणमामि सदाशिवलिङ्गम् ॥', kannada:'ಕುಂಕುಮಚಂದನಲೇಪಿತಲಿಂಗಂ ಪಂಕಜಹಾರಸುಶೋಭಿತಲಿಂಗಮ್ ।\nಸಂಚಿತಪಾಪವಿನಾಶನಲಿಂಗಂ ತತ್ಪ್ರಣಮಾಮಿ ಸದಾಶಿವಲಿಂಗಮ್ ॥', meaning:'ಕುಂಕುಮ ಚಂದನದಿಂದ ಲೇಪಿತ ಸದಾಶಿವಲಿಂಗಕ್ಕೆ ಪ್ರಣಾಮ.' },
          { id:'la_6', number:'6', sanskrit:'देवगणार्चितसेवितलिङ्गं भावैर्भक्तिभिरेव च लिङ्गम् ।\nदिनकरकोटिप्रभाकरलिङ्गं तत्प्रणमामि सदाशिवलिङ्गम् ॥', kannada:'ದೇವಗಣಾರ್ಚಿತಸೇವಿತಲಿಂಗಂ ಭಾವೈರ್ಭಕ್ತಿಭಿರೇವ ಚ ಲಿಂಗಮ್ ।\nದಿನಕರಕೋಟಿಪ್ರಭಾಕರಲಿಂಗಂ ತತ್ಪ್ರಣಮಾಮಿ ಸದಾಶಿವಲಿಂಗಮ್ ॥', meaning:'ಕೋಟಿ ಸೂರ್ಯರ ತೇಜಸ್ಸಿನ ಸದಾಶಿವಲಿಂಗಕ್ಕೆ ಪ್ರಣಾಮ.' },
          { id:'la_7', number:'7', sanskrit:'अष्टदलोपरिवेष्टितलिङ्गं सर्वसमुद्भवकारणलिङ्गम् ।\nअष्टदरिद्रविनाशनलिङ्गं तत्प्रणमामि सदाशिवलिङ्गम् ॥', kannada:'ಅಷ್ಟದಲೋಪರಿವೇಷ್ಟಿತಲಿಂಗಂ ಸರ್ವಸಮುದ್ಭವಕಾರಣಲಿಂಗಮ್ ।\nಅಷ್ಟದರಿದ್ರವಿನಾಶನಲಿಂಗಂ ತತ್ಪ್ರಣಮಾಮಿ ಸದಾಶಿವಲಿಂಗಮ್ ॥', meaning:'ಸೃಷ್ಟಿಯ ಕಾರಣವಾದ ಸದಾಶಿವಲಿಂಗಕ್ಕೆ ಪ್ರಣಾಮ.' },
          { id:'la_8', number:'8', sanskrit:'सुरगुरुसुरवरपूजितलिङ्गं सुरवनपुष्पसदारचितलिङ्गम् ।\nपरात्परं परमात्माकलिङ्गं तत्प्रणमामि सदाशिवलिङ्गम् ॥', kannada:'ಸುರಗುರುಸುರವರಪೂಜಿತಲಿಂಗಂ ಸುರವನಪುಷ್ಪಸದಾರಚಿತಲಿಂಗಮ್ ।\nಪರಾತ್ಪರಂ ಪರಮಾತ್ಮಕಲಿಂಗಂ ತತ್ಪ್ರಣಮಾಮಿ ಸದಾಶಿವಲಿಂಗಮ್ ॥', meaning:'ಪರಬ್ರಹ್ಮ ಸ್ವರೂಪ ಸದಾಶಿವಲಿಂಗಕ್ಕೆ ಪ್ರಣಾಮ.' },
          { id:'la_9', number:'ಫಲಶ್ರುತಿ', sanskrit:'लिङ्गाष्टकमिदं पुण्यं यः पठेच्छिवसंनिधौ ।\nशिवलोकमवाप्नोति शिवेन सह मोदते ॥', kannada:'ಲಿಂಗಾಷ್ಟಕಮಿದಂ ಪುಣ್ಯಂ ಯಃ ಪಠೇಚ್ಛಿವಸನ್ನಿಧೌ ।\nಶಿವಲೋಕಮವಾಪ್ನೋತಿ ಶಿವೇನ ಸಹ ಮೋದತೇ ॥', meaning:'ಲಿಂಗಾಷ್ಟಕ ಪಠಿಸಿದವರು ಶಿವಲೋಕ ಹೊಂದುತ್ತಾರೆ.' },
        ]
      }]
    },
    {
      id: 'bilvashtakam', title: 'ಬಿಲ್ವಾಷ್ಟಕಮ್', titleSanskrit: 'बिल्वाष्टकम्', titleEn: 'Bilvashtakam',
      category: 'stotras', subcategory: 'shiva', godRelated: ['shiva'],
      description: 'ಬಿಲ್ವಪತ್ರೆ ಅರ್ಪಣೆಯ ಮಹಿಮೆ ಸಾರುವ ಸ್ತೋತ್ರ', isPremium: false, order: 9,
      chapters: [{ id:'ba_ch1', number:1, title:'ಬಿಲ್ವಾಷ್ಟಕಮ್', titleSanskrit:'बिल्वाष्टकम्', titleEn:'Bilvashtakam',
        shlokas: [
          { id:'ba_1', number:'1', sanskrit:'त्रिदलं त्रिगुणाकारं त्रिनेत्रं च त्रियायुधम् ।\nत्रिजन्मपापसंहारं एकबिल्वं शिवार्पणम् ॥', kannada:'ತ್ರಿದಳಂ ತ್ರಿಗುಣಾಕಾರಂ ತ್ರಿನೇತ್ರಂ ಚ ತ್ರಿಯಾಯುಧಮ್ ।\nತ್ರಿಜನ್ಮಪಾಪಸಂಹಾರಂ ಏಕಬಿಲ್ವಂ ಶಿವಾರ್ಪಣಮ್ ॥', meaning:'ಮೂರು ಜನ್ಮಗಳ ಪಾಪ ನಾಶಕ ಬಿಲ್ವಪತ್ರೆ ಶಿವನಿಗೆ ಅರ್ಪಣ.' },
          { id:'ba_2', number:'2', sanskrit:'त्रिशाखैर्बिल्वपत्रैश्च ह्यच्छिद्रैः कोमलैः शुभैः ।\nतव पूजां करिष्यामि एकबिल्वं शिवार्पणम् ॥', kannada:'ತ್ರಿಶಾಖೈರ್ಬಿಲ್ವಪತ್ರೈಶ್ಚ ಹ್ಯಚ್ಛಿದ್ರೈಃ ಕೋಮಲೈಃ ಶುಭೈಃ ।\nತವ ಪೂಜಾಂ ಕರಿಷ್ಯಾಮಿ ಏಕಬಿಲ್ವಂ ಶಿವಾರ್ಪಣಮ್ ॥', meaning:'ಕೋಮಲ ಶುಭ ಬಿಲ್ವಪತ್ರೆಗಳಿಂದ ಪೂಜೆ. ಏಕಬಿಲ್ವಂ ಶಿವಾರ್ಪಣಮ್.' },
          { id:'ba_3', number:'3', sanskrit:'अखण्डबिल्वपत्रेण पूजिते नन्दिकेश्वरे ।\nशुद्ध्यन्ति सर्वपापेभ्यः एकबिल्वं शिवार्पणम् ॥', kannada:'ಅಖಂಡಬಿಲ್ವಪತ್ರೇಣ ಪೂಜಿತೇ ನಂದಿಕೇಶ್ವರೇ ।\nಶುದ್ಧ್ಯಂತಿ ಸರ್ವಪಾಪೇಭ್ಯಃ ಏಕಬಿಲ್ವಂ ಶಿವಾರ್ಪಣಮ್ ॥', meaning:'ಅಖಂಡ ಬಿಲ್ವಪತ್ರೆಯಿಂದ ಪೂಜಿಸಿದರೆ ಎಲ್ಲ ಪಾಪ ನಾಶ.' },
          { id:'ba_4', number:'4', sanskrit:'शालिग्रामशिलामेकां विप्राणां जातु चार्पयेत् ।\nसोमयज्ञमहापुण्यं एकबिल्वं शिवार्पणम् ॥', kannada:'ಶಾಲಿಗ್ರಾಮಶಿಲಾಮೇಕಾಂ ವಿಪ್ರಾಣಾಂ ಜಾತು ಚಾರ್ಪಯೇತ್ ।\nಸೋಮಯಜ್ಞಮಹಾಪುಣ್ಯಂ ಏಕಬಿಲ್ವಂ ಶಿವಾರ್ಪಣಮ್ ॥', meaning:'ಸೋಮಯಾಗದ ಮಹಾ ಪುಣ್ಯ ಬಿಲ್ವಾರ್ಪಣೆಯಿಂದ ಲಭಿಸುತ್ತದೆ.' },
          { id:'ba_5', number:'5', sanskrit:'दन्तिकोटिसहस्रेषु वाजपेयशतैस्तथा ।\nकोटिकन्यामहादानं एकबिल्वं शिवार्पणम् ॥', kannada:'ದಂತಿಕೋಟಿಸಹಸ್ರೇಷು ವಾಜಪೇಯಶತೈಸ್ತಥಾ ।\nಕೋಟಿಖನ್ಯಾಮಹಾದಾನಂ ಏಕಬಿಲ್ವಂ ಶಿವಾರ್ಪಣಮ್ ॥', meaning:'ಕೋಟಿ ಕನ್ಯಾದಾನಕ್ಕಿಂತ ಮಿಗಿಲಾದ ಪುಣ್ಯ ಬಿಲ್ವಾರ್ಪಣೆಯಿಂದ.' },
          { id:'ba_6', number:'6', sanskrit:'लक्ष्म्यास्तनोत्पन्नं महादेवस्य च प्रियम् ।\nबिल्ववृक्षं प्रयच्छामि एकबिल्वं शिवार्पणम् ॥', kannada:'ಲಕ್ಷ್ಮ್ಯಾಸ್ತನೋತ್ಪನ್ನಂ ಮಹಾದೇವಸ್ಯ ಚ ಪ್ರಿಯಮ್ ।\nಬಿಲ್ವವೃಕ್ಷಂ ಪ್ರಯಚ್ಛಾಮಿ ಏಕಬಿಲ್ವಂ ಶಿವಾರ್ಪಣಮ್ ॥', meaning:'ಮಹಾಲಕ್ಷ್ಮಿಯಿಂದ ಉದ್ಭವಿಸಿದ ಬಿಲ್ವ ವೃಕ್ಷವನ್ನು ಶಿವನಿಗೆ ಅರ್ಪಿಸುತ್ತೇನೆ.' },
          { id:'ba_7', number:'7', sanskrit:'दर्शनं बिल्ववृक्षस्य स्पर्शनं पापनाशनम् ।\nअघोरपापसंहारं एकबिल्वं शिवार्पणम् ॥', kannada:'ದರ್ಶನಂ ಬಿಲ್ವವೃಕ್ಷಸ್ಯ ಸ್ಪರ್ಶನಂ ಪಾಪನಾಶನಮ್ ।\nಅಘೋರಪಾಪಸಂಹಾರಂ ಏಕಬಿಲ್ವಂ ಶಿವಾರ್ಪಣಮ್ ॥', meaning:'ಬಿಲ್ವ ವೃಕ್ಷ ದರ್ಶನ ಮತ್ತು ಸ್ಪರ್ಶ ಸಕಲ ಪಾಪ ನಾಶಕ.' },
          { id:'ba_8', number:'8', sanskrit:'काशीक्षेत्रनिवासं च कालभैरवदर्शनम् ।\nप्रयागे माधवं दृष्ट्वा एकबिल्वं शिवार्पणम् ॥', kannada:'ಕಾಶೀಕ್ಷೇತ್ರನಿವಾಸಂ ಚ ಕಾಲಭೈರವದರ್ಶನಮ್ ।\nಪ್ರಯಾಗೇ ಮಾಧವಂ ದೃಷ್ಟ್ವಾ ಏಕಬಿಲ್ವಂ ಶಿವಾರ್ಪಣಮ್ ॥', meaning:'ಕಾಶೀ ಕ್ಷೇತ್ರ ವಾಸ ಮತ್ತು ಕಾಲಭೈರವ ದರ್ಶನದ ಪುಣ್ಯ ಬಿಲ್ವಾರ್ಪಣೆಯಿಂದ ಲಭ್ಯ.' },
          { id:'ba_9', number:'ಫಲಶ್ರುತಿ', sanskrit:'बिल्वाष्टकमिदं पुण्यं यः पठेच्छिवसंनिधौ ।\nसर्वपापविनिर्मुक्तः शिवलोकमवाप्नुयात् ॥', kannada:'ಬಿಲ್ವಾಷ್ಟಕಮಿದಂ ಪುಣ್ಯಂ ಯಃ ಪಠೇಚ್ಛಿವಸನ್ನಿಧೌ ।\nಸರ್ವಪಾಪವಿನಿರ್ಮುಕ್ತಃ ಶಿವಲೋಕಮವಾಪ್ನುಯಾತ್ ॥', meaning:'ಬಿಲ್ವಾಷ್ಟಕ ಪಠಿಸಿದವರು ಸಕಲ ಪಾಪ ಮುಕ್ತರಾಗಿ ಶಿವಲೋಕ ಹೊಂದುತ್ತಾರೆ.' },
        ]
      }]
    },
  ]
};

// ═══════════════════════════════════════════════════════════════
// APP LOGIC
// ═══════════════════════════════════════════════════════════════

const App = {
  // ── Init ──────────────────────────────────────────────────
  init() {
    this.bindAuth();
    this.bindNav();
    this.bindForms();
  },

  // ── Auth ──────────────────────────────────────────────────
  bindAuth() {
    document.getElementById('login-form').addEventListener('submit', async (e) => {
      e.preventDefault();
      const email = document.getElementById('login-email').value;
      const password = document.getElementById('login-password').value;
      const btn = document.getElementById('login-btn');
      const error = document.getElementById('login-error');
      btn.querySelector('.btn-text').textContent = 'Signing in…';
      btn.disabled = true;
      error.classList.add('hidden');
      try {
        await auth.signInWithEmailAndPassword(email, password);
      } catch (err) {
        error.textContent = err.message;
        error.classList.remove('hidden');
        btn.querySelector('.btn-text').textContent = 'Sign In';
        btn.disabled = false;
      }
    });

    document.getElementById('logout-btn').addEventListener('click', () => auth.signOut());

    auth.onAuthStateChanged((user) => {
      if (user) {
        document.getElementById('login-page').classList.remove('active');
        document.getElementById('app-shell').classList.remove('hidden');
        document.getElementById('user-email').textContent = user.email;
        this.navigate('dashboard');
      } else {
        document.getElementById('login-page').classList.add('active');
        document.getElementById('app-shell').classList.add('hidden');
      }
    });
  },

  // ── Navigation ────────────────────────────────────────────
  bindNav() {
    document.querySelectorAll('.nav-item').forEach(item => {
      item.addEventListener('click', (e) => {
        e.preventDefault();
        this.navigate(item.dataset.page);
      });
    });

    document.getElementById('menu-toggle').addEventListener('click', () => {
      document.getElementById('sidebar').classList.toggle('open');
    });
  },

  navigate(page) {
    State.currentPage = page;
    // Update nav
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
    const navItem = document.querySelector(`.nav-item[data-page="${page}"]`);
    if (navItem) navItem.classList.add('active');
    // Update sections
    document.querySelectorAll('.page-section').forEach(s => s.classList.remove('active'));
    const section = document.getElementById(`page-${page}`);
    if (section) section.classList.add('active');
    // Update title
    const titles = { dashboard:'Dashboard', books:'Books', 'add-book':'Add Book', chapters:'Chapters', shlokas:'Shlokas', categories:'Categories', seed:'Seed Data' };
    document.getElementById('page-title').textContent = titles[page] || page;
    // Load data
    if (page === 'dashboard') this.loadDashboard();
    if (page === 'books') this.loadBooks();
    if (page === 'categories') this.loadCategories();
    if (page === 'add-book') this.setupBookForm();
    // Close mobile menu
    document.getElementById('sidebar').classList.remove('open');
  },

  // ── Dashboard ─────────────────────────────────────────────
  async loadDashboard() {
    try {
      const [booksSnap, chaptersSnap, shlokasSnap, catsSnap] = await Promise.all([
        db.collection('books').get(),
        db.collection('chapters').get(),
        db.collection('shlokas').get(),
        db.collection('categories').get(),
      ]);
      document.getElementById('stat-books').textContent = booksSnap.size;
      document.getElementById('stat-chapters').textContent = chaptersSnap.size;
      document.getElementById('stat-shlokas').textContent = shlokasSnap.size;
      document.getElementById('stat-categories').textContent = catsSnap.size;

      // Recent books
      const recent = booksSnap.docs.slice(-5).reverse();
      const recentEl = document.getElementById('recent-books');
      if (recent.length === 0) {
        recentEl.innerHTML = '<p class="muted">No books yet. <a href="#seed" onclick="App.navigate(\'seed\')">Seed data</a> to get started.</p>';
      } else {
        recentEl.innerHTML = recent.map(d => {
          const b = d.data();
          return `<div class="recent-item">
            <div><div class="recent-item-title">${b.title}</div><div class="recent-item-meta">${b.titleEn} · ${b.category}</div></div>
            <button class="btn btn-sm btn-ghost" onclick="App.editBook('${d.id}')">✏️ Edit</button>
          </div>`;
        }).join('');
      }
    } catch (err) {
      console.error('Dashboard error:', err);
      document.getElementById('recent-books').innerHTML = `<p class="muted">Error loading: ${err.message}</p>`;
    }
  },

  // ── Books ─────────────────────────────────────────────────
  async loadBooks() {
    const listEl = document.getElementById('books-list');
    listEl.innerHTML = '<p class="muted">Loading…</p>';
    try {
      const snap = await db.collection('books').orderBy('order').get();
      if (snap.empty) {
        listEl.innerHTML = '<p class="muted">No books found. <a href="#seed" onclick="App.navigate(\'seed\')">Seed data first.</a></p>';
        return;
      }
      listEl.innerHTML = snap.docs.map(d => {
        const b = d.data();
        return `<div class="book-card" onclick="App.openChapters('${d.id}', '${this.esc(b.title)}')">
          <div class="book-card-header">
            <div>
              <div class="book-card-title">${b.title}</div>
              <div class="book-card-subtitle">${b.titleSanskrit || ''} · ${b.titleEn}</div>
            </div>
          </div>
          <div class="book-card-meta">
            <span class="badge badge-category">${b.category}</span>
            <span class="badge ${b.isPremium ? 'badge-premium' : 'badge-free'}">${b.isPremium ? '🔒 Premium' : '🆓 Free'}</span>
          </div>
          <div class="book-card-actions">
            <button class="btn btn-sm btn-ghost" onclick="event.stopPropagation();App.editBook('${d.id}')">✏️ Edit</button>
            <button class="btn btn-sm btn-ghost" onclick="event.stopPropagation();App.deleteBook('${d.id}','${this.esc(b.title)}')">🗑️</button>
          </div>
        </div>`;
      }).join('');
    } catch (err) {
      listEl.innerHTML = `<p class="muted">Error: ${err.message}</p>`;
    }
  },

  // ── Book Form ─────────────────────────────────────────────
  setupBookForm(bookData, bookId) {
    const form = document.getElementById('book-form');
    const title = document.getElementById('book-form-title');
    const catSelect = document.getElementById('book-category');
    const subSelect = document.getElementById('book-subcategory');

    // Populate category dropdowns
    catSelect.innerHTML = '<option value="">Select…</option>' +
      Object.entries(SEED.categories).map(([k,v]) => `<option value="${k}">${v.title} (${v.titleEn})</option>`).join('');

    catSelect.onchange = () => {
      const cat = SEED.categories[catSelect.value];
      subSelect.innerHTML = '<option value="">Select…</option>' +
        (cat ? cat.subcategories.map(s => `<option value="${s.id}">${s.title} (${s.titleEn})</option>`).join('') : '');
      if (bookData && bookData.subcategory) subSelect.value = bookData.subcategory;
    };

    if (bookData) {
      title.textContent = 'Edit Book';
      document.getElementById('book-id').value = bookId || '';
      document.getElementById('book-title').value = bookData.title || '';
      document.getElementById('book-titleSanskrit').value = bookData.titleSanskrit || '';
      document.getElementById('book-titleEn').value = bookData.titleEn || '';
      catSelect.value = bookData.category || '';
      catSelect.onchange();
      subSelect.value = bookData.subcategory || '';
      document.getElementById('book-godRelated').value = (bookData.godRelated || []).join(', ');
      document.getElementById('book-description').value = bookData.description || '';
      document.getElementById('book-order').value = bookData.order || 0;
      document.getElementById('book-isPremium').checked = bookData.isPremium || false;
      State.editingBookId = bookId;
    } else {
      title.textContent = 'Add New Book';
      form.reset();
      State.editingBookId = null;
      catSelect.onchange();
    }
  },

  bindForms() {
    // Book form
    document.getElementById('book-form').addEventListener('submit', async (e) => {
      e.preventDefault();
      const data = {
        title: document.getElementById('book-title').value,
        titleSanskrit: document.getElementById('book-titleSanskrit').value,
        titleEn: document.getElementById('book-titleEn').value,
        category: document.getElementById('book-category').value,
        subcategory: document.getElementById('book-subcategory').value,
        godRelated: document.getElementById('book-godRelated').value.split(',').map(s => s.trim()).filter(Boolean),
        description: document.getElementById('book-description').value,
        order: parseInt(document.getElementById('book-order').value) || 0,
        isPremium: document.getElementById('book-isPremium').checked,
        updatedAt: firebase.firestore.FieldValue.serverTimestamp(),
      };
      try {
        if (State.editingBookId) {
          await db.collection('books').doc(State.editingBookId).update(data);
          this.toast('Book updated ✅', 'success');
        } else {
          data.id = data.titleEn.toLowerCase().replace(/[^a-z0-9]+/g, '_');
          data.createdAt = firebase.firestore.FieldValue.serverTimestamp();
          await db.collection('books').doc(data.id).set(data);
          this.toast('Book created ✅', 'success');
        }
        this.navigate('books');
      } catch (err) {
        this.toast('Error: ' + err.message, 'error');
      }
    });

    document.getElementById('book-cancel-btn').addEventListener('click', () => this.navigate('books'));

    // Chapter form
    document.getElementById('chapter-form').addEventListener('submit', async (e) => {
      e.preventDefault();
      const chId = document.getElementById('chapter-id').value;
      const data = {
        bookId: document.getElementById('chapter-bookId').value,
        number: parseInt(document.getElementById('chapter-number').value),
        title: document.getElementById('chapter-title').value,
        titleSanskrit: document.getElementById('chapter-titleSanskrit').value,
        titleEn: document.getElementById('chapter-titleEn').value,
        order: parseInt(document.getElementById('chapter-number').value),
      };
      try {
        if (chId) {
          await db.collection('chapters').doc(chId).update(data);
          this.toast('Chapter updated ✅', 'success');
        } else {
          const id = `${data.bookId}_ch${data.number}`;
          await db.collection('chapters').doc(id).set({ ...data, id });
          this.toast('Chapter created ✅', 'success');
        }
        this.closeModal('chapter-modal');
        this.openChapters(data.bookId);
      } catch (err) {
        this.toast('Error: ' + err.message, 'error');
      }
    });

    // Shloka form
    document.getElementById('shloka-form').addEventListener('submit', async (e) => {
      e.preventDefault();
      const shId = document.getElementById('shloka-id').value;
      const data = {
        chapterId: document.getElementById('shloka-chapterId').value,
        bookId: document.getElementById('shloka-bookId').value,
        number: document.getElementById('shloka-number').value,
        sanskrit: document.getElementById('shloka-sanskrit').value,
        kannada: document.getElementById('shloka-kannada').value,
        meaning: document.getElementById('shloka-meaning').value,
        explanation: document.getElementById('shloka-explanation').value,
        isPremium: document.getElementById('shloka-isPremium').checked,
        order: parseInt(document.getElementById('shloka-order').value) || 0,
      };
      try {
        if (shId) {
          await db.collection('shlokas').doc(shId).update(data);
          this.toast('Shloka updated ✅', 'success');
        } else {
          const id = `${data.bookId}_${data.number.replace(/[^a-z0-9]/gi, '_')}`;
          await db.collection('shlokas').doc(id).set({ ...data, id });
          this.toast('Shloka created ✅', 'success');
        }
        this.closeModal('shloka-modal');
        this.openShlokas(data.chapterId, data.bookId);
      } catch (err) {
        this.toast('Error: ' + err.message, 'error');
      }
    });

    // Add chapter/shloka buttons
    document.getElementById('add-chapter-btn').addEventListener('click', () => {
      document.getElementById('chapter-form').reset();
      document.getElementById('chapter-id').value = '';
      document.getElementById('chapter-bookId').value = State.currentBookId;
      document.getElementById('chapter-modal-title').textContent = 'Add Chapter';
      this.openModal('chapter-modal');
    });

    document.getElementById('add-shloka-btn').addEventListener('click', () => {
      document.getElementById('shloka-form').reset();
      document.getElementById('shloka-id').value = '';
      document.getElementById('shloka-chapterId').value = State.currentChapterId;
      document.getElementById('shloka-bookId').value = State.currentBookId;
      document.getElementById('shloka-modal-title').textContent = 'Add Shloka';
      this.openModal('shloka-modal');
    });

    document.getElementById('back-to-chapters-btn').addEventListener('click', () => {
      this.openChapters(State.currentBookId);
    });

    // Seed button
    document.getElementById('seed-btn').addEventListener('click', () => this.seedData());
  },

  // ── Edit Book ─────────────────────────────────────────────
  async editBook(bookId) {
    try {
      const doc = await db.collection('books').doc(bookId).get();
      if (doc.exists) {
        this.navigate('add-book');
        this.setupBookForm(doc.data(), bookId);
      }
    } catch (err) {
      this.toast('Error: ' + err.message, 'error');
    }
  },

  // ── Delete Book ───────────────────────────────────────────
  async deleteBook(bookId, title) {
    if (!confirm(`Delete "${title}" and all its chapters/shlokas?`)) return;
    try {
      // Delete shlokas
      const shlokas = await db.collection('shlokas').where('bookId','==',bookId).get();
      const batch1 = db.batch();
      shlokas.forEach(d => batch1.delete(d.ref));
      await batch1.commit();
      // Delete chapters
      const chapters = await db.collection('chapters').where('bookId','==',bookId).get();
      const batch2 = db.batch();
      chapters.forEach(d => batch2.delete(d.ref));
      await batch2.commit();
      // Delete book
      await db.collection('books').doc(bookId).delete();
      this.toast('Book deleted ✅', 'success');
      this.loadBooks();
    } catch (err) {
      this.toast('Error: ' + err.message, 'error');
    }
  },

  // ── Chapters ──────────────────────────────────────────────
  async openChapters(bookId, title) {
    State.currentBookId = bookId;
    this.navigate('chapters');
    if (title) document.getElementById('chapters-book-title').textContent = title;
    const listEl = document.getElementById('chapters-list');
    listEl.innerHTML = '<p class="muted">Loading…</p>';
    try {
      // Get book title if not provided
      if (!title) {
        const bookDoc = await db.collection('books').doc(bookId).get();
        if (bookDoc.exists) document.getElementById('chapters-book-title').textContent = bookDoc.data().title;
      }
      const snap = await db.collection('chapters').where('bookId','==',bookId).get();
      if (snap.empty) {
        listEl.innerHTML = '<p class="muted">No chapters yet. Add one!</p>';
        return;
      }
      const sortedDocs = snap.docs.sort((a,b) => (a.data().number||0) - (b.data().number||0));
      listEl.innerHTML = sortedDocs.map(d => {
        const c = d.data();
        return `<div class="chapter-item">
          <div class="chapter-info" onclick="App.openShlokas('${d.id}','${bookId}','${this.esc(c.title)}')" style="cursor:pointer;">
            <h4>Ch ${c.number}: ${c.title}</h4>
            <p>${c.titleSanskrit || ''} · ${c.titleEn || ''}</p>
          </div>
          <div class="item-actions">
            <button class="btn btn-sm btn-ghost" onclick="App.editChapter('${d.id}')">✏️</button>
            <button class="btn btn-sm btn-ghost" onclick="App.deleteChapter('${d.id}','${bookId}')">🗑️</button>
          </div>
        </div>`;
      }).join('');
    } catch (err) {
      listEl.innerHTML = `<p class="muted">Error: ${err.message}</p>`;
    }
  },

  async editChapter(chId) {
    const doc = await db.collection('chapters').doc(chId).get();
    if (!doc.exists) return;
    const c = doc.data();
    document.getElementById('chapter-id').value = chId;
    document.getElementById('chapter-bookId').value = c.bookId;
    document.getElementById('chapter-number').value = c.number;
    document.getElementById('chapter-title').value = c.title;
    document.getElementById('chapter-titleSanskrit').value = c.titleSanskrit || '';
    document.getElementById('chapter-titleEn').value = c.titleEn || '';
    document.getElementById('chapter-modal-title').textContent = 'Edit Chapter';
    this.openModal('chapter-modal');
  },

  async deleteChapter(chId, bookId) {
    if (!confirm('Delete this chapter and all its shlokas?')) return;
    const shlokas = await db.collection('shlokas').where('chapterId','==',chId).get();
    const batch = db.batch();
    shlokas.forEach(d => batch.delete(d.ref));
    await batch.commit();
    await db.collection('chapters').doc(chId).delete();
    this.toast('Chapter deleted ✅', 'success');
    this.openChapters(bookId);
  },

  // ── Shlokas ───────────────────────────────────────────────
  async openShlokas(chapterId, bookId, title) {
    State.currentChapterId = chapterId;
    State.currentBookId = bookId;
    this.navigate('shlokas');
    if (title) document.getElementById('shlokas-chapter-title').textContent = title;
    const listEl = document.getElementById('shlokas-list');
    listEl.innerHTML = '<p class="muted">Loading…</p>';
    try {
      const snap = await db.collection('shlokas').where('chapterId','==',chapterId).get();
      if (snap.empty) {
        listEl.innerHTML = '<p class="muted">No shlokas yet. Add one!</p>';
        return;
      }
      const sortedShlokas = snap.docs.sort((a,b) => (a.data().order||0) - (b.data().order||0));
      listEl.innerHTML = sortedShlokas.map(d => {
        const s = d.data();
        return `<div class="shloka-item">
          <div class="shloka-info">
            <div class="shloka-number">#${s.number} ${s.isPremium ? '🔒' : ''}</div>
            <div class="shloka-preview">${(s.sanskrit||'').substring(0,80)}…</div>
          </div>
          <div class="item-actions">
            <button class="btn btn-sm btn-ghost" onclick="App.editShloka('${d.id}')">✏️</button>
            <button class="btn btn-sm btn-ghost" onclick="App.deleteShloka('${d.id}')">🗑️</button>
          </div>
        </div>`;
      }).join('');
    } catch (err) {
      listEl.innerHTML = `<p class="muted">Error: ${err.message}</p>`;
    }
  },

  async editShloka(shId) {
    const doc = await db.collection('shlokas').doc(shId).get();
    if (!doc.exists) return;
    const s = doc.data();
    document.getElementById('shloka-id').value = shId;
    document.getElementById('shloka-chapterId').value = s.chapterId;
    document.getElementById('shloka-bookId').value = s.bookId;
    document.getElementById('shloka-number').value = s.number;
    document.getElementById('shloka-sanskrit').value = s.sanskrit || '';
    document.getElementById('shloka-kannada').value = s.kannada || '';
    document.getElementById('shloka-meaning').value = s.meaning || '';
    document.getElementById('shloka-explanation').value = s.explanation || '';
    document.getElementById('shloka-isPremium').checked = s.isPremium || false;
    document.getElementById('shloka-order').value = s.order || 0;
    document.getElementById('shloka-modal-title').textContent = 'Edit Shloka';
    this.openModal('shloka-modal');
  },

  async deleteShloka(shId) {
    if (!confirm('Delete this shloka?')) return;
    await db.collection('shlokas').doc(shId).delete();
    this.toast('Shloka deleted ✅', 'success');
    this.openShlokas(State.currentChapterId, State.currentBookId);
  },

  // ── Categories ────────────────────────────────────────────
  async loadCategories() {
    const el = document.getElementById('categories-list');
    try {
      const snap = await db.collection('categories').get();
      if (snap.empty) {
        el.innerHTML = '<p class="muted">No categories. <a href="#seed" onclick="App.navigate(\'seed\')">Seed data</a> first.</p>';
        return;
      }
      el.innerHTML = snap.docs.map(d => {
        const c = d.data();
        return `<div class="category-card">
          <h3>${c.icon || ''} ${c.title}</h3>
          <div class="cat-en">${c.titleEn} · ${c.description || ''}</div>
          <div class="subcat-list">
            ${(c.subcategories||[]).map(s => `<span class="subcat-badge">${s.icon||''} ${s.title}</span>`).join('')}
          </div>
        </div>`;
      }).join('');
    } catch (err) {
      el.innerHTML = `<p class="muted">Error: ${err.message}</p>`;
    }
  },

  // ── Seed Data ─────────────────────────────────────────────
  async seedData() {
    const btn = document.getElementById('seed-btn');
    const progress = document.getElementById('seed-progress');
    const fill = document.getElementById('seed-progress-fill');
    const text = document.getElementById('seed-progress-text');
    const result = document.getElementById('seed-result');

    btn.disabled = true;
    btn.querySelector('.btn-text').classList.add('hidden');
    btn.querySelector('.btn-loader').classList.remove('hidden');
    progress.classList.remove('hidden');
    result.classList.add('hidden');

    let total = 0, done = 0;
    // Count totals
    total += Object.keys(SEED.categories).length;
    SEED.books.forEach(b => { total++; b.chapters.forEach(c => { total++; total += c.shlokas.length; }); });
    total += 1; // config doc

    const update = (msg) => {
      done++;
      fill.style.width = `${(done/total)*100}%`;
      text.textContent = msg;
    };

    try {
      // Seed categories
      for (const [id, cat] of Object.entries(SEED.categories)) {
        await db.collection('categories').doc(id).set(cat);
        update(`Category: ${cat.titleEn}`);
      }

      // Seed books, chapters, shlokas
      for (const book of SEED.books) {
        const { chapters, ...bookData } = book;
        bookData.createdAt = firebase.firestore.FieldValue.serverTimestamp();
        bookData.updatedAt = firebase.firestore.FieldValue.serverTimestamp();
        await db.collection('books').doc(book.id).set(bookData);
        update(`Book: ${book.titleEn}`);

        for (const chapter of chapters) {
          const { shlokas, ...chData } = chapter;
          chData.bookId = book.id;
          chData.order = chData.number;
          await db.collection('chapters').doc(chapter.id).set(chData);
          update(`Chapter: ${chapter.titleEn}`);

          for (let i = 0; i < shlokas.length; i++) {
            const sh = { ...shlokas[i], chapterId: chapter.id, bookId: book.id, isPremium: false, order: i + 1 };
            await db.collection('shlokas').doc(sh.id).set(sh);
            update(`Shloka: ${sh.id}`);
          }
        }
      }

      // Set content version
      await db.collection('config').doc('app').set({ contentVersion: 1, lastUpdated: firebase.firestore.FieldValue.serverTimestamp() });
      update('Config saved');

      fill.style.width = '100%';
      text.textContent = 'Done!';
      result.innerHTML = '<p class="success-msg">✅ All data seeded successfully! Go to <a href="#dashboard" onclick="App.navigate(\'dashboard\')">Dashboard</a> to verify.</p>';
      result.classList.remove('hidden');
      this.toast('Data seeded successfully! 🎉', 'success');
    } catch (err) {
      text.textContent = 'Error: ' + err.message;
      result.innerHTML = `<p class="error-msg">❌ ${err.message}</p>`;
      result.classList.remove('hidden');
      this.toast('Seed error: ' + err.message, 'error');
    }

    btn.disabled = false;
    btn.querySelector('.btn-text').classList.remove('hidden');
    btn.querySelector('.btn-loader').classList.add('hidden');
  },

  // ── Modal Helpers ─────────────────────────────────────────
  openModal(id) {
    document.getElementById(id).classList.remove('hidden');
  },
  closeModal(id) {
    document.getElementById(id).classList.add('hidden');
  },

  // ── Toast ─────────────────────────────────────────────────
  toast(message, type = 'info') {
    const container = document.getElementById('toast-container');
    const el = document.createElement('div');
    el.className = `toast toast-${type}`;
    el.textContent = message;
    container.appendChild(el);
    setTimeout(() => el.remove(), 3000);
  },

  // ── Helpers ───────────────────────────────────────────────
  esc(str) {
    return (str || '').replace(/'/g, "\\'").replace(/"/g, '&quot;');
  },
};

// ── Start ──────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => App.init());
