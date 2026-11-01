import 'package:flutter/material.dart';

class SvaraCatalog {
  final String version;
  final int totalItems;
  final List<SvaraCategory> categories;

  const SvaraCatalog({
    required this.version,
    required this.totalItems,
    required this.categories,
  });

  factory SvaraCatalog.fromJson(Map<String, dynamic> json) {
    return SvaraCatalog(
      version: json['version'] ?? '1.0',
      totalItems: json['total_items'] ?? 0,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((c) => SvaraCategory.fromJson(Map<String, dynamic>.from(c)))
              .toList() ??
          [],
    );
  }
}

class SvaraCategory {
  final String id;
  final String title;
  final String englishTitle;
  final String subtitle;
  final String icon;
  final Color color;
  final int count;
  final List<SvaraSubgroup> subgroups;
  final List<SvaraItemMeta> items;

  const SvaraCategory({
    required this.id,
    required this.title,
    required this.englishTitle,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.count,
    this.subgroups = const [],
    this.items = const [],
  });

  factory SvaraCategory.fromJson(Map<String, dynamic> json) {
    final colorHex = json['color'] as String? ?? '0xFFD97706';
    final parsedColor = Color(int.tryParse(colorHex) ?? 0xFFD97706);

    return SvaraCategory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      englishTitle: json['englishTitle'] ?? '',
      subtitle: json['subtitle'] ?? '',
      icon: json['icon'] ?? 'self_improvement',
      color: parsedColor,
      count: json['count'] ?? 0,
      subgroups: (json['subgroups'] as List<dynamic>?)
              ?.map((g) => SvaraSubgroup.fromJson(Map<String, dynamic>.from(g)))
              .toList() ??
          [],
      items: (json['items'] as List<dynamic>?)
              ?.map((m) => SvaraItemMeta.fromJson(Map<String, dynamic>.from(m)))
              .toList() ??
          [],
    );
  }

  IconData get iconData {
    switch (icon) {
      case 'self_improvement':
        return Icons.self_improvement_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'spa':
        return Icons.spa_rounded;
      case 'shield':
        return Icons.shield_rounded;
      case 'local_fire_department':
        return Icons.local_fire_department_rounded;
      case 'flare':
        return Icons.flare_rounded;
      default:
        return Icons.auto_stories_rounded;
    }
  }
}

class SvaraSubgroup {
  final String id;
  final String title;
  final int count;
  final List<String> itemIds;

  const SvaraSubgroup({
    required this.id,
    required this.title,
    required this.count,
    required this.itemIds,
  });

  factory SvaraSubgroup.fromJson(Map<String, dynamic> json) {
    return SvaraSubgroup(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      count: json['count'] ?? 0,
      itemIds: (json['itemIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class SvaraItemMeta {
  final String id;
  final String title;
  final String categoryId;
  final String categoryTitle;
  final String type;
  final int svaraCount;
  final int charLength;

  const SvaraItemMeta({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.categoryTitle,
    required this.type,
    required this.svaraCount,
    required this.charLength,
  });

  factory SvaraItemMeta.fromJson(Map<String, dynamic> json) {
    return SvaraItemMeta(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryTitle: json['categoryTitle'] ?? '',
      type: json['type'] ?? 'mantra',
      svaraCount: json['svara_count'] ?? 0,
      charLength: json['char_length'] ?? 0,
    );
  }
}
