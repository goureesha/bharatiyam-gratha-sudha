import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/stotra_service.dart';
import '../services/bookmark_service.dart';
import '../services/scripture_service.dart';
import '../models/stotra.dart';
import '../widgets/nudi_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reader_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stotraService = context.watch<StotraService>();
    final scriptureService = context.watch<ScriptureService>();
    final bookmarks = context.watch<BookmarkService>();

    if (!stotraService.isLoaded || !scriptureService.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final bookmarkedStotras = <Stotra>[];
    for (final id in bookmarks.bookmarkedIds) {
      final stotra = stotraService.getStotra(id);
      if (stotra != null) {
        bookmarkedStotras.add(stotra);
      } else {
        // Search in ScriptureService
        for (final book in scriptureService.books) {
          for (final chapter in book.chapters) {
            if (chapter.id == id) {
              bookmarkedStotras.add(Stotra(
                id: chapter.id,
                title: book.chapters.length == 1 ? book.title : '${book.title} - ${chapter.title}',
                content: chapter.content,
                font: 'brhknd',
                isUnicode: true,
                categoryId: book.id,
                categoryTitle: book.title,
              ));
              break;
            }
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ಉಳಿಸಿದವು')),
      body: bookmarkedStotras.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('ಯಾವುದೇ ಗ್ರಂಥ ಅಥವಾ ಸ್ತೋತ್ರ ಉಳಿಸಿಲ್ಲ',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('♥ ಬಟನ್ ಒತ್ತಿ ವಿಷಯವನ್ನು ಉಳಿಸಿ',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: bookmarkedStotras.length,
              itemBuilder: (context, index) {
                final stotra = bookmarkedStotras[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Icon(Icons.favorite_rounded,
                        color: Colors.red.shade300, size: 22),
                    title: stotra.isUnicode
                        ? Text(
                            stotra.title,
                            style: GoogleFonts.notoSansKannada(
                              fontSize: 15,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : NudiText(
                            text: stotra.title,
                            fontSize: 15,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            height: 1.3,
                          ),
                    subtitle: Text(stotra.categoryTitle,
                        style: const TextStyle(fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => bookmarks.toggle(stotra.id),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ReaderScreen(stotra: stotra)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
