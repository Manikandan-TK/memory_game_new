import 'package:flutter/material.dart';
import 'package:memory_game_new/services/dialog_service.dart';
import 'package:memory_game_new/widgets/geometric_pattern_painter.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/memory_card_widget.dart';
import '../theme/app_theme.dart';
import 'high_scores_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final gameProvider = context.read<GameProvider>();
        if (!gameProvider.state.isInProgress) {
          Navigator.of(context).pop();
          return;
        }

        if (!context.mounted) return;
        final shouldPop = await DialogService.showExitConfirmation(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Memory Game',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white.withOpacity(AppTheme.opacityHigh),
            ),
          ),
          leading: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor:
                  theme.colorScheme.surface.withOpacity(AppTheme.opacityMedium),
              foregroundColor: Colors.white.withOpacity(AppTheme.opacityHigh),
            ),
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              final gameProvider = context.read<GameProvider>();
              if (!gameProvider.state.isInProgress) {
                Navigator.of(context).pop();
                return;
              }

              if (!context.mounted) return;
              final shouldExit =
                  await DialogService.showExitConfirmation(context);
              if (shouldExit && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                if (!gameProvider.state.isInProgress) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacing8),
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface
                          .withOpacity(AppTheme.opacityMedium),
                      foregroundColor:
                          Colors.white.withOpacity(AppTheme.opacityHigh),
                    ),
                    icon: Icon(gameProvider.state.isPaused
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded),
                    onPressed: () async {
                      if (gameProvider.state.isPaused) {
                        gameProvider.resumeGame();
                      } else {
                        gameProvider.pauseGame();
                        if (!context.mounted) return;
                        final action =
                            await DialogService.showPauseMenu(context);
                        if (!context.mounted) return;
                        switch (action) {
                          case PauseMenuAction.resume:
                            gameProvider.resumeGame();
                            break;
                          case PauseMenuAction.restart:
                            gameProvider.resetGame();
                            break;
                          case PauseMenuAction.exit:
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                            break;
                          case null:
                            // Dialog dismissed
                            gameProvider.resumeGame();
                            break;
                        }
                      }
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppTheme.spacing8),
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surface
                      .withOpacity(AppTheme.opacityMedium),
                  foregroundColor:
                      Colors.white.withOpacity(AppTheme.opacityHigh),
                ),
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<GameProvider>().resetGame(),
              ),
            ),
          ],
        ),
        body: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            if (!gameProvider.isInitialized) {
              gameProvider.initializeGame();
            }

            return Stack(
              children: [
                // Background gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary
                              .withOpacity(AppTheme.opacityHigh),
                          theme.colorScheme.tertiary
                              .withOpacity(AppTheme.opacityMedium),
                          theme.colorScheme.secondary
                              .withOpacity(AppTheme.opacityLight),
                        ],
                      ),
                    ),
                  ),
                ),
                // Pattern overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(AppTheme.opacityLight),
                    ),
                    child: CustomPaint(
                      painter: GeometricPatternPainter(
                        primaryColor: theme.colorScheme.primary,
                        secondaryColor: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                // Main content
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppTheme.spacing16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildGameMetric(
                              context,
                              'Score',
                              gameProvider.currentScore.toString(),
                              Icons.stars_rounded,
                            ),
                            _buildGameMetric(
                              context,
                              'Moves',
                              gameProvider.moves.toString(),
                              Icons.touch_app_rounded,
                            ),
                            _buildGameMetric(
                              context,
                              'Matches',
                              '${gameProvider.matches}/${gameProvider.config.difficulty.numberOfPairs}',
                              Icons.favorite_rounded,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final (rows, columns) =
                                gameProvider.config.difficulty.gridSize;

                            // Calculate optimal card size based on screen dimensions
                            final screenWidth =
                                MediaQuery.of(context).size.width;
                            final screenHeight = constraints.maxHeight;
                            const horizontalPadding = 16.0;

                            // Adjust spacing based on screen size
                            final gridSpacing =
                                screenWidth < 400 ? 8.0 : 12.0;

                            // Calculate available space
                            final availableWidth =
                                screenWidth - horizontalPadding;
                            final availableHeight =
                                screenHeight - (gridSpacing * (rows - 1));

                            // Calculate card size to fit both width and height constraints
                            final cardWidthByColumns = (availableWidth -
                                    (gridSpacing * (columns - 1))) /
                                columns;
                            final cardHeightByRows = (availableHeight - 16) /
                                rows; // Additional padding for safety

                            // Use the smaller dimension to ensure square cards that fit the screen
                            final cardSize =
                                (cardWidthByColumns < cardHeightByRows
                                        ? cardWidthByColumns
                                        : cardHeightByRows)
                                    .floorToDouble();

                            // Ensure minimum and maximum card sizes for different devices
                            final constrainedCardSize = cardSize.clamp(
                                60.0, // Minimum card size
                                screenWidth < 400
                                    ? 100.0
                                    : 120.0 // Maximum card size based on screen width
                                );

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: horizontalPadding / 2,
                              ),
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  childAspectRatio: 1.0,
                                  crossAxisSpacing: gridSpacing,
                                  mainAxisSpacing: gridSpacing,
                                ),
                                itemCount: gameProvider.cards.length,
                                cacheExtent:
                                    0, // Disable caching to prevent animation issues
                                itemBuilder: (context, index) {
                                  final card = gameProvider.cards[index];
                                  return RepaintBoundary(
                                    child: MemoryCardWidget(
                                      key: ValueKey(card.id),
                                      card: card,
                                      size: constrainedCardSize,
                                      onTap: () =>
                                          gameProvider.flipCard(index),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      if (gameProvider.isGameComplete)
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                'Congratulations!',
                                style: theme.textTheme.displaySmall?.copyWith(
                                  color: Colors.white
                                      .withOpacity(AppTheme.opacityHigh),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.4,
                                    height: 80,
                                    child: FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: theme
                                            .colorScheme.primary
                                            .withOpacity(
                                                AppTheme.opacityMedium),
                                        foregroundColor: Colors.white
                                            .withOpacity(
                                                AppTheme.opacityHigh),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HighScoresScreen(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.emoji_events_rounded,
                                            size: 36,
                                            color: Colors.white.withOpacity(
                                                AppTheme.opacityHigh),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: size.width * 0.4,
                                    height: 80,
                                    child: FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: theme
                                            .colorScheme.primary
                                            .withOpacity(
                                                AppTheme.opacityMedium),
                                        foregroundColor: Colors.white
                                            .withOpacity(
                                                AppTheme.opacityHigh),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                      ),
                                      onPressed: () {
                                        gameProvider.resetGame();
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.home_rounded,
                                            size: 36,
                                            color: Colors.white.withOpacity(
                                                AppTheme.opacityHigh),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameMetric(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: AppTheme.spacing4),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
