import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import '../models/card_model.dart';
import '../models/game_config.dart';
import '../utils/logger.dart';
import '../models/score_model.dart';
import 'package:provider/provider.dart';
import 'score_provider.dart';
import '../main.dart';

class GameProvider extends ChangeNotifier {
  // Game configuration
  GameConfig _config = const GameConfig.defaultConfig();
  GameConfig get config => _config;

  GameProvider() {
    GameLogger.i('Game provider initialized with difficulty: ${_config.difficulty}');
  }

  // Game state
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Game metrics
  int _moves = 0;
  int get moves => _moves;

  int _matches = 0;
  int get matches => _matches;

  bool _isGameComplete = false;
  bool get isGameComplete => _isGameComplete;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  // Current score from ScoreProvider
  int get currentScore => Provider.of<ScoreProvider>(navigatorKey.currentContext!, listen: false).currentScore?.value ?? 0;

  // Cards state
  List<MemoryCard> _cards = [];
  List<MemoryCard> get cards => List.unmodifiable(_cards);

  // Using a map to track flipped cards by their IDs for better performance
  final List<MemoryCard> _flippedCards = [];
  List<MemoryCard> get flippedCards => List.unmodifiable(_flippedCards);

  // List of emojis for card pairs
  final List<String> emojis = [
    '🐶',
    '🐱',
    '🐭',
    '🐹',
    '🐰',
    '🦊',
    '🐻',
    '🐼',
    '🐨',
    '🐯',
    '🦁',
    '🐮',
    '🐷',
    '🐸',
    '🐵',
    '🦄',
    '🐔',
    '🐧',
    '🐦',
    '🐤',
    '🦆',
    '🦅',
    '🦉',
    '🦇',
  ];

  // Scoring system
  static const int basePoints = 100;
  static const int comboBonus = 50;
  static const int movePenalty = 10;
  static const double maxTimeMultiplier = 1.5;

  int _startTime = 0;

  // Update difficulty and reinitialize game
  void updateDifficulty(GameDifficulty difficulty) {
    if (_config.difficulty == difficulty) {
      return; // Don't reinitialize if same difficulty
    }

    _config = _config.copyWith(difficulty: difficulty);
    _isInitialized = false;
    initializeGame();
    notifyListeners();
  }

  // Initialize game with current configuration
  void initializeGame() {
    if (_isInitialized) return;

    try {
      _startTime = DateTime.now().millisecondsSinceEpoch;
      final (rows, columns) = _config.difficulty.gridSize;
      final numberOfPairs = _config.difficulty.numberOfPairs;

      // Reset score at game start
      if (navigatorKey.currentContext != null) {
        Provider.of<ScoreProvider>(navigatorKey.currentContext!, listen: false)
            .resetScore();
      }

      // Validate configuration
      if (rows <= 0 || columns <= 0) {
        throw ArgumentError('Invalid grid size: rows=$rows, columns=$columns');
      }

      if (numberOfPairs <= 0) {
        throw ArgumentError('Invalid number of pairs: $numberOfPairs');
      }

      // Ensure we have enough emojis for the selected difficulty
      if (emojis.length < numberOfPairs) {
        throw StateError(
          'Not enough emojis (${emojis.length}) for the selected difficulty ($numberOfPairs pairs needed)',
        );
      }

      // Reset game state
      _moves = 0;
      _matches = 0;
      _isGameComplete = false;
      _isProcessing = false;
      _flippedCards.clear();

      // Create shuffled list of emojis for pairs
      final shuffledEmojis = emojis.take(numberOfPairs).toList()
        ..shuffle(math.Random());

      // Create pairs of cards with unique IDs
      _cards = [];
      var cardId = 0;
      for (var i = 0; i < numberOfPairs; i++) {
        for (var j = 0; j < 2; j++) {
          _cards.add(MemoryCard(
            id: cardId++,
            emoji: shuffledEmojis[i],
            isFlipped: false,
            isMatched: false,
          ));
        }
      }

      // Shuffle all cards
      _cards.shuffle(math.Random());
      _isInitialized = true;

      GameLogger.i('Game initialized with difficulty: ${_config.difficulty}');
      notifyListeners();
    } catch (e) {
      GameLogger.e('Error initializing game', e);
      _isInitialized = false;
      rethrow; // Rethrow to let UI handle the error
    }
  }

