class Score {
  final int value;
  final int moves;
  final Duration time;
  final DateTime timestamp;
  final String difficulty;

  const Score({
    required this.value,
    required this.moves,
    required this.time,
    required this.timestamp,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() => {
    'value': value,
    'moves': moves,
    'time': time.inSeconds,
    'timestamp': timestamp.toIso8601String(),
    'difficulty': difficulty,
  };

  factory Score.fromJson(Map<String, dynamic> json) => Score(
    value: json['value'] as int,
    moves: json['moves'] as int,
    time: Duration(seconds: json['time'] as int),
    timestamp: DateTime.parse(json['timestamp'] as String),
    difficulty: json['difficulty'] as String,
  );
}
