import 'package:flutter/foundation.dart';
import '../models/score_model.dart';
import '../models/game_config.dart';
import '../models/game_score_calculator.dart';

class ScoreProvider extends ChangeNotifier {
  Score? _currentScore;
  Score? get currentScore => _currentScore;
  
  List<Score> _highScores = [];
  List<Score> get highScores => List.unmodifiable(_highScores);

  int _currentValue = 0;
  int _consecutiveMatches = 0;
  DateTime? _lastMatchTime;

  void updateScore({
    required int moves,
    required Duration time,
    required GameDifficulty difficulty,
    bool isMatch = false,
  }) {
    if (isMatch) {
      final matchDuration = _lastMatchTime != null 
        ? DateTime.now().difference(_lastMatchTime!) 
        : const Duration(seconds: GameScoreCalculator.quickMatchThreshold + 1);

      final points = GameScoreCalculator.calculateMatchScore(
        difficulty: difficulty,
        isQuickMatch: GameScoreCalculator.isQuickMatch(matchDuration),
        comboCount: _consecutiveMatches,
      );

      _currentValue += points;
      _consecutiveMatches++;
      _lastMatchTime = DateTime.now();
    } else {
      _consecutiveMatches = 0;
    }
    
    _currentScore = Score(
      value: _currentValue,
      moves: moves,
      time: time,
      timestamp: DateTime.now(),
      difficulty: difficulty.toString().split('.').last,
    );

    notifyListeners();
  }

  // Call this method when the game is complete to add the score to high scores
  void finalizeScore() {
    if (_currentScore == null || _currentScore!.value <= 0) return;
    
    _highScores.add(_currentScore!);
    _highScores.sort((a, b) => b.value.compareTo(a.value));
    
    // Keep only top 10 scores
    if (_highScores.length > 10) {
      _highScores = _highScores.sublist(0, 10);
    }
    
    notifyListeners();
  }

  void resetScore() {
    _currentScore = null;
    _currentValue = 0;
    _consecutiveMatches = 0;
    _lastMatchTime = null;
    notifyListeners();
  }
}
