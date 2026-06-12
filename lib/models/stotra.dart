/// Data models for Stotramala app
class StotraCategory {
  final String id;
  final String title;
  final String titleEn;
  final String icon;
  final int count;
  final List<Stotra> stotras;

  const StotraCategory({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.icon,
    required this.count,
    required this.stotras,
  });

  factory StotraCategory.fromJson(Map<String, dynamic> json) {
    final stotras = (json['stotras'] as List<dynamic>?)
        ?.map((s) => Stotra.fromJson(
              Map<String, dynamic>.from(s),
              categoryId: json['id'] ?? '',
              categoryTitle: json['title'] ?? '',
            ))
        .toList() ?? [];
    return StotraCategory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      titleEn: json['titleEn'] ?? '',
      icon: json['icon'] ?? '',
      count: json['count'] ?? stotras.length,
      stotras: stotras,
    );
  }
}

class Stotra {
  final String id;
  final String title;
  final String content;
  final String font;
  final String categoryId;
  final String categoryTitle;

  const Stotra({
    required this.id,
    required this.title,
    required this.content,
    required this.font,
    required this.categoryId,
    required this.categoryTitle,
  });

  factory Stotra.fromJson(
    Map<String, dynamic> json, {
    String categoryId = '',
    String categoryTitle = '',
  }) {
    return Stotra(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      font: json['font'] ?? 'brhknd',
      categoryId: categoryId,
      categoryTitle: categoryTitle,
    );
  }
}
