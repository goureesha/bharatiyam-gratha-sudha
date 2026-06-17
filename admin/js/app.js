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
  editingBookId: null,
};

// ── Unified Categories ─────────────────────────────────────────
const CATEGORIES = {
  gita: { title: 'ಗೀತೆಗಳು', titleEn: 'Gitas' },
  upanishad: { title: 'ಉಪನಿಷತ್ತುಗಳು', titleEn: 'Upanishads' },
  purana: { title: 'ಪುರಾಣಗಳು', titleEn: 'Puranas' },
  smriti: { title: 'ಸ್ಮೃತಿಗಳು ಮತ್ತು ನೀತಿಗಳು', titleEn: 'Smritis & Ethics' },
  stotra_main: { title: 'ಮುಖ್ಯ ಸ್ತೋತ್ರಗಳು', titleEn: 'Main Stotras' },
  stotra_extras: { title: 'ಇತರ ಸ್ತೋತ್ರಗಳು', titleEn: 'Extras / Other Stotras' }
};

// ── Helper to dynamically fetch assets with fallbacks ─────────
async function fetchAsset(filename) {
  const paths = [
    `../assets/data/${filename}`,
    `/assets/data/${filename}`,
    `/assets/assets/data/${filename}`,
    `assets/data/${filename}`
  ];
  for (const path of paths) {
    try {
      console.log(`Trying to fetch asset: ${path}`);
      const res = await fetch(path);
      if (res.ok) {
        console.log(`Successfully fetched ${filename} from: ${path}`);
        return await res.json();
      }
    } catch (e) {
      console.warn(`Failed to fetch from ${path}:`, e);
    }
  }
  throw new Error(`Could not load asset ${filename} from any expected paths.`);
}

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
    const titles = { dashboard:'Dashboard', books:'Books', 'add-book':'Add Book', chapters:'Chapters', categories:'Categories', seed:'Seed Data' };
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
      const [booksSnap, chaptersSnap] = await Promise.all([
        db.collection('books').get(),
        db.collection('chapters').get(),
      ]);
      document.getElementById('stat-books').textContent = booksSnap.size;
      document.getElementById('stat-chapters').textContent = chaptersSnap.size;
      document.getElementById('stat-categories').textContent = Object.keys(CATEGORIES).length;

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
    const iconInput = document.getElementById('book-icon');

    // Populate category dropdown
    catSelect.innerHTML = '<option value="">Select…</option>' +
      Object.entries(CATEGORIES).map(([k,v]) => `<option value="${k}">${v.title} (${v.titleEn})</option>`).join('');

    if (bookData) {
      title.textContent = 'Edit Book / Category';
      document.getElementById('book-id').value = bookId || '';
      document.getElementById('book-title').value = bookData.title || '';
      document.getElementById('book-titleSanskrit').value = bookData.titleSanskrit || '';
      document.getElementById('book-titleEn').value = bookData.titleEn || '';
      catSelect.value = bookData.category || '';
      iconInput.value = bookData.icon || '🕉️';
      document.getElementById('book-godRelated').value = (bookData.godRelated || []).join(', ');
      document.getElementById('book-description').value = bookData.description || '';
      document.getElementById('book-order').value = bookData.order || 0;
      document.getElementById('book-isPremium').checked = bookData.isPremium || false;
      State.editingBookId = bookId;
    } else {
      title.textContent = 'Add New Book / Category';
      form.reset();
      iconInput.value = '🕉️';
      State.editingBookId = null;
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
        icon: document.getElementById('book-icon').value,
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
        content: document.getElementById('chapter-content').value,
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

    // Add chapter button
    document.getElementById('add-chapter-btn').addEventListener('click', () => {
      document.getElementById('chapter-form').reset();
      document.getElementById('chapter-id').value = '';
      document.getElementById('chapter-content').value = '';
      document.getElementById('chapter-bookId').value = State.currentBookId;
      document.getElementById('chapter-modal-title').textContent = 'Add Chapter / Stotra';
      this.openModal('chapter-modal');
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
    if (!confirm(`Delete "${title}" and all its chapters?`)) return;
    try {
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
          <div class="chapter-info" onclick="App.editChapter('${d.id}')" style="cursor:pointer;">
            <h4>Ch ${c.number || c.order}: ${c.title}</h4>
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
    document.getElementById('chapter-number').value = c.number || c.order || 0;
    document.getElementById('chapter-title').value = c.title || '';
    document.getElementById('chapter-titleSanskrit').value = c.titleSanskrit || '';
    document.getElementById('chapter-titleEn').value = c.titleEn || '';
    document.getElementById('chapter-content').value = c.content || '';
    document.getElementById('chapter-modal-title').textContent = 'Edit Chapter / Stotra';
    this.openModal('chapter-modal');
  },

  async deleteChapter(chId, bookId) {
    if (!confirm('Delete this chapter?')) return;
    await db.collection('chapters').doc(chId).delete();
    this.toast('Chapter deleted ✅', 'success');
    this.openChapters(bookId);
  },

  // ── Categories ────────────────────────────────────────────
  loadCategories() {
    const el = document.getElementById('categories-list');
    el.innerHTML = Object.entries(CATEGORIES).map(([id, c]) => {
      return `<div class="category-card">
        <h3>${c.title}</h3>
        <div class="cat-en">${c.titleEn} (ID: ${id})</div>
      </div>`;
    }).join('');
  },

  // ── Seed Data ─────────────────────────────────────────────
  async seedData() {
    const btn = document.getElementById('seed-btn');
    const progress = document.getElementById('seed-progress');
    const fill = document.getElementById('seed-progress-fill');
    const text = document.getElementById('seed-progress-text');
    const result = document.getElementById('seed-result');

    const scripturesFile = document.getElementById('seed-scriptures-file').files[0];
    const stotrasFile = document.getElementById('seed-stotras-file').files[0];

    if (!scripturesFile || !stotrasFile) {
      this.toast('Please select both scriptures_data.json and stotra_data.json files!', 'error');
      return;
    }

    btn.disabled = true;
    btn.querySelector('.btn-text').classList.add('hidden');
    btn.querySelector('.btn-loader').classList.remove('hidden');
    progress.classList.remove('hidden');
    result.classList.add('hidden');

    try {
      // 1. Read and parse local files
      text.textContent = 'Reading scriptures_data.json...';
      fill.style.width = '5%';
      const scripturesText = await scripturesFile.text();
      const scriptures = JSON.parse(scripturesText);

      text.textContent = 'Reading stotra_data.json...';
      fill.style.width = '10%';
      const stotrasText = await stotrasFile.text();
      const stotrasData = JSON.parse(stotrasText);

      text.textContent = 'Parsing and preparing documents...';
      fill.style.width = '15%';

      const booksToUpload = [];
      const chaptersToUpload = [];

      // Process scriptures
      scriptures.forEach((b, bIdx) => {
        const { chapters, ...bookData } = b;
        bookData.category = b.category || 'upanishad';
        bookData.icon = b.icon || '🕉️';
        bookData.order = b.order !== undefined ? b.order : bIdx;
        booksToUpload.push({ id: b.id, data: bookData });

        (chapters || []).forEach((c, cIdx) => {
          const chData = {
            id: c.id,
            bookId: b.id,
            title: c.title,
            titleSanskrit: c.titleSanskrit || '',
            titleEn: c.titleEn || '',
            order: c.order !== undefined ? c.order : cIdx
          };

          const content = c.content || '';
          const maxChunkSize = 800000; // 800KB chunks (safe under 1MB)
          
          if (content.length <= maxChunkSize) {
            chaptersToUpload.push({
              id: c.id,
              data: { ...chData, content: content }
            });
          } else {
            let partIndex = 0;
            for (let offset = 0; offset < content.length; offset += maxChunkSize) {
              const chunk = content.substring(offset, offset + maxChunkSize);
              chaptersToUpload.push({
                id: `${c.id}_part_${partIndex}`,
                data: {
                  ...chData,
                  id: `${c.id}_part_${partIndex}`,
                  content: chunk,
                  isPart: true,
                  partIndex: partIndex
                }
              });
              partIndex++;
            }
          }
        });
      });

      // Process stotras
      const processStotraCategory = (cat, catIdx, categoryGroup) => {
        const { stotras, ...catData } = cat;
        catData.category = categoryGroup;
        catData.icon = cat.icon || '📿';
        catData.order = catIdx;
        booksToUpload.push({ id: cat.id, data: catData });

        (stotras || []).forEach((s, sIdx) => {
          const stData = {
            id: s.id,
            bookId: cat.id,
            title: s.title,
            titleSanskrit: s.titleSanskrit || '',
            titleEn: s.titleEn || '',
            font: s.font || 'brhknd',
            isUnicode: s.unicode === true || s.isUnicode === true,
            order: sIdx
          };

          const content = s.content || '';
          const maxChunkSize = 800000;
          
          if (content.length <= maxChunkSize) {
            chaptersToUpload.push({
              id: s.id,
              data: { ...stData, content: content }
            });
          } else {
            let partIndex = 0;
            for (let offset = 0; offset < content.length; offset += maxChunkSize) {
              const chunk = content.substring(offset, offset + maxChunkSize);
              chaptersToUpload.push({
                id: `${s.id}_part_${partIndex}`,
                data: {
                  ...stData,
                  id: `${s.id}_part_${partIndex}`,
                  content: chunk,
                  isPart: true,
                  partIndex: partIndex
                }
              });
              partIndex++;
            }
          }
        });
      };

      (stotrasData.mainCategories || []).forEach((cat, idx) => processStotraCategory(cat, idx, 'stotra_main'));
      (stotrasData.extrasCategories || []).forEach((cat, idx) => processStotraCategory(cat, idx, 'stotra_extras'));

      const totalOperations = booksToUpload.length + chaptersToUpload.length + 1; // +1 for config doc
      let doneOperations = 0;

      const updateProgress = (msg) => {
        const pct = Math.min(15 + Math.floor((doneOperations / totalOperations) * 80), 95);
        fill.style.width = `${pct}%`;
        text.textContent = `${msg} (${doneOperations}/${totalOperations})`;
      };

      // 2. Upload books in batches
      text.textContent = 'Uploading books...';
      let batch = db.batch();
      let count = 0;

      for (const book of booksToUpload) {
        batch.set(db.collection('books').doc(book.id), book.data);
        count++;
        doneOperations++;
        if (count === 400) {
          await batch.commit();
          batch = db.batch();
          count = 0;
          updateProgress('Uploaded books batch...');
        }
      }
      if (count > 0) {
        await batch.commit();
        updateProgress('Uploaded books...');
      }

      // 3. Upload chapters in batches
      text.textContent = 'Uploading chapters...';
      batch = db.batch();
      count = 0;
      let batchNum = 1;

      for (const ch of chaptersToUpload) {
        batch.set(db.collection('chapters').doc(ch.id), ch.data);
        count++;
        doneOperations++;
        if (count === 400) {
          await batch.commit();
          batch = db.batch();
          count = 0;
          updateProgress(`Uploaded chapters batch ${batchNum++}...`);
        }
      }
      if (count > 0) {
        await batch.commit();
        updateProgress('Uploaded all chapters...');
      }

      // 4. Update config doc
      await db.collection('config').doc('app').set({
        contentVersion: firebase.firestore.FieldValue.increment(1),
        lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
      });
      doneOperations++;

      fill.style.width = '100%';
      text.textContent = 'Done!';
      result.innerHTML = `<p class="success-msg">✅ Successfully seeded ${booksToUpload.length} books/categories and ${chaptersToUpload.length} chapters/stotras to Firestore!</p>`;
      result.classList.remove('hidden');
      this.toast('Data seeded successfully! 🎉', 'success');
      this.loadDashboard();
    } catch (err) {
      console.error(err);
      text.textContent = 'Error: ' + err.message;
      result.innerHTML = `<p class="error-msg">❌ Seeding failed: ${err.message}</p>`;
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
