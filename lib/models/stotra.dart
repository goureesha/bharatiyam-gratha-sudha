/// Data models for Bharatiyam Grantha Sudha app
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

  List<Stotra> get shlokas =>
      stotras.where((s) => s.type == 'shloka').toList();

  List<Stotra> get mantras =>
      stotras.where((s) => s.type == 'mantra').toList();

  List<Stotra> get bhajanas =>
      stotras.where((s) => s.type == 'bhajana').toList();

  bool get hasSubTypes =>
      stotras.any((s) => s.type == 'mantra' || s.type == 'bhajana');

  factory StotraCategory.fromJson(Map<String, dynamic> json) {
    final stotras = (json['stotras'] as List<dynamic>?)
            ?.map((s) => Stotra.fromJson(
                  Map<String, dynamic>.from(s),
                  categoryId: json['id'] ?? '',
                  categoryTitle: json['title'] ?? '',
                ))
            .toList() ??
        [];
    return StotraCategory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      titleEn: json['titleEn'] ?? json['englishTitle'] ?? '',
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
  final bool isUnicode;
  final String categoryId;
  final String categoryTitle;
  final String type; // 'shloka', 'mantra', or 'bhajana'

  const Stotra({
    required this.id,
    required this.title,
    required this.content,
    required this.font,
    required this.isUnicode,
    required this.categoryId,
    required this.categoryTitle,
    this.type = 'shloka',
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
      isUnicode: json['unicode'] == true,
      categoryId: categoryId,
      categoryTitle: categoryTitle,
      type: json['type'] ?? 'shloka',
    );
  }
}
