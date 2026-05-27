/// Data models for Bharatiyam Gratha Sudha
/// Includes Firestore serialization for Firebase integration

class SubCategory {
  final String id;
  final String title;
  final String titleEn;
  final String icon;

  const SubCategory({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.icon,
  });

  factory SubCategory.fromFirestore(Map<String, dynamic> json) => SubCategory(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    titleEn: json['titleEn'] ?? '',
    icon: json['icon'] ?? '',
  );

  Map<String, dynamic> toFirestore() => {
    'id': id, 'title': title, 'titleEn': titleEn, 'icon': icon,
  };
}

class AppCategory {
  final String id;
  final String title;
  final String titleEn;
  final String icon;
  final String description;
  final List<SubCategory> subcategories;

  const AppCategory({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.icon,
    required this.description,
    required this.subcategories,
  });

  factory AppCategory.fromFirestore(Map<String, dynamic> json) => AppCategory(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    titleEn: json['titleEn'] ?? '',
    icon: json['icon'] ?? '',
    description: json['description'] ?? '',
    subcategories: (json['subcategories'] as List<dynamic>?)
        ?.map((s) => SubCategory.fromFirestore(Map<String, dynamic>.from(s)))
        .toList() ?? [],
  );

  Map<String, dynamic> toFirestore() => {
    'id': id, 'title': title, 'titleEn': titleEn,
    'icon': icon, 'description': description,
    'subcategories': subcategories.map((s) => s.toFirestore()).toList(),
  };
}

class Shloka {
  final String id;
  final String number;
  final String sanskrit;
  final String kannada;
  final String meaning;
  final String? explanation;
  final bool isPremium;
  final int order;
  // Added when retrieved via helpers
  final String? bookId;
  final String? bookTitle;
  final String? bookTitleEn;
  final String? chapterTitle;
  final String? category;
  final String? subcategory;

  const Shloka({
    required this.id,
    required this.number,
    required this.sanskrit,
    required this.kannada,
    required this.meaning,
    this.explanation,
    this.isPremium = false,
    this.order = 0,
    this.bookId,
    this.bookTitle,
    this.bookTitleEn,
    this.chapterTitle,
    this.category,
    this.subcategory,
  });

  Shloka copyWith({
    String? bookId,
    String? bookTitle,
    String? bookTitleEn,
    String? chapterTitle,
    String? category,
    String? subcategory,
  }) {
    return Shloka(
      id: id,
      number: number,
      sanskrit: sanskrit,
      kannada: kannada,
      meaning: meaning,
      explanation: explanation,
      isPremium: isPremium,
      order: order,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      bookTitleEn: bookTitleEn ?? this.bookTitleEn,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'number': number, 'sanskrit': sanskrit,
    'kannada': kannada, 'meaning': meaning, 'explanation': explanation,
    'isPremium': isPremium, 'order': order,
    'bookId': bookId, 'bookTitle': bookTitle, 'bookTitleEn': bookTitleEn,
    'chapterTitle': chapterTitle, 'category': category, 'subcategory': subcategory,
  };

  factory Shloka.fromJson(Map<String, dynamic> json) => Shloka(
    id: json['id'] ?? '',
    number: json['number'] ?? '',
    sanskrit: json['sanskrit'] ?? '',
    kannada: json['kannada'] ?? '',
    meaning: json['meaning'] ?? '',
    explanation: json['explanation'],
    isPremium: json['isPremium'] ?? false,
    order: json['order'] ?? 0,
    bookId: json['bookId'],
    bookTitle: json['bookTitle'],
    bookTitleEn: json['bookTitleEn'],
    chapterTitle: json['chapterTitle'],
    category: json['category'],
    subcategory: json['subcategory'],
  );

  /// Alias for Firestore compatibility
  factory Shloka.fromFirestore(Map<String, dynamic> json) => Shloka.fromJson(json);
  Map<String, dynamic> toFirestore() => toJson();
}

class Chapter {
  final String id;
  final int number;
  final String title;
  final String titleSanskrit;
  final String titleEn;
  final int order;
  final List<Shloka> shlokas;

  const Chapter({
    required this.id,
    required this.number,
    required this.title,
    required this.titleSanskrit,
    required this.titleEn,
    this.order = 0,
    required this.shlokas,
  });

  factory Chapter.fromFirestore(Map<String, dynamic> json, {List<Shloka>? shlokas}) => Chapter(
    id: json['id'] ?? '',
    number: json['number'] ?? 0,
    title: json['title'] ?? '',
    titleSanskrit: json['titleSanskrit'] ?? '',
    titleEn: json['titleEn'] ?? '',
    order: json['order'] ?? 0,
    shlokas: shlokas ?? [],
  );

  Map<String, dynamic> toFirestore() => {
    'id': id, 'number': number, 'title': title,
    'titleSanskrit': titleSanskrit, 'titleEn': titleEn, 'order': order,
  };
}

class Book {
  final String id;
  final String title;
  final String titleSanskrit;
  final String titleEn;
  final String category;
  final String subcategory;
  final List<String> godRelated;
  final String description;
  final bool isPremium;
  final int order;
  final List<Chapter> chapters;

  const Book({
    required this.id,
    required this.title,
    required this.titleSanskrit,
    required this.titleEn,
    required this.category,
    required this.subcategory,
    required this.godRelated,
    required this.description,
    this.isPremium = false,
    this.order = 0,
    required this.chapters,
  });

  int get totalShlokas =>
      chapters.fold(0, (sum, ch) => sum + ch.shlokas.length);

  factory Book.fromFirestore(Map<String, dynamic> json, {List<Chapter>? chapters}) => Book(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    titleSanskrit: json['titleSanskrit'] ?? '',
    titleEn: json['titleEn'] ?? '',
    category: json['category'] ?? '',
    subcategory: json['subcategory'] ?? '',
    godRelated: List<String>.from(json['godRelated'] ?? []),
    description: json['description'] ?? '',
    isPremium: json['isPremium'] ?? false,
    order: json['order'] ?? 0,
    chapters: chapters ?? [],
  );

  Map<String, dynamic> toFirestore() => {
    'id': id, 'title': title, 'titleSanskrit': titleSanskrit,
    'titleEn': titleEn, 'category': category, 'subcategory': subcategory,
    'godRelated': godRelated, 'description': description,
    'isPremium': isPremium, 'order': order,
  };
}
