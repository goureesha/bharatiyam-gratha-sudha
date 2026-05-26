// ============================================================
// Bharatiyam Gratha Sudha — App Logic & Routing
// ============================================================

const App = {
  currentSection: "home",
  currentSubcategory: null,
  currentBook: null,
  currentChapter: null,
  searchQuery: "",
  scriptFilter: "both", // "devanagari", "kannada", or "both"
  showMeaning: true,
  history: [],

  // ── Initialization ──────────────────────────────────────────
  init() {
    // Load theme
    const savedTheme = BookmarkStorage.getTheme();
    document.documentElement.setAttribute("data-theme", savedTheme);
    this.updateThemeIcon(savedTheme);

    // Load font size
    const savedFontSize = BookmarkStorage.getFontSize();
    document.documentElement.setAttribute("data-font-size", savedFontSize);

    // Load script filter and meaning toggle
    this.scriptFilter = BookmarkStorage.getScriptFilter() || "both";
    this.showMeaning = BookmarkStorage.getShowMeaning() !== false;

    // Update bookmark badge
    this.updateBookmarkBadge();

    // Handle hash routing
    window.addEventListener("hashchange", () => this.handleRoute());
    this.handleRoute();
  },

  // ── Routing ─────────────────────────────────────────────────
  handleRoute() {
    const hash = window.location.hash.slice(1) || "home";
    const parts = hash.split("/");
    const section = parts[0];

    switch (section) {
      case "home":
        this.showHome();
        break;
      case "library":
      case "mantras":
      case "stotras":
        if (parts[3]) {
          // section/subcategory/bookId/chapterId
          this.showChapter(parts[2], parts[3], section);
        } else if (parts[2]) {
          // section/subcategory/bookId
          this.showBook(parts[2], section);
        } else if (parts[1]) {
          // section/subcategory
          this.showSubcategory(parts[1], section);
        } else {
          this.showSection(section);
        }
        break;
      case "saved":
        this.showSaved();
        break;
      case "settings":
        this.showSettings();
        break;
      case "search":
        this.showSearchResults(decodeURIComponent(parts[1] || ""));
        break;
      default:
        this.showHome();
    }
  },

  navigate(route) {
    window.location.hash = route;
  },

  // ── Update Bottom Nav ───────────────────────────────────────
  updateBottomNav(section) {
    document.querySelectorAll(".bottom-nav-item").forEach((item) => {
      item.classList.toggle("active", item.dataset.section === section);
    });
  },

  updateBookmarkBadge() {
    const count = BookmarkStorage.getCount();
    const badge = document.getElementById("bookmarkBadge");
    if (badge) {
      if (count > 0) {
        badge.textContent = count;
        badge.classList.remove("hidden");
      } else {
        badge.classList.add("hidden");
      }
    }
  },

  // ── Theme Toggle ────────────────────────────────────────────
  toggleTheme() {
    const current = document.documentElement.getAttribute("data-theme");
    const newTheme = current === "dark" ? "light" : "dark";
    document.documentElement.setAttribute("data-theme", newTheme);
    BookmarkStorage.setTheme(newTheme);
    this.updateThemeIcon(newTheme);
    this.showToast(newTheme === "dark" ? "🌙 ಡಾರ್ಕ್ ಮೋಡ್" : "☀️ ಲೈಟ್ ಮೋಡ್");
  },

  updateThemeIcon(theme) {
    const btn = document.getElementById("themeToggleBtn");
    if (btn) btn.textContent = theme === "dark" ? "☀️" : "🌙";
  },

  // ── Toast ───────────────────────────────────────────────────
  showToast(message) {
    const toast = document.getElementById("toast");
    toast.textContent = message;
    toast.classList.add("show");
    setTimeout(() => toast.classList.remove("show"), 2000);
  },

  // ── Render Helpers ──────────────────────────────────────────
  setContent(html) {
    const area = document.getElementById("contentArea");
    area.innerHTML = html;
    // Stagger shloka card animations
    const cards = area.querySelectorAll(".shloka-card");
    cards.forEach((card, i) => {
      card.style.animationDelay = `${i * 0.1}s`;
    });
    window.scrollTo({ top: 0, behavior: "smooth" });
  },

  renderSearchBar() {
    return `
      <div class="search-container">
        <span class="search-icon">🔍</span>
        <input
          type="search"
          class="search-bar"
          id="searchInput"
          placeholder="ಶ್ಲೋಕ, ಪುಸ್ತಕ ಅಥವಾ ಪದ ಹುಡುಕಿ..."
          value="${this.searchQuery}"
          onkeydown="if(event.key==='Enter')App.doSearch()"
          oninput="App.searchQuery=this.value"
        >
      </div>
    `;
  },

  renderSectionHeader(icon, title, titleEn) {
    return `
      <div class="section-header">
        <span class="section-icon">${icon}</span>
        <h2 class="section-title">${title}</h2>
        <span class="section-title-en">${titleEn}</span>
      </div>
    `;
  },

  renderBreadcrumb(items) {
    return `
      <div class="breadcrumb">
        ${items
          .map(
            (item, i) => `
          <button class="breadcrumb-item ${i === items.length - 1 ? "active" : ""}"
                  onclick="${item.action || ""}">${item.label}</button>
          ${i < items.length - 1 ? '<span class="breadcrumb-separator">›</span>' : ""}
        `
          )
          .join("")}
      </div>
    `;
  },

  renderShlokaCard(shloka, showSource) {
    const isBookmarked = BookmarkStorage.isBookmarked(shloka.id);
    const sourceLabel = showSource
      ? `<span class="shloka-source">${shloka.bookTitle || ""} ${shloka.chapterTitle ? "• " + shloka.chapterTitle : ""}</span>`
      : "";
    const filter = this.scriptFilter;

    return `
      <article class="shloka-card" id="shloka-${shloka.id}">
        <div class="shloka-header">
          <span class="shloka-number">श्लोक ${shloka.number}</span>
          ${sourceLabel}
          <button class="bookmark-btn ${isBookmarked ? "bookmarked" : ""}"
                  onclick="App.toggleBookmark('${shloka.id}')"
                  title="${isBookmarked ? "ಉಳಿಸಿದ್ದನ್ನು ತೆಗೆಯಿರಿ" : "ಉಳಿಸಿ"}"
                  id="bookmark-${shloka.id}">
            ${isBookmarked ? "❤️" : "🤍"}
          </button>
        </div>
        ${filter === "both" || filter === "devanagari" ? `
        <div class="shloka-sanskrit">
          <div class="layer-label">📜 ಸಂಸ್ಕೃತ · Sanskrit</div>
          <div class="sanskrit-text">${shloka.sanskrit}</div>
        </div>` : ""}
        ${filter === "both" || filter === "kannada" ? `
        <div class="shloka-kannada">
          <div class="layer-label">📝 ಕನ್ನಡ · Kannada</div>
          <div class="kannada-text">${shloka.kannada}</div>
        </div>` : ""}
        ${this.showMeaning ? `
        <div class="shloka-meaning">
          <div class="layer-label">💡 ಅರ್ಥ · Meaning</div>
          <div class="meaning-text">${shloka.meaning}</div>
        </div>` : ""}
      </article>
    `;
  },

  renderCategoryCard(subcat, parentSection) {
    const isImage = subcat.icon && subcat.icon.includes('/');
    const iconHtml = isImage
      ? `<img src="${subcat.icon}" alt="${subcat.titleEn}" class="card-icon-img">`
      : `<span class="card-icon">${subcat.icon}</span>`;
    return `
      <div class="category-card" onclick="App.navigate('${parentSection}/${subcat.id}')">
        ${iconHtml}
        <div class="card-title">${subcat.title}</div>
        <div class="card-subtitle">${subcat.titleEn}</div>
      </div>
    `;
  },

  renderBookCard(book, section) {
    const chapterCount = book.chapters.length;
    const shlokaCount = book.chapters.reduce(
      (acc, ch) => acc + ch.shlokas.length,
      0
    );
    const icon =
      APP_DATA.categories[section]?.subcategories?.find(
        (s) => s.id === book.subcategory
      )?.icon || "📖";
    return `
      <div class="book-card" onclick="App.navigate('${section}/${book.subcategory}/${book.id}')">
        <div class="book-icon">${icon}</div>
        <div class="book-info">
          <div class="book-title">${book.title}</div>
          <div class="book-title-sanskrit">${book.titleSanskrit}</div>
          <div class="book-desc">${book.description}</div>
          <div class="book-meta">${chapterCount} ಅಧ್ಯಾಯ · ${shlokaCount} ಶ್ಲೋಕ</div>
        </div>
      </div>
    `;
  },

  renderDivider() {
    return `
      <div class="ornamental-divider">
        <span class="divider-icon">✦</span>
      </div>
    `;
  },

  // ── Page Renderers ──────────────────────────────────────────

  showHome() {
    this.currentSection = "home";
    this.updateBottomNav("home");

    const libraryBooks = getBooksByCategory("library");
    const stotraBooks = getBooksByCategory("stotras");

    this.setContent(`
      <!-- Hero Section -->
      <section class="hero-section">
        <h1 class="hero-title">ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ</h1>
        <p class="hero-subtitle">भारतीयं ग्रन्थ सुधा</p>
        <p class="hero-tagline">ಭಾರತೀಯ ಆಧ್ಯಾತ್ಮಿಕ ಗ್ರಂಥಗಳ ಡಿಜಿಟಲ್ ಗ್ರಂಥಾಲಯ</p>
      </section>

      <!-- Search -->
      ${this.renderSearchBar()}

      <!-- Quick Categories -->
      ${this.renderSectionHeader("📚", "ಗ್ರಂಥಾಲಯ", "Library")}
      <div class="category-grid">
        ${APP_DATA.categories.library.subcategories.map((s) => this.renderCategoryCard(s, "library")).join("")}
      </div>

      ${this.renderDivider()}

      <!-- God Sections -->
      ${this.renderSectionHeader("🙏", "ಮಂತ್ರಗಳು", "Mantras")}
      <div class="category-grid">
        ${APP_DATA.categories.mantras.subcategories.map((s) => this.renderCategoryCard(s, "mantras")).join("")}
      </div>

      ${this.renderDivider()}

      <!-- Stotras -->
      ${this.renderSectionHeader("📿", "ಸ್ತೋತ್ರಗಳು", "Stotras")}
      <div class="category-grid">
        ${APP_DATA.categories.stotras.subcategories.map((s) => this.renderCategoryCard(s, "stotras")).join("")}
      </div>
    `);
  },

  showSection(sectionId) {
    this.currentSection = sectionId;
    this.updateBottomNav(sectionId);

    const section = APP_DATA.categories[sectionId];
    if (!section) return this.showHome();

    const books = getBooksByCategory(sectionId);

    this.setContent(`
      ${this.renderBreadcrumb([
        { label: "🏠 ಮುಖಪುಟ", action: "App.navigate('home')" },
        { label: `${section.icon} ${section.title}` },
      ])}

      ${this.renderSearchBar()}

      ${this.renderSectionHeader(section.icon, section.title, section.titleEn)}
      <p style="color: var(--text-muted); font-family: var(--font-kannada); margin-bottom: var(--space-lg);">${section.description}</p>

      <div class="category-grid">
        ${section.subcategories.map((s) => this.renderCategoryCard(s, sectionId)).join("")}
      </div>

      ${
        books.length > 0
          ? `
        ${this.renderDivider()}
        ${this.renderSectionHeader("📖", "ಎಲ್ಲಾ ಪುಸ್ತಕಗಳು", "All Books")}
        <div class="book-list">
          ${books.map((b) => this.renderBookCard(b, sectionId)).join("")}
        </div>
      `
          : ""
      }
    `);
  },

  showSubcategory(subcategoryId, parentSection) {
    this.currentSection = parentSection;
    this.updateBottomNav(parentSection);

    const section = APP_DATA.categories[parentSection];
    const subcat = section?.subcategories?.find((s) => s.id === subcategoryId);
    if (!subcat) return this.showSection(parentSection);

    let books;
    if (parentSection === "mantras" || parentSection === "stotras") {
      books = getBooksByGod(subcategoryId).filter(b => b.category === parentSection);
    } else {
      books = getBooksBySubcategory(subcategoryId);
    }

    this.setContent(`
      ${this.renderBreadcrumb([
        { label: "🏠 ಮುಖಪುಟ", action: "App.navigate('home')" },
        { label: `${section.icon} ${section.title}`, action: `App.navigate('${parentSection}')` },
        { label: `${subcat.icon} ${subcat.title}` },
      ])}

      ${this.renderSectionHeader(subcat.icon, subcat.title, subcat.titleEn)}

      ${
        books.length > 0
          ? `
        <div class="book-list">
          ${books.map((b) => this.renderBookCard(b, parentSection)).join("")}
        </div>
      `
          : `
        <div class="empty-state">
          <span class="empty-icon">${subcat.icon}</span>
          <div class="empty-title">ಶೀಘ್ರದಲ್ಲಿ ಬರುತ್ತಿದೆ</div>
          <div class="empty-desc">ಈ ವಿಭಾಗದಲ್ಲಿ ಪುಸ್ತಕಗಳನ್ನು ಶೀಘ್ರದಲ್ಲಿ ಸೇರಿಸಲಾಗುವುದು. Coming soon!</div>
        </div>
      `
      }
    `);
  },

  showBook(bookId, parentSection) {
    const book = getBookById(bookId);
    if (!book) return this.showHome();

    this.currentBook = book;
    this.currentSection = parentSection || book.category;
    this.updateBottomNav(this.currentSection);

    // Stotras: skip chapter view, show shlokas directly
    if (book.category === "stotras" && book.chapters.length > 0) {
      this.showStotraShlokas(book);
      return;
    }

    const section = APP_DATA.categories[this.currentSection];
    const subcat = section?.subcategories?.find(
      (s) => s.id === book.subcategory
    );

    this.setContent(`
      ${this.renderBreadcrumb([
        { label: "🏠 ಮುಖಪುಟ", action: "App.navigate('home')" },
        { label: `${section?.icon || "📚"} ${section?.title || ""}`, action: `App.navigate('${this.currentSection}')` },
        {
          label: `${subcat?.icon || "📖"} ${subcat?.title || ""}`,
          action: `App.navigate('${this.currentSection}/${book.subcategory}')`,
        },
        { label: book.title },
      ])}

      <!-- Book Header -->
      <div class="hero-section" style="text-align: left; padding: var(--space-xl);">
        <h1 class="hero-title" style="font-size: var(--font-size-2xl);">${book.title}</h1>
        <p class="hero-subtitle" style="font-size: var(--font-size-md);">${book.titleSanskrit}</p>
        <p class="hero-tagline">${book.description}</p>
      </div>

      <!-- Chapters -->
      ${this.renderSectionHeader("📑", "ಅಧ್ಯಾಯಗಳು", "Chapters")}
      <div class="chapter-list">
        ${book.chapters
          .map(
            (ch) => `
          <div class="chapter-item" onclick="App.navigate('${this.currentSection}/${book.subcategory}/${book.id}/${ch.id}')">
            <div class="chapter-number">${ch.number}</div>
            <div class="chapter-info">
              <div class="chapter-title">${ch.title}</div>
              <div class="chapter-title-en">${ch.titleSanskrit} · ${ch.titleEn}</div>
              <div class="chapter-count">${ch.shlokas.length} ಶ್ಲೋಕಗಳು</div>
            </div>
          </div>
        `
          )
          .join("")}
      </div>
    `);
  },

  // ── Stotra Direct View (no chapters) ─────────────────────────
  showStotraShlokas(book) {
    const section = APP_DATA.categories[this.currentSection];
    const subcat = section?.subcategories?.find((s) => s.id === book.subcategory);
    const allShlokas = book.chapters.flatMap((ch) => ch.shlokas);

    this.setContent(`
      ${this.renderBreadcrumb([
        { label: "🏠 ಮುಖಪುಟ", action: "App.navigate('home')" },
        { label: `${section?.icon || "📿"} ${section?.title || ""}`, action: `App.navigate('${this.currentSection}')` },
        { label: book.title },
      ])}

      <button class="back-btn" onclick="App.navigate('${this.currentSection}/${book.subcategory}')">
        ← ಹಿಂದೆ ಹೋಗಿ
      </button>

      <!-- Book Header -->
      <div class="hero-section" style="text-align: left; padding: var(--space-xl);">
        <h1 class="hero-title" style="font-size: var(--font-size-2xl);">${book.title}</h1>
        <p class="hero-subtitle" style="font-size: var(--font-size-md);">${book.titleSanskrit}</p>
        <p class="hero-tagline">${book.description}</p>
      </div>

      ${this.renderScriptFilter()}

      <!-- Shlokas -->
      ${allShlokas.map((s) => this.renderShlokaCard(s, false)).join('<div class="ornamental-divider"><span class="divider-icon">॰</span></div>')}
    `);
  },

  showChapter(bookId, chapterId, parentSection) {
    const book = getBookById(bookId);
    if (!book) return this.showHome();

    const chapter = book.chapters.find((ch) => ch.id === chapterId);
    if (!chapter) return this.showBook(bookId, parentSection);

    this.currentBook = book;
    this.currentChapter = chapter;
    this.currentSection = parentSection || book.category;
    this.updateBottomNav(this.currentSection);

    const section = APP_DATA.categories[this.currentSection];
    const subcat = section?.subcategories?.find(
      (s) => s.id === book.subcategory
    );

    this.setContent(`
      ${this.renderBreadcrumb([
        { label: "🏠 ಮುಖಪುಟ", action: "App.navigate('home')" },
        { label: `${section?.icon || "📚"} ${section?.title || ""}`, action: `App.navigate('${this.currentSection}')` },
        {
          label: book.title,
          action: `App.navigate('${this.currentSection}/${book.subcategory}/${book.id}')`,
        },
        { label: chapter.title },
      ])}

      <button class="back-btn" onclick="App.navigate('${this.currentSection}/${book.subcategory}/${book.id}')">
        ← ಹಿಂದೆ ಹೋಗಿ
      </button>

      ${this.renderSectionHeader("📖", `${chapter.title}`, `${chapter.titleEn} · ಅಧ್ಯಾಯ ${chapter.number}`)}

      ${this.renderScriptFilter()}

      <!-- Shlokas -->
      ${chapter.shlokas.map((s) => this.renderShlokaCard(s, false)).join(`<div class="ornamental-divider"><span class="divider-icon">॰</span></div>`)}
    `);
  },

  showSaved() {
    this.currentSection = "saved";
    this.updateBottomNav("saved");

    const saved = BookmarkStorage.getSavedShlokas();

    if (saved.length === 0) {
      this.setContent(`
        ${this.renderSectionHeader("💖", "ಉಳಿಸಿದ ಶ್ಲೋಕಗಳು", "Saved Shlokas")}
        <div class="empty-state">
          <span class="empty-icon">💖</span>
          <div class="empty-title">ಇನ್ನೂ ಯಾವ ಶ್ಲೋಕವನ್ನೂ ಉಳಿಸಿಲ್ಲ</div>
          <div class="empty-desc">ನಿಮಗೆ ಇಷ್ಟವಾದ ಶ್ಲೋಕಗಳ 🤍 ಬಟನ್ ಒತ್ತಿ ಉಳಿಸಿ. ಅವು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.</div>
        </div>
      `);
      return;
    }

    this.setContent(`
      ${this.renderSectionHeader("💖", `ಉಳಿಸಿದ ಶ್ಲೋಕಗಳು (${saved.length})`, "Saved Shlokas")}
      ${saved.map((s) => this.renderShlokaCard(s, true)).join(`<div class="ornamental-divider"><span class="divider-icon">♦</span></div>`)}
    `);
  },

  showSettings() {
    this.currentSection = "settings";
    this.updateBottomNav("");

    const settings = BookmarkStorage.getSettings();
    const currentTheme = document.documentElement.getAttribute("data-theme");
    const currentFontSize =
      document.documentElement.getAttribute("data-font-size") || "medium";
    const bookmarkCount = BookmarkStorage.getCount();

    this.setContent(`
      ${this.renderBreadcrumb([
        { label: "🏠 ಮುಖಪುಟ", action: "App.navigate('home')" },
        { label: "⚙️ ಸೆಟ್ಟಿಂಗ್ಸ್" },
      ])}

      ${this.renderSectionHeader("⚙️", "ಸೆಟ್ಟಿಂಗ್ಸ್", "Settings")}

      <!-- Appearance -->
      <div class="settings-group">
        <div class="settings-group-title">🎨 ನೋಟ · Appearance</div>
        <div class="setting-item">
          <div>
            <div class="setting-label">ಡಾರ್ಕ್ ಮೋಡ್</div>
            <div class="setting-desc">Dark Mode</div>
          </div>
          <input type="checkbox" class="toggle-switch"
                 ${currentTheme === "dark" ? "checked" : ""}
                 onchange="App.toggleTheme()">
        </div>
        <div class="setting-item">
          <div>
            <div class="setting-label">ಅಕ್ಷರ ಗಾತ್ರ</div>
            <div class="setting-desc">Font Size</div>
          </div>
          <div class="font-size-selector">
            <button class="font-size-btn ${currentFontSize === "small" ? "active" : ""}"
                    onclick="App.setFontSize('small')">ಸಣ್ಣ</button>
            <button class="font-size-btn ${currentFontSize === "medium" ? "active" : ""}"
                    onclick="App.setFontSize('medium')">ಮಧ್ಯಮ</button>
            <button class="font-size-btn ${currentFontSize === "large" ? "active" : ""}"
                    onclick="App.setFontSize('large')">ದೊಡ್ಡ</button>
          </div>
        </div>
      </div>

      <!-- Data -->
      <div class="settings-group">
        <div class="settings-group-title">💾 ದತ್ತಾಂಶ · Data</div>
        <div class="setting-item">
          <div>
            <div class="setting-label">ಉಳಿಸಿದ ಶ್ಲೋಕಗಳು</div>
            <div class="setting-desc">${bookmarkCount} shlokas saved</div>
          </div>
          <button class="font-size-btn" onclick="App.navigate('saved')">ನೋಡಿ →</button>
        </div>
        <div class="setting-item">
          <div>
            <div class="setting-label">ಬುಕ್‌ಮಾರ್ಕ್ ರಫ್ತು ಮಾಡಿ</div>
            <div class="setting-desc">Export bookmarks as JSON</div>
          </div>
          <button class="font-size-btn" onclick="App.exportBookmarks()">📤 ರಫ್ತು</button>
        </div>
        <div class="setting-item">
          <div>
            <div class="setting-label">ಎಲ್ಲಾ ಬುಕ್‌ಮಾರ್ಕ್ ಅಳಿಸಿ</div>
            <div class="setting-desc">Clear all bookmarks</div>
          </div>
          <button class="font-size-btn" style="color: var(--sacred-red);"
                  onclick="App.clearBookmarks()">🗑️ ಅಳಿಸಿ</button>
        </div>
      </div>

      <!-- About -->
      <div class="settings-group">
        <div class="settings-group-title">ℹ️ ಕುರಿತು · About</div>
        <div class="setting-item">
          <div>
            <div class="setting-label">ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ</div>
            <div class="setting-desc">Version 1.0.0 · ಭಾರತೀಯ ಆಧ್ಯಾತ್ಮಿಕ ಗ್ರಂಥಗಳ ಡಿಜಿಟಲ್ ಗ್ರಂಥಾಲಯ</div>
          </div>
        </div>
        <div class="setting-item">
          <div>
            <div class="setting-label" style="font-family: var(--font-sanskrit);">
              सर्वे भवन्तु सुखिनः सर्वे सन्तु निरामयाः
            </div>
            <div class="setting-desc" style="font-family: var(--font-kannada);">
              ಎಲ್ಲರೂ ಸುಖಿಗಳಾಗಲಿ, ಎಲ್ಲರೂ ರೋಗಮುಕ್ತರಾಗಲಿ
            </div>
          </div>
        </div>
      </div>
    `);
  },

  // ── Search ──────────────────────────────────────────────────
  doSearch() {
    const input = document.getElementById("searchInput");
    const query = input ? input.value.trim() : this.searchQuery;
    if (query.length < 2) {
      this.showToast("ಕನಿಷ್ಠ 2 ಅಕ್ಷರ ಬೇಕು");
      return;
    }
    this.searchQuery = query;
    this.navigate(`search/${encodeURIComponent(query)}`);
  },

  showSearchResults(query) {
    this.updateBottomNav("");
    if (!query) return this.showHome();

    this.searchQuery = query;
    const results = searchShlokas(query);

    this.setContent(`
      ${this.renderBreadcrumb([
        { label: "🏠 ಮುಖಪುಟ", action: "App.navigate('home')" },
        { label: `🔍 "${query}" ಹುಡುಕಾಟ` },
      ])}

      ${this.renderSearchBar()}

      <div class="search-results-header">
        🔍 "<strong>${query}</strong>" — ${results.length} ಫಲಿತಾಂಶಗಳು ಸಿಕ್ಕವು
      </div>

      ${
        results.length > 0
          ? results
              .map((s) => this.renderShlokaCard(s, true))
              .join(
                '<div class="ornamental-divider"><span class="divider-icon">·</span></div>'
              )
          : `
        <div class="empty-state">
          <span class="empty-icon">🔍</span>
          <div class="empty-title">ಯಾವ ಫಲಿತಾಂಶವೂ ಸಿಗಲಿಲ್ಲ</div>
          <div class="empty-desc">ಬೇರೆ ಪದಗಳಿಂದ ಹುಡುಕಿ ನೋಡಿ</div>
        </div>
      `
      }
    `);
  },

  // ── Bookmark Actions ────────────────────────────────────────
  toggleBookmark(shlokaId) {
    // Find the shloka data
    let shlokaData = null;
    APP_DATA.books.forEach((book) => {
      book.chapters.forEach((chapter) => {
        chapter.shlokas.forEach((s) => {
          if (s.id === shlokaId) {
            shlokaData = {
              ...s,
              bookId: book.id,
              bookTitle: book.title,
              bookTitleEn: book.titleEn,
              chapterTitle: chapter.title,
              category: book.category,
            };
          }
        });
      });
    });

    if (!shlokaData) return;

    const isNowBookmarked = BookmarkStorage.toggle(shlokaId, shlokaData);

    // Update UI
    const btn = document.getElementById(`bookmark-${shlokaId}`);
    if (btn) {
      btn.classList.toggle("bookmarked", isNowBookmarked);
      btn.innerHTML = isNowBookmarked ? "❤️" : "🤍";
      if (isNowBookmarked) {
        btn.classList.remove("bookmarked");
        void btn.offsetWidth; // trigger reflow
        btn.classList.add("bookmarked");
      }
    }

    this.updateBookmarkBadge();
    this.showToast(
      isNowBookmarked ? "❤️ ಶ್ಲೋಕ ಉಳಿಸಲಾಗಿದೆ" : "💔 ಶ್ಲೋಕ ತೆಗೆದುಹಾಕಲಾಗಿದೆ"
    );

    // If we're on the saved page, re-render it
    if (
      this.currentSection === "saved" &&
      !isNowBookmarked
    ) {
      setTimeout(() => this.showSaved(), 300);
    }
  },

  exportBookmarks() {
    const json = BookmarkStorage.exportAsJSON();
    const blob = new Blob([json], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "bharatiyam_bookmarks.json";
    a.click();
    URL.revokeObjectURL(url);
    this.showToast("📤 ಬುಕ್‌ಮಾರ್ಕ್ ರಫ್ತು ಮಾಡಲಾಯಿತು");
  },

  clearBookmarks() {
    if (confirm("ಎಲ್ಲಾ ಉಳಿಸಿದ ಶ್ಲೋಕಗಳನ್ನು ಅಳಿಸಬೇಕೆ?\nDelete all saved shlokas?")) {
      BookmarkStorage.clearAll();
      this.updateBookmarkBadge();
      this.showToast("🗑️ ಎಲ್ಲಾ ಬುಕ್‌ಮಾರ್ಕ್ ಅಳಿಸಲಾಗಿದೆ");
      if (this.currentSection === "saved") {
        this.showSaved();
      }
      if (this.currentSection === "settings") {
        this.showSettings();
      }
    }
  },

  // ── Font Size ───────────────────────────────────────────────
  setFontSize(size) {
    document.documentElement.setAttribute("data-font-size", size);
    BookmarkStorage.setFontSize(size);
    document.querySelectorAll(".font-size-btn").forEach((btn) => {
      btn.classList.remove("active");
      if (btn.textContent.includes(size === "small" ? "ಸಣ್ಣ" : size === "large" ? "ದೊಡ್ಡ" : "ಮಧ್ಯಮ")) {
        btn.classList.add("active");
      }
    });
    this.showToast(
      size === "small"
        ? "🔤 ಸಣ್ಣ ಅಕ್ಷರ"
        : size === "large"
          ? "🔠 ದೊಡ್ಡ ಅಕ್ಷರ"
          : "🔡 ಮಧ್ಯಮ ಅಕ್ಷರ"
    );
  },

  // ── Script Filter ──────────────────────────────────────────
  renderScriptFilter() {
    return `
      <div class="script-filter">
        <span class="script-filter-label">ಲಿಪಿ · Script:</span>
        <button class="script-filter-btn ${this.scriptFilter === 'devanagari' ? 'active' : ''}"
                onclick="App.setScriptFilter('devanagari')">देवनागरी</button>
        <button class="script-filter-btn ${this.scriptFilter === 'kannada' ? 'active' : ''}"
                onclick="App.setScriptFilter('kannada')">ಕನ್ನಡ</button>
        <button class="script-filter-btn ${this.scriptFilter === 'both' ? 'active' : ''}"
                onclick="App.setScriptFilter('both')">ಎರಡೂ</button>
        <span class="script-filter-divider">|</span>
        <span class="script-filter-label">ಅರ್ಥ:</span>
        <button class="script-filter-btn ${this.showMeaning ? 'active' : ''}"
                onclick="App.toggleMeaning()">💡 ${this.showMeaning ? 'ಅರ್ಥ ✓' : 'ಅರ್ಥ ✗'}</button>
      </div>
    `;
  },

  setScriptFilter(filter) {
    this.scriptFilter = filter;
    BookmarkStorage.setScriptFilter(filter);
    this.handleRoute();
    this.showToast(
      filter === 'devanagari' ? '📜 देवनागरी ಮಾತ್ರ' :
      filter === 'kannada' ? '📝 ಕನ್ನಡ ಮಾತ್ರ' : '📜📝 ಎರಡೂ ಲಿಪಿ'
    );
  },

  toggleMeaning() {
    this.showMeaning = !this.showMeaning;
    BookmarkStorage.setShowMeaning(this.showMeaning);
    this.handleRoute();
    this.showToast(this.showMeaning ? '💡 ಅರ್ಥ ತೋರಿಸಲಾಗುತ್ತಿದೆ' : '📜 ಅರ್ಥ ಮರೆಮಾಡಲಾಗಿದೆ');
  },
};

// ── Start App ─────────────────────────────────────────────────
document.addEventListener("DOMContentLoaded", () => App.init());
