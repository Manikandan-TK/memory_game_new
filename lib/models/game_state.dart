import 'package:flutter/foundation.dart';
import 'card_model.dart';
import 'game_config.dart';

/// Represents the current state of the game
/// Following Single Responsibility Principle - this class only handles game state data
@immutable
class GameState {
  final bool isInitialized;
  final bool isPaused;
  final bool isGameComplete;
  final bool isProcessing;
  final int moves;
  final int matches;
  final int startTime;
  final List<MemoryCard> cards;
  final List<MemoryCard> flippedCards;
  final GameConfig config;
  final Duration? pausedDuration;

  const GameState({
    required this.isInitialized,
    required this.isPaused,
    required this.isGameComplete,
    required this.isProcessing,
    required this.moves,
    required this.matches,
    required this.startTime,
    required this.cards,
    required this.flippedCards,
    required this.config,
    this.pausedDuration,
  });

  /// Creates an initial state
  factory GameState.initial(GameConfig config) {
    return GameState(
      isInitialized: false,
      isPaused: false,
      isGameComplete: false,
      isProcessing: false,
      moves: 0,
      matches: 0,
      startTime: DateTime.now().millisecondsSinceEpoch,
      cards: const [],
      flippedCards: const [],
      config: config,
    );
  }

  /// Creates a copy of the current state with optional parameter overrides
  GameState copyWith({
    bool? isInitialized,
    bool? isPaused,
    bool? isGameComplete,
    bool? isProcessing,
    int? moves,
    int? matches,
    int? startTime,
    List<MemoryCard>? cards,
    List<MemoryCard>? flippedCards,
    GameConfig? config,
    Duration? pausedDuration,
  }) {
    return GameState(
      isInitialized: isInitialized ?? this.isInitialized,
      isPaused: isPaused ?? this.isPaused,
      isGameComplete: isGameComplete ?? this.isGameComplete,
      isProcessing: isProcessing ?? this.isProcessing,
      moves: moves ?? this.moves,
      matches: matches ?? this.matches,
      startTime: startTime ?? this.startTime,
      cards: cards ?? this.cards,
      flippedCards: flippedCards ?? this.flippedCards,
      config: config ?? this.config,
      pausedDuration: pausedDuration ?? this.pausedDuration,
    );
  }

  /// Returns true if the game is actively being played
  bool get isInProgress => isInitialized && !isGameComplete && !isPaused;

  /// Returns the current game duration, accounting for paused time
  Duration get currentDuration {
    if (!isInitialized) return Duration.zero;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    final totalDuration = Duration(milliseconds: now - startTime);
    return totalDuration - (pausedDuration ?? Duration.zero);
  }
}
