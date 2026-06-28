class FavoriteEntry {
  final String expression;
  final String result;
  final String label;
  final DateTime savedAt;

  FavoriteEntry({
    required this.expression,
    required this.result,
    this.label = '',
    required this.savedAt,
  });

  Map<String, dynamic> toMap() => {
        'expression': expression,
        'result': result,
        'label': label,
        'savedAt': savedAt.toIso8601String(),
      };

  factory FavoriteEntry.fromMap(Map<String, dynamic> map) => FavoriteEntry(
        expression: map['expression'] as String,
        result: map['result'] as String,
        label: map['label'] as String? ?? '',
        savedAt: DateTime.parse(map['savedAt'] as String),
      );
}
