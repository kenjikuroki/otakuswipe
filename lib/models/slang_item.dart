class SlangItem {
  final String word;        // 単語 (Maji)
  final String meaning;     // 意味 (Really?)
  final String explanation; // 解説
  final String imagePath;   // 画像パス
  final List<String> tags;  // タグ (Basic, Youth etc)
  final String usage;       // 使用シーン (Spoken, Text)
  final String? warning;    // 警告 (Rude etc) - null許容
  final String? example;    // 例文 - null許容

  SlangItem({
    required this.word,
    required this.meaning,
    required this.explanation,
    required this.imagePath,
    required this.tags,
    required this.usage,
    this.warning,
    this.example,
  });

  // JSONからクラスに変換する工場（ファクトリー）
  factory SlangItem.fromJson(Map<String, dynamic> json) {
    return SlangItem(
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
      explanation: json['explanation'] ?? '',
      imagePath: json['imagePath'] ?? '',
      // タグはリスト形式なので変換
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      usage: json['usage'] ?? 'General',
      warning: json['warning'], // nullならnullのまま
      example: json['example'],
    );
  }
}

// レベルごとのデータをまとめるクラス
class SlangData {
  final List<SlangItem> level1;
  final List<SlangItem> level2;
  final List<SlangItem> level3;
  final List<SlangItem> level4;
  final List<SlangItem> bonus;

  SlangData({
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.bonus,
  });

  factory SlangData.fromJson(Map<String, dynamic> json) {
    // ヘルパー関数: 指定キーのリストを読み込む
    List<SlangItem> parseList(String key) {
      return (json[key] as List<dynamic>?)
              ?.map((e) => SlangItem.fromJson(e))
              .toList() ??
          [];
    }

    return SlangData(
      level1: parseList('level1_survival'),
      level2: parseList('level2_otaku'),
      level3: parseList('level3_internet'),
      level4: parseList('level4_youth'),
      bonus: parseList('bonus_persona'),
    );
  }
}
