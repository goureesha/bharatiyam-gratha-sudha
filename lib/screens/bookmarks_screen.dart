import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/stotra_service.dart';
import '../services/bookmark_service.dart';
import '../models/stotra.dart';
import '../widgets/nudi_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reader_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stotraService = context.watch<StotraService>();
    final bookmarks = context.watch<BookmarkService>();

    if (!stotraService.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final bookmarkedStotras = <Stotra>[];
    for (final id in bookmarks.bookmarkedIds) {
      final stotra = stotraService.getStotra(id);
      if (stotra != null) bookmarkedStotras.add(stotra);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ಉಳಿಸಿದ ಸ್ತೋತ್ರಗಳು')),
      body: bookmarkedStotras.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('ಯಾವುದೇ ಸ್ತೋತ್ರ ಉಳಿಸಿಲ್ಲ',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('♥ ಬಟನ್ ಒತ್ತಿ ಸ್ತೋತ್ರವನ್ನು ಉಳಿಸಿ',
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
                    title: stotra.font == 'brhknde'
                        ? NudiText(
                            text: stotra.title,
                            fontSize: 15,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            height: 1.3,
                          )
                        : Text(
                            stotra.title,
                            style: GoogleFonts.notoSansKannada(
                              fontSize: 15,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