  // Flip a card at the given index
  Future<void> flipCard(int index) async {
    // Defensive programming checks
    if (!_isInitialized) {
      GameLogger.d('Game not initialized');
      return;
    }

    if (_isProcessing) {
      GameLogger.d('Card flip in progress');
      return;
    }

    if (index < 0 || index >= _cards.length) {
      GameLogger.d('Invalid card index: $index');
      return;
    }

    final card = _cards[index];
    if (card.isMatched || card.isFlipped) {
      GameLogger.d('Card already matched or flipped');
      return;
    }

    if (_flippedCards.length >= 2) {
      GameLogger.d('Maximum cards already flipped');
      return;
    }

    try {
      _isProcessing = true;
      notifyListeners();

      // Flip the card
      _cards[index] = card.copyWith(isFlipped: true);
      _flippedCards.add(_cards[index]);

      // If we have two cards flipped, check for a match
      if (_flippedCards.length == 2) {
        _moves++;

        // Update score on each move
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        final duration = Duration(milliseconds: currentTime - _startTime);
        if (navigatorKey.currentContext != null) {
          Provider.of<ScoreProvider>(navigatorKey.currentContext!, listen: false)
              .updateScore(
                moves: _moves,
                time: duration,
                difficulty: _config.difficulty,
              );
        }

        await _processMatch();
      }

      notifyListeners();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // Process card matches
  Future<void> _processMatch() async {
    if (_flippedCards.length != 2) return;

    GameLogger.d(
        'Processing match: ${_flippedCards.map((c) => c.emoji).join(" vs ")}');
    final isMatch = _flippedCards[0].emoji == _flippedCards[1].emoji;

    // Calculate current duration for score update
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final duration = Duration(milliseconds: currentTime - _startTime);

    if (isMatch) {
      GameLogger.i('Match found! 🎯 ${_flippedCards[0].emoji}');
      // Mark cards as matched
      for (var card in _flippedCards) {
        final index = _cards.indexWhere((c) => c.id == card.id);
        _cards[index] = card.copyWith(isMatched: true);
      }
      _matches++;

      // Update score with match bonus
      if (navigatorKey.currentContext != null) {
        Provider.of<ScoreProvider>(navigatorKey.currentContext!, listen: false)
            .updateScore(
              moves: _moves,
              time: duration,
              difficulty: _config.difficulty,
              isMatch: true,
            );
      }

      // Check if game is complete
      if (_matches == _config.difficulty.numberOfPairs) {
        GameLogger.i(
            '🏆 Game complete! Moves: $_moves | Matches: $_matches');
        _isGameComplete = true;
        
        // Finalize score and add to high scores
        if (navigatorKey.currentContext != null) {
          Provider.of<ScoreProvider>(navigatorKey.currentContext!, listen: false)
              .finalizeScore();
        }
      }
    } else {
      GameLogger.i(
          'No match: ${_flippedCards[0].emoji} ≠ ${_flippedCards[1].emoji}');
      // Update score without match bonus
      if (navigatorKey.currentContext != null) {
        Provider.of<ScoreProvider>(navigatorKey.currentContext!, listen: false)
            .updateScore(
              moves: _moves,
              time: duration,
              difficulty: _config.difficulty,
              isMatch: false,
            );
      }

      // Wait before flipping cards back
      await Future.delayed(const Duration(milliseconds: 500));
      for (var card in _flippedCards) {
        final index = _cards.indexWhere((c) => c.id == card.id);
        _cards[index] = card.copyWith(isFlipped: false);
      }
    }

    _flippedCards.clear();
    GameLogger.d(
        'Match processing complete. Cards in play: ${_cards.where((c) => c.isFlipped).length}');
    notifyListeners();
  }

  // Reset game with current configuration
  void resetGame() {
    // Reset score provider
    if (navigatorKey.currentContext != null) {
      Provider.of<ScoreProvider>(navigatorKey.currentContext!, listen: false)
          .resetScore();
    }

    _isInitialized = false;
    initializeGame();
  }
}
