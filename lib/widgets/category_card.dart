import 'package:flutter/material.dart';
import '../models/shloka.dart';
import '../theme/app_theme.dart';

/// Category grid card with icon, Kannada title, and English subtitle
class CategoryCard extends StatelessWidget {
  final SubCategory subcategory;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.subcategory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(subcategory.icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(subcategory.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(subcategory.titleEn,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
