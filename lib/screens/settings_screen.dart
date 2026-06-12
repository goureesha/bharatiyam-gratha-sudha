import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/bookmark_service.dart';
import '../services/stotra_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkService>();
    final stotraService = context.watch<StotraService>();

    return Scaffold(
      appBar: AppBar(title: const Text('ಸೆಟ್ಟಿಂಗ್ಸ್')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Dark mode
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: const Text('ಡಾರ್ಕ್ ಮೋಡ್'),
              subtitle: const Text('Dark Mode'),
              secondary: const Icon(Icons.dark_mode_rounded),
              value: bookmarks.isDarkMode,
              onChanged: (v) => bookmarks.isDarkMode = v,
            ),
          ),
          const SizedBox(height: 8),

          // Font size
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.text_fields_rounded),
                      const SizedBox(width: 12),
                      const Text('ಅಕ್ಷರ ಗಾತ್ರ',
                          style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      Text('${bookmarks.fontSize.round()}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  Slider(
                    value: bookmarks.fontSize,
                    min: 14,
                    max: 36,
                    divisions: 11,
                    onChanged: (v) => bookmarks.fontSize = v,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Stats
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.library_books_rounded),
                    title: const Text('ಒಟ್ಟು ಸ್ತೋತ್ರಗಳು'),
                    trailing: Text('${stotraService.totalStotras}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.favorite_rounded, color: Colors.red),
                    title: const Text('ಉಳಿಸಿದ ಸ್ತೋತ್ರಗಳು'),
                    trailing: Text('${bookmarks.count}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Clear bookmarks
          if (bookmarks.count > 0)
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.delete_outline_rounded,
                    color: Colors.red),
                title: const Text('ಎಲ್ಲಾ ಬುಕ್‌ಮಾರ್ಕ್ ತೆಗೆ',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('ಖಚಿತವಾಗಿ?'),
                      content:
                          const Text('ಎಲ್ಲಾ ಉಳಿಸಿದ ಸ್ತೋತ್ರಗಳನ್ನು ತೆಗೆಯಬೇಕೇ?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('ಬೇಡ')),
                        TextButton(
                          onPressed: () {
                            bookmarks.clearAll();
                            Navigator.pop(ctx);
                          },
                          child: const Text('ಹೌದು',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 24),

          // About
          Center(
            child: Column(
              children: [
                Text('ಸ್ತೋತ್ರಮಾಲಾ v2.0',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5))),
                const SizedBox(height: 4),
                Text('🕉️ ಸರ್ವೇ ಜನಾಃ ಸುಖಿನೋ ಭವಂತು 🙏',
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
