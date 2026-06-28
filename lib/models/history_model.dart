class HistoryEntry {
  final String expression;
  final String result;
  final DateTime timestamp;

  HistoryEntry({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'expression': expression,
        'result': result,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HistoryEntry.fromMap(Map<String, dynamic> map) => HistoryEntry(
        expression: map['expression'] as String,
        result: map['result'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
      );
}
