import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scripture.dart';
import '../models/stotra.dart';
import 'reader_screen.dart';

class ScriptureChaptersScreen extends StatelessWidget {
  final ScriptureBook book;

  const ScriptureChaptersScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${book.icon} ${book.title}', style: const TextStyle(fontSize: 18)),
            Text('${book.chapters.length} ಅಧ್ಯಾಯಗಳು',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: book.chapters.length,
        itemBuilder: (context, index) {
          final chapter = book.chapters[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF120C24) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey.withOpacity(0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              title: Text(
                chapter.title,
                style: GoogleFonts.notoSansKannada(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              ),
              onTap: () {
                // Map ScriptureChapter to Stotra so we can use the existing ReaderScreen!
                final stotra = Stotra(
                  id: chapter.id,
                  title: '${book.title} - ${chapter.title}',
                  content: chapter.content,
                  font: 'brhknd',
                  isUnicode: true,
                  categoryId: book.id,
                  categoryTitle: book.title,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReaderScreen(stotra: stotra),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
