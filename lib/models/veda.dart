/// Models for Veda texts in Bharatiyam Grantha Sudha app

// ===================== YAJURVEDA MODELS =====================

class VedaAnuvaka {
  final int number;
  final String content;

  const VedaAnuvaka({
    required this.number,
    required this.content,
  });

  factory VedaAnuvaka.fromJson(Map<String, dynamic> json) {
    return VedaAnuvaka(
      number: json['number'] as int,
      content: json['content'] as String,
    );
  }
}

class VedaChapter {
  final String title;
  final List<VedaAnuvaka> anuvakas;

  const VedaChapter({
    required this.title,
    required this.anuvakas,
  });

  factory VedaChapter.fromJson(Map<String, dynamic> json) {
    final anuvakasData = json['anuvakas'] as List<dynamic>?;
    final anuvakas = anuvakasData
            ?.map((e) => VedaAnuvaka.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];
    return VedaChapter(
      title: json['title'] as String,
      anuvakas: anuvakas,
    );
  }
}

class VedaSection {
  final String title;
  final List<VedaChapter> chapters;

  const VedaSection({
    required this.title,
    required this.chapters,
  });

  factory VedaSection.fromJson(Map<String, dynamic> json) {
    final chaptersData = json['chapters'] as List<dynamic>?;
    final chapters = chaptersData
            ?.map((e) => VedaChapter.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];
    return VedaSection(
      title: json['title'] as String,
      chapters: chapters,
    );
  }
}

class VedaBook {
  final String title;
  final List<VedaSection> sections;

  const VedaBook({
    required this.title,
    required this.sections,
  });

  factory VedaBook.fromJson(Map<String, dynamic> json) {
    final sectionsData = json['sections'] as List<dynamic>?;
    final sections = sectionsData
            ?.map((e) => VedaSection.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];
    return VedaBook(
      title: json['title'] as String,
      sections: sections,
    );
  }
}

// ===================== RIGVEDA MODELS =====================

class RigMantra {
  final int number;
  final String samhita;
  final String pada;
  final String rishiDev;
  final String numbering;

  const RigMantra({
    required this.number,
    required this.samhita,
    required this.pada,
    required this.rishiDev,
    required this.numbering,
  });

  factory RigMantra.fromJson(Map<String, dynamic> json) {
    return RigMantra(
      number: json['number'] as int? ?? 0,
      samhita: json['samhita'] as String? ?? '',
      pada: json['pada'] as String? ?? '',
      rishiDev: json['rishi_dev'] as String? ?? '',
      numbering: json['numbering'] as String? ?? '',
    );
  }
}

class RigSukta {
  final String label;
  final List<RigMantra> mantras;

  const RigSukta({
    required this.label,
    required this.mantras,
  });

  factory RigSukta.fromJson(Map<String, dynamic> json) {
    final mantrasData = json['mantras'] as List<dynamic>?;
    final mantras = mantrasData
            ?.map((e) => RigMantra.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];
    return RigSukta(
      label: json['label'] as String? ?? '',
      mantras: mantras,
    );
  }
}

class RigMandala {
  final String title;
  final List<RigSukta> suktas;

  const RigMandala({
    required this.title,
    required this.suktas,
  });

  factory RigMandala.fromJson(Map<String, dynamic> json) {
    final suktasData = json['suktas'] as List<dynamic>?;
    final suktas = suktasData
            ?.map((e) => RigSukta.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];
    return RigMandala(
      title: json['title'] as String? ?? '',
      suktas: suktas,
    );
  }
}

// ===================== ASHTAKA MODELS =====================

class RigAshtaka {
  final int number;
  final List<RigAdhyaya> adhyayas;

  const RigAshtaka({
    required this.number,
    required this.adhyayas,
  });
}

class RigAdhyaya {
  final int number;
  final List<RigVarga> vargas;

  const RigAdhyaya({
    required this.number,
    required this.vargas,
  });
}

class RigVarga {
  final int number;
  final List<RigMantra> mantras;

  const RigVarga({
    required this.number,
    required this.mantras,
  });
}
