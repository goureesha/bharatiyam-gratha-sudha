/// Data models for scriptures (Gitas, Upanishads, Puranas, Smritis)
class ScriptureBook {
  final String id;
  final String title;
  final String titleEn;
  final String category; // 'gita', 'upanishad', 'purana', 'smriti'
  final String icon;
  final List<ScriptureChapter> chapters;

  const ScriptureBook({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.category,
    required this.icon,
    required this.chapters,
  });

  factory ScriptureBook.fromJson(Map<String, dynamic> json) {
    final chaptersList = (json['chapters'] as List<dynamic>?)
            ?.map((c) => ScriptureChapter.fromJson(Map<String, dynamic>.from(c)))
            .toList() ??
        [];
    return ScriptureBook(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      titleEn: json['titleEn'] ?? '',
      category: json['category'] ?? '',
      icon: json['icon'] ?? '',
      chapters: chaptersList,
    );
  }
}

class ScriptureChapter {
  final String id;
  final String title;
  final String content;

  const ScriptureChapter({
    required this.id,
    required this.title,
    required this.content,
  });

  factory ScriptureChapter.fromJson(Map<String, dynamic> json) {
    return ScriptureChapter(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
