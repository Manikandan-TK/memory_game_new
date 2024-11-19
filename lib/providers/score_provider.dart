import 'package:flutter/foundation.dart';
import '../models/score_model.dart';
import '../models/game_config.dart';

class ScoreProvider extends ChangeNotifier {
  Score? _currentScore;
  Score? get currentScore => _currentScore;
  
  List<Score> _highScores = [];
  List<Score> get highScores => List.unmodifiable(_highScores);

  // Scoring multipliers
  static const double _baseScore = 1000.0;
  static const double _movesPenalty = 10.0;
  static const double _timePenaltyPerSecond = 2.0;
  
  // Difficulty multipliers
  static const Map<GameDifficulty, double> _difficultyMultipliers = {
    GameDifficulty.easy: 1.0,
    GameDifficulty.medium: 1.5,
    GameDifficulty.hard: 2.0,
  };

  void calculateScore({
    required int moves,
    required Duration time,
    required GameDifficulty difficulty,
  }) {
    final difficultyMultiplier = _difficultyMultipliers[difficulty] ?? 1.0;
    
    // Calculate base score with penalties
    double score = _baseScore;
    score -= moves * _movesPenalty;
    score -= time.inSeconds * _timePenaltyPerSecond;
    
    // Apply difficulty multiplier
    score *= difficultyMultiplier;
    
    // Ensure minimum score of 0
    score = score.clamp(0.0, double.infinity);
    
    _currentScore = Score(
      value: score.round(),
      moves: moves,
      time: time,
      timestamp: DateTime.now(),
      difficulty: difficulty.toString().split('.').last,
    );
    
    if (_currentScore!.value > 0) {
      _updateHighScores();
    }
  }

  void _updateHighScores() {
    if (_currentScore == null) return;
    
    _highScores.add(_currentScore!);
    _highScores.sort((a, b) => b.value.compareTo(a.value));
    
    // Keep only top 10 scores
    if (_highScores.length > 10) {
      _highScores = _highScores.sublist(0, 10);
    }
  }

  void updateCurrentScore({
    required int moves,
    required Duration time,
    required GameDifficulty difficulty,
  }) {
    calculateScore(moves: moves, time: time, difficulty: difficulty);
    notifyListeners();
  }

  void resetCurrentScore() {
    _currentScore = null;
    notifyListeners();
  }
}
