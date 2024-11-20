import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import '../models/card_model.dart';
import '../models/game_config.dart';
import '../models/game_state.dart';
import '../utils/logger.dart';
import 'package:provider/provider.dart';
import 'score_provider.dart';
import '../main.dart';

/// Provider that manages game state and operations
/// Following Open/Closed Principle - extends functionality through composition
class GameProvider extends ChangeNotifier {
  GameState _state;
  Duration? _pauseStartTime;

  GameProvider() : _state = GameState.initial(const GameConfig.defaultConfig()) {
    GameLogger.i('Game provider initialized with difficulty: ${_state.config.difficulty}');
  }

  // Getters
  GameState get state => _state;
  bool get isInitialized => _state.isInitialized;
  bool get isPaused => _state.isPaused;
  bool get isGameComplete => _state.isGameComplete;
  bool get isProcessing => _state.isProcessing;
  int get moves => _state.moves;
  int get matches => _state.matches;
  List<MemoryCard> get cards => _state.cards;
  GameConfig get config => _state.config;
  
  // Current score from ScoreProvider
  int get currentScore => Provider.of<ScoreProvider>(
    navigatorKey.currentContext!, 
    listen: false
  ).currentScore?.value ?? 0;

  void _updateState(GameState newState) {
    _state = newState;
    notifyListeners();
  }

  // Game Lifecycle Methods
  void initializeGame() {
    if (_state.isInitialized) return;

    try {
      final (rows, columns) = _state.config.difficulty.gridSize;
      final numberOfPairs = _state.config.difficulty.numberOfPairs;

      // Reset score at game start
      if (navigatorKey.currentContext != null) {
        Provider.of<ScoreProvider>(
          navigatorKey.currentContext!, 
          listen: false
        ).resetScore();
      }

      // Validate configuration
      if (rows <= 0 || columns <= 0) {
        throw ArgumentError('Invalid grid size: rows=$rows, columns=$columns');
      }

      if (numberOfPairs <= 0) {
        throw ArgumentError('Invalid number of pairs: $numberOfPairs');
      }

      // Create shuffled list of emojis for pairs
      final shuffledEmojis = emojis.take(numberOfPairs).toList()..shuffle(math.Random());

      // Create pairs of cards with unique IDs
      final cards = <MemoryCard>[];
      var cardId = 0;
      for (var i = 0; i < numberOfPairs; i++) {
        for (var j = 0; j < 2; j++) {
          cards.add(MemoryCard(
            id: cardId++,
            emoji: shuffledEmojis[i],
            isFlipped: false,
            isMatched: false,
          ));
        }
      }

      // Shuffle all cards
      cards.shuffle(math.Random());

      _updateState(_state.copyWith(
        isInitialized: true,
        cards: cards,
        startTime: DateTime.now().millisecondsSinceEpoch,
      ));

      GameLogger.i('Game initialized with difficulty: ${_state.config.difficulty}');
    } catch (e) {
      GameLogger.e('Error initializing game', e);
      _updateState(_state.copyWith(isInitialized: false));
      rethrow;
    }
  }

  void resetGame() {
    _updateState(GameState.initial(_state.config));
    initializeGame();
  }

  void pauseGame() {
    if (!_state.isInProgress) return;
    _pauseStartTime = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(_state.startTime)
    );
    _updateState(_state.copyWith(isPaused: true));
  }

  void resumeGame() {
    if (!_state.isPaused) return;
    final pausedDuration = _state.pausedDuration ?? Duration.zero;
    final additionalPauseDuration = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(_state.startTime)
    ) - _pauseStartTime!;
    
    _updateState(_state.copyWith(
      isPaused: false,
      pausedDuration: pausedDuration + additionalPauseDuration,
    ));
    _pauseStartTime = null;
  }

  // Game Play Methods
  Future<void> flipCard(int index) async {
    // Defensive programming checks
    if (!_state.isInProgress || 
        index < 0 || 
        index >= _state.cards.length ||
        _state.cards[index].isMatched || 
        _state.cards[index].isFlipped ||
        _state.flippedCards.length >= 2) {
      return;
    }

    try {
      _updateState(_state.copyWith(isProcessing: true));

      // Flip the card
      final updatedCards = List<MemoryCard>.from(_state.cards);
      updatedCards[index] = updatedCards[index].copyWith(isFlipped: true);
      
      final updatedFlippedCards = List<MemoryCard>.from(_state.flippedCards)
        ..add(updatedCards[index]);

      _updateState(_state.copyWith(
        cards: updatedCards,
        flippedCards: updatedFlippedCards,
      ));

      // If we have two cards flipped, check for a match
      if (updatedFlippedCards.length == 2) {
        await _processMatch();
      }
    } finally {
      _updateState(_state.copyWith(isProcessing: false));
    }
  }

  Future<void> _processMatch() async {
    if (_state.flippedCards.length != 2) return;

    final isMatch = _state.flippedCards[0].emoji == _state.flippedCards[1].emoji;
    final updatedCards = List<MemoryCard>.from(_state.cards);

    // Update score
    if (navigatorKey.currentContext != null) {
      Provider.of<ScoreProvider>(
        navigatorKey.currentContext!, 
        listen: false
      ).updateScore(
        moves: _state.moves + 1,
        time: _state.currentDuration,
        difficulty: _state.config.difficulty,
        isMatch: isMatch,
      );
    }

    if (isMatch) {
      // Mark cards as matched
      for (var card in _state.flippedCards) {
        final index = updatedCards.indexWhere((c) => c.id == card.id);
        updatedCards[index] = card.copyWith(isMatched: true);
      }

      final newMatches = _state.matches + 1;
      final isComplete = newMatches == _state.config.difficulty.numberOfPairs;

      _updateState(_state.copyWith(
        cards: updatedCards,
        matches: newMatches,
        isGameComplete: isComplete,
        flippedCards: [],
        moves: _state.moves + 1,
      ));

      if (isComplete && navigatorKey.currentContext != null) {
        Provider.of<ScoreProvider>(
          navigatorKey.currentContext!, 
          listen: false
        ).finalizeScore();
      }
    } else {
      _updateState(_state.copyWith(
        moves: _state.moves + 1,
      ));

      // Wait before flipping cards back
      await Future.delayed(const Duration(milliseconds: 500));

      // Flip cards back
      for (var card in _state.flippedCards) {
        final index = updatedCards.indexWhere((c) => c.id == card.id);
        updatedCards[index] = card.copyWith(isFlipped: false);
      }

      _updateState(_state.copyWith(
        cards: updatedCards,
        flippedCards: [],
      ));
    }
  }

  void updateDifficulty(GameDifficulty difficulty) {
    if (_state.config.difficulty == difficulty) return;
    _updateState(GameState.initial(_state.config.copyWith(difficulty: difficulty)));
    initializeGame();
  }

  // List of emojis for card pairs
  static const List<String> emojis = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯',
    '🦁', '🐮', '🐷', '🐸', '🐵', '🦄', '🐔', '🐧', '🐦', '🐤',
    '🦆', '🦅', '🦉', '🦇',
  ];
}
