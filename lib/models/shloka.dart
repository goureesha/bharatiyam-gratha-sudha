/// Data models for Bharatiyam Gratha Sudha

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
}

class Shloka {
  final String id;
  final String number;
  final String sanskrit;
  final String kannada;
  final String meaning;
  final String? explanation;
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
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      bookTitleEn: bookTitleEn ?? this.bookTitleEn,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'sanskrit': sanskrit,
    'kannada': kannada,
    'meaning': meaning,
    'explanation': explanation,
    'bookId': bookId,
    'bookTitle': bookTitle,
    'bookTitleEn': bookTitleEn,
    'chapterTitle': chapterTitle,
    'category': category,
    'subcategory': subcategory,
  };

  factory Shloka.fromJson(Map<String, dynamic> json) => Shloka(
    id: json['id'] ?? '',
    number: json['number'] ?? '',
    sanskrit: json['sanskrit'] ?? '',
    kannada: json['kannada'] ?? '',
    meaning: json['meaning'] ?? '',
    explanation: json['explanation'],
    bookId: json['bookId'],
    bookTitle: json['bookTitle'],
    bookTitleEn: json['bookTitleEn'],
    chapterTitle: json['chapterTitle'],
    category: json['category'],
    subcategory: json['subcategory'],
  );
}

class Chapter {
  final String id;
  final int number;
  final String title;
  final String titleSanskrit;
  final String titleEn;
  final List<Shloka> shlokas;

  const Chapter({
    required this.id,
    required this.number,
    required this.title,
    required this.titleSanskrit,
    required this.titleEn,
    required this.shlokas,
  });
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
    required this.chapters,
  });

  int get totalShlokas =>
      chapters.fold(0, (sum, ch) => sum + ch.shlokas.length);
}
