import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stotra.dart';
import '../services/bookmark_service.dart';
import '../widgets/nudi_text.dart';

class ReaderScreen extends StatelessWidget {
  final Stotra stotra;
  const ReaderScreen({super.key, required this.stotra});

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkService>();
    final isBookmarked = bookmarks.isBookmarked(stotra.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fontFamily = stotra.font == 'brhknde' ? 'Brhknde' : 'Brhknd';

    return Scaffold(
      appBar: AppBar(
        title: NudiText(
          text: stotra.title,
          fontSize: 16,
          color: Colors.white,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          height: 1.3,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isBookmarked ? Colors.red : Colors.white,
            ),
            onPressed: () => bookmarks.toggle(stotra.id),
          ),
        ],
      ),
      body: Container(
        color: isDark ? const Color(0xFF0F0A1A) : const Color(0xFFFFF8EE),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: NudiText(
            text: stotra.content,
            fontFamily: fontFamily,
            fontSize: bookmarks.fontSize,
            height: fontFamily == 'Brhknde' ? 2.2 : 1.8,
            color: isDark ? const Color(0xFFE8D5B5) : const Color(0xFF2D1B00),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'zoomIn',
            onPressed: () => bookmarks.fontSize = bookmarks.fontSize + 2,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoomOut',
            onPressed: () => bookmarks.fontSize = bookmarks.fontSize - 2,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
