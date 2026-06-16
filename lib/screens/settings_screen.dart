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

          // Color Theme Selector
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.palette_rounded),
                      const SizedBox(width: 12),
                      const Text('ಬಣ್ಣದ ಥೀಮ್', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ThemeOption(
                        color: const Color(0xFFE8722A),
                        name: 'ಕೇಸರಿ',
                        isSelected: bookmarks.themeColorIndex == 0,
                        onTap: () => bookmarks.themeColorIndex = 0,
                      ),
                      _ThemeOption(
                        color: const Color(0xFF8B1A2B),
                        name: 'ಮರೂನ್',
                        isSelected: bookmarks.themeColorIndex == 1,
                        onTap: () => bookmarks.themeColorIndex = 1,
                      ),
                      _ThemeOption(
                        color: const Color(0xFF0A6E90),
                        name: 'ನೀಲಿ',
                        isSelected: bookmarks.themeColorIndex == 2,
                        onTap: () => bookmarks.themeColorIndex = 2,
                      ),
                      _ThemeOption(
                        color: const Color(0xFF1E5C3F),
                        name: 'ಹಸಿರು',
                        isSelected: bookmarks.themeColorIndex == 3,
                        onTap: () => bookmarks.themeColorIndex = 3,
                      ),
                    ],
                  ),
                ],
              ),
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
                Text('ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ v2.0 (Build 2a81d94)',
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

class _ThemeOption extends StatelessWidget {
  final Color color;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.color,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? (isDark ? Colors.white : Colors.black87)
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 24)
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
