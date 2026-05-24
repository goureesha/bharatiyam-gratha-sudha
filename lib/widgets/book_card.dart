import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/shloka.dart';
import '../theme/app_theme.dart';

/// Book list card showing title, Sanskrit title, description, and stats
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Book icon
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('📖', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              // Book info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(book.titleSanskrit,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.textSanskritDark : AppTheme.textSanskritLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(book.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text('${book.chapters.length} ಅಧ್ಯಾಯ · ${book.totalShlokas} ಶ್ಲೋಕ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
