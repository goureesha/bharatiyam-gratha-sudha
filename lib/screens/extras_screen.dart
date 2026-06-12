import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/stotra_service.dart';
import '../models/stotra.dart';
import 'category_screen.dart';

class ExtrasScreen extends StatelessWidget {
  const ExtrasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stotraService = context.watch<StotraService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final extras = stotraService.extrasCategories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ಇನ್ನಷ್ಟು ವಿಭಾಗಗಳು'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: extras.length,
        itemBuilder: (context, index) {
          final cat = extras[index];
          return Material(
            borderRadius: BorderRadius.circular(14),
            color: isDark ? const Color(0xFF1A1130) : Colors.white,
            elevation: 1.5,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CategoryScreen(category: cat)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFFD4A843).withOpacity(0.15)
                        : const Color(0xFFE8722A).withOpacity(0.1),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cat.icon, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 6),
                    Text(
                      cat.title,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${cat.stotras.length}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
