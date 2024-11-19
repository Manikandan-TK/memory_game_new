// Enum for different difficulty levels
enum GameDifficulty {
  easy,
  medium,
  hard;

  // Get grid configuration based on difficulty
  (int rows, int columns) get gridSize {
    switch (this) {
      case GameDifficulty.easy:
        return (4, 4); // 16 cards (8 pairs)
      case GameDifficulty.medium:
        return (6, 4); // 24 cards (12 pairs)
      case GameDifficulty.hard:
        return (12, 4); // 48 cards (24 pairs)
    }
  }

  // Get number of pairs based on difficulty
  int get numberOfPairs {
    final (rows, columns) = gridSize;
    return (rows * columns) ~/ 2;
  }

  // Get display name for the difficulty level
  String get displayName {
    switch (this) {
      case GameDifficulty.easy:
        return 'Easy (4x4)';
      case GameDifficulty.medium:
        return 'Medium (6x4)';
      case GameDifficulty.hard:
        return 'Hard (12x4)';
    }
  }
}

// Immutable configuration class for game settings
class GameConfig {
  final GameDifficulty difficulty;
  final bool timerEnabled;
  final Duration? timeLimit;

  const GameConfig({
    required this.difficulty,
    this.timerEnabled = true,
    this.timeLimit,
  });

  // Named constructor for default configuration
  const GameConfig.defaultConfig()
      : difficulty = GameDifficulty.easy,
        timerEnabled = true,
        timeLimit = null;

  // Copy with method for immutability
  GameConfig copyWith({
    GameDifficulty? difficulty,
    bool? timerEnabled,
    Duration? timeLimit,
  }) {
    return GameConfig(
      difficulty: difficulty ?? this.difficulty,
      timerEnabled: timerEnabled ?? this.timerEnabled,
      timeLimit: timeLimit ?? this.timeLimit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameConfig &&
          runtimeType == other.runtimeType &&
          difficulty == other.difficulty &&
          timerEnabled == other.timerEnabled &&
          timeLimit == other.timeLimit;

  @override
  int get hashCode =>
      difficulty.hashCode ^ timerEnabled.hashCode ^ timeLimit.hashCode;
}
