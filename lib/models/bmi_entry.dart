class BmiEntry {
  final String id;
  final double bmi;
  final double weight;
  final double height;
  final String unitSystem;
  final String category;
  final DateTime createdAt;

  const BmiEntry({
    required this.id,
    required this.bmi,
    required this.weight,
    required this.height,
    required this.unitSystem,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'bmi': bmi,
        'weight': weight,
        'height': height,
        'unitSystem': unitSystem,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
      };

  factory BmiEntry.fromJson(Map<String, dynamic> json) => BmiEntry(
        id: json['id'] as String,
        bmi: (json['bmi'] as num).toDouble(),
        weight: (json['weight'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        unitSystem: json['unitSystem'] as String,
        category: json['category'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
