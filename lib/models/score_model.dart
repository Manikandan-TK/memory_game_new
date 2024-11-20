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

  // Calculate moves per second (efficiency metric)
  double get movesPerSecond => 
    time.inSeconds == 0 ? 0 : moves / time.inSeconds;

  // Calculate matches found (moves / 2 since each match takes 2 moves)
  int get matchesFound => (moves / 2).floor();

  // Calculate average time per match
  double get averageTimePerMatch =>
    matchesFound == 0 ? 0 : time.inSeconds / matchesFound;

  // Get formatted time string (e.g., "1:30")
  String get formattedTime {
    final minutes = time.inMinutes;
    final seconds = time.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

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

  @override
  String toString() => 
    'Score(value: $value, moves: $moves, time: $formattedTime, difficulty: $difficulty)';

  // Helper method to create a copy with modified fields
  Score copyWith({
    int? value,
    int? moves,
    Duration? time,
    DateTime? timestamp,
    String? difficulty,
  }) => Score(
    value: value ?? this.value,
    moves: moves ?? this.moves,
    time: time ?? this.time,
    timestamp: timestamp ?? this.timestamp,
    difficulty: difficulty ?? this.difficulty,
  );
}
