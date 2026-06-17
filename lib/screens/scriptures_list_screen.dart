import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/scripture_service.dart';
import '../services/stotra_service.dart';
import '../models/scripture.dart';
import '../models/stotra.dart';
import 'reader_screen.dart';
import 'scripture_chapters_screen.dart';
import 'category_screen.dart';

class ScripturesListScreen extends StatelessWidget {
  final String categoryId;
  final String categoryTitle;

  const ScripturesListScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    final scriptureService = context.watch<ScriptureService>();
    final stotraService = context.watch<StotraService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Build the list of books in this category
    final books = <LibraryBookItem>[];

    if (categoryId == 'gita') {
      // New Gitas from ScriptureService
      final gitabooks = scriptureService.getByCategory('gita');
      for (final b in gitabooks) {
        books.add(LibraryBookItem(
          id: b.id,
          title: b.title,
          subtitle: b.titleEn,
          icon: b.icon,
          source: 'scripture_service',
          chapterCount: b.chapters.length,
          originalObject: b,
        ));
      }
      // Existing Uddhava Gita from StotraService
      final uddhava = stotraService.getCategory('uddhava_gita');
      if (uddhava != null) {
        books.add(LibraryBookItem(
          id: uddhava.id,
          title: uddhava.title,
          subtitle: uddhava.titleEn,
          icon: uddhava.icon,
          source: 'stotra_service',
          chapterCount: uddhava.stotras.length,
          originalObject: uddhava,
        ));
      }
    } else if (categoryId == 'upanishad') {
      final upanishads = scriptureService.getByCategory('upanishad');
      for (final b in upanishads) {
        books.add(LibraryBookItem(
          id: b.id,
          title: b.title,
          subtitle: b.titleEn,
          icon: b.icon,
          source: 'scripture_service',
          chapterCount: b.chapters.length,
          originalObject: b,
        ));
      }
    } else if (categoryId == 'purana') {
      // New Puranas from ScriptureService
      final puranabooks = scriptureService.getByCategory('purana');
      for (final b in puranabooks) {
        books.add(LibraryBookItem(
          id: b.id,
          title: b.title,
          subtitle: b.titleEn,
          icon: b.icon,
          source: 'scripture_service',
          chapterCount: b.chapters.length,
          originalObject: b,
        ));
      }
      // Existing Puranas from StotraService
      final existingPuranas = [
        'kartika_purana',
        'magha_purana',
        'narayaneeyam',
        'devi_narayaneeyam'
      ];
      for (final id in existingPuranas) {
        final cat = stotraService.getCategory(id);
        if (cat != null) {
          books.add(LibraryBookItem(
            id: cat.id,
            title: cat.title,
            subtitle: cat.titleEn,
            icon: cat.icon,
            source: 'stotra_service',
            chapterCount: cat.stotras.length,
            originalObject: cat,
          ));
        }
      }
    } else if (categoryId == 'smriti') {
      final smritis = scriptureService.getByCategory('smriti');
      for (final b in smritis) {
        books.add(LibraryBookItem(
          id: b.id,
          title: b.title,
          subtitle: b.titleEn,
          icon: b.icon,
          source: 'scripture_service',
          chapterCount: b.chapters.length,
          originalObject: b,
        ));
      }
    } else if (categoryId == 'charitra') {
      final existingCharitras = ['guru_charitra', 'harikathamrutasara'];
      for (final id in existingCharitras) {
        final cat = stotraService.getCategory(id);
        if (cat != null) {
          books.add(LibraryBookItem(
            id: cat.id,
            title: cat.title,
            subtitle: cat.titleEn,
            icon: cat.icon,
            source: 'stotra_service',
            chapterCount: cat.stotras.length,
            originalObject: cat,
          ));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle, style: const TextStyle(fontSize: 18)),
      ),
      body: books.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF120C24) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.06)
                          : Colors.grey.withOpacity(0.12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.25 : 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        book.icon,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    title: Text(
                      book.title,
                      style: GoogleFonts.notoSansKannada(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${book.subtitle} · ${book.chapterCount} ಅಧ್ಯಾಯಗಳು',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () {
                      if (book.chapterCount == 1 && book.source == 'scripture_service') {
                        // Single chapter book (like short Upanishad) - navigate directly to reader
                        final scriptureBook = book.originalObject as ScriptureBook;
                        final chapter = scriptureBook.chapters[0];
                        // Map ScriptureChapter to Stotra
                        final stotra = Stotra(
                          id: chapter.id,
                          title: scriptureBook.title,
                          content: chapter.content,
                          font: 'brhknd',
                          isUnicode: true,
                          categoryId: scriptureBook.id,
                          categoryTitle: scriptureBook.title,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReaderScreen(stotra: stotra),
                          ),
                        );
                      } else if (book.source == 'scripture_service') {
                        // Multi-chapter scripture book
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ScriptureChaptersScreen(
                              book: book.originalObject as ScriptureBook,
                            ),
                          ),
                        );
                      } else {
                        // StotraService category (like Kartika Purana, Guru Charitra)
                        final category = book.originalObject as StotraCategory;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryScreen(category: category),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}

class LibraryBookItem {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final String source;
  final int chapterCount;
  final dynamic originalObject;

  LibraryBookItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.source,
    required this.chapterCount,
    required this.originalObject,
  });
}
