// ============================================================
// Bharatiyam Gratha Sudha — Bookmark Storage
// ============================================================

const BookmarkStorage = {
  STORAGE_KEY: "bharatiyam_bookmarks",
  SETTINGS_KEY: "bharatiyam_settings",

  // ── Bookmarks ───────────────────────────────────────────────

  getAll() {
    try {
      const data = localStorage.getItem(this.STORAGE_KEY);
      return data ? JSON.parse(data) : {};
    } catch (e) {
      console.error("Error reading bookmarks:", e);
      return {};
    }
  },

  isBookmarked(shlokaId) {
    const bookmarks = this.getAll();
    return !!bookmarks[shlokaId];
  },

  toggle(shlokaId, shlokaData) {
    const bookmarks = this.getAll();
    if (bookmarks[shlokaId]) {
      delete bookmarks[shlokaId];
    } else {
      bookmarks[shlokaId] = {
        ...shlokaData,
        savedAt: new Date().toISOString(),
      };
    }
    this._save(bookmarks);
    return !!bookmarks[shlokaId];
  },

  save(shlokaId, shlokaData) {
    const bookmarks = this.getAll();
    bookmarks[shlokaId] = {
      ...shlokaData,
      savedAt: new Date().toISOString(),
    };
    this._save(bookmarks);
  },

  remove(shlokaId) {
    const bookmarks = this.getAll();
    delete bookmarks[shlokaId];
    this._save(bookmarks);
  },

  getSavedShlokas() {
    const bookmarks = this.getAll();
    return Object.values(bookmarks).sort(
      (a, b) => new Date(b.savedAt) - new Date(a.savedAt)
    );
  },

  getCount() {
    return Object.keys(this.getAll()).length;
  },

  exportAsJSON() {
    return JSON.stringify(this.getAll(), null, 2);
  },

  importFromJSON(jsonString) {
    try {
      const data = JSON.parse(jsonString);
      const existing = this.getAll();
      const merged = { ...existing, ...data };
      this._save(merged);
      return true;
    } catch (e) {
      console.error("Error importing bookmarks:", e);
      return false;
    }
  },

  clearAll() {
    localStorage.removeItem(this.STORAGE_KEY);
  },

  _save(bookmarks) {
    try {
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(bookmarks));
    } catch (e) {
      console.error("Error saving bookmarks:", e);
    }
  },

  // ── Settings ────────────────────────────────────────────────

  getSettings() {
    try {
      const data = localStorage.getItem(this.SETTINGS_KEY);
      return data
        ? JSON.parse(data)
        : {
            theme: "light",
            fontSize: "medium",
            showExplanation: true,
            language: "kn",
          };
    } catch (e) {
      return {
        theme: "light",
        fontSize: "medium",
        showExplanation: true,
        language: "kn",
      };
    }
  },

  saveSettings(settings) {
    try {
      localStorage.setItem(this.SETTINGS_KEY, JSON.stringify(settings));
    } catch (e) {
      console.error("Error saving settings:", e);
    }
  },

  getTheme() {
    return this.getSettings().theme || "light";
  },

  setTheme(theme) {
    const settings = this.getSettings();
    settings.theme = theme;
    this.saveSettings(settings);
  },

  getFontSize() {
    return this.getSettings().fontSize || "medium";
  },

  setFontSize(size) {
    const settings = this.getSettings();
    settings.fontSize = size;
    this.saveSettings(settings);
  },

  getScriptFilter() {
    return this.getSettings().scriptFilter || "both";
  },

  setScriptFilter(filter) {
    const settings = this.getSettings();
    settings.scriptFilter = filter;
    this.saveSettings(settings);
  },

  getShowMeaning() {
    const val = this.getSettings().showMeaning;
    return val !== undefined ? val : true;
  },

  setShowMeaning(show) {
    const settings = this.getSettings();
    settings.showMeaning = show;
    this.saveSettings(settings);
  },
};
