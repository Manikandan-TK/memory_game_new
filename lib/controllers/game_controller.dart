import '../models/game_state.dart';
import '../models/game_config.dart';

/// Interface for game lifecycle operations
/// Following Interface Segregation Principle - separate interfaces for different aspects of game control
abstract class IGameLifecycle {
  void initializeGame();
  void resetGame();
  void pauseGame();
  void resumeGame();
  Future<void> exitGame();
}

/// Interface for game play operations
abstract class IGamePlay {
  Future<void> flipCard(int index);
  void updateDifficulty(GameDifficulty difficulty);
}

/// Interface for game state access
abstract class IGameState {
  GameState get currentState;
  Stream<GameState> get stateStream;
}

/// Combined interface for game controller
/// Following Dependency Inversion Principle - high level modules depend on abstractions
abstract class GameController implements IGameLifecycle, IGamePlay, IGameState {
  /// Factory constructor to create a game controller
  factory GameController() = DefaultGameController;
}

/// Default implementation of GameController
/// Following Single Responsibility Principle - delegates actual implementation to specialized classes
class DefaultGameController implements GameController {
  @override
  GameState get currentState => throw UnimplementedError();

  @override
  Stream<GameState> get stateStream => throw UnimplementedError();

  @override
  Future<void> exitGame() async {
    throw UnimplementedError();
  }

  @override
  Future<void> flipCard(int index) async {
    throw UnimplementedError();
  }

  @override
  void initializeGame() {
    throw UnimplementedError();
  }

  @override
  void pauseGame() {
    throw UnimplementedError();
  }

  @override
  void resetGame() {
    throw UnimplementedError();
  }

  @override
  void resumeGame() {
    throw UnimplementedError();
  }

  @override
  void updateDifficulty(GameDifficulty difficulty) {
    throw UnimplementedError();
  }
}
