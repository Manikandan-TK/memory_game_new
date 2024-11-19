import 'package:flutter/material.dart';
import 'package:memory_game_new/models/game_config.dart';
import 'package:memory_game_new/widgets/geometric_pattern_painter.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/memory_card_widget.dart';
import '../theme/app_theme.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
            backgroundColor: theme.colorScheme.surface.withOpacity(AppTheme.opacityMedium),
            foregroundColor: Colors.white.withOpacity(AppTheme.opacityHigh),
          ),
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacing8),
            child: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surface.withOpacity(AppTheme.opacityMedium),
                foregroundColor: Colors.white.withOpacity(AppTheme.opacityHigh),
              ),
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<GameProvider>().resetGame(),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient layers
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withOpacity(AppTheme.opacityMedium),
                    theme.colorScheme.surface,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          // Subtle pattern overlay
          Positioned.fill(
            child: ShaderMask(
              blendMode: BlendMode.plus,
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(AppTheme.opacityMedium),
                  Colors.white.withOpacity(AppTheme.opacityLight),
                ],
              ).createShader(bounds),
              child: CustomPaint(
                painter: GeometricPatternPainter(
                  primaryColor: theme.colorScheme.primary,
                  secondaryColor: theme.colorScheme.secondary,
                  isGameScreen: true,
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                if (!gameProvider.isInitialized) {
                  gameProvider.initializeGame();
                }
                return Column(
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
                          final (rows, columns) = gameProvider.config.difficulty.gridSize;
                          final isHardMode = gameProvider.config.difficulty == GameDifficulty.hard;

                          // Calculate optimal card size based on screen width
                          final screenWidth = MediaQuery.of(context).size.width;
                          const horizontalPadding = 16.0;
                          const gridSpacing = 8.0;
                          final availableWidth = screenWidth - horizontalPadding;
                          final cardWidth = (availableWidth - (gridSpacing * (columns - 1))) / columns;

                          // Calculate total height needed
                          final totalHeight = (cardWidth * rows) + (gridSpacing * (rows - 1));
                          final viewportHeight = constraints.maxHeight;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                            child: ScrollConfiguration(
                              // Custom scroll behavior for smoother scrolling
                              behavior: ScrollConfiguration.of(context).copyWith(
                                physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics(),
                                ),
                                scrollbars: false,
                              ),
                              child: GridView.builder(
                                // Keep items in memory even when not visible
                                addRepaintBoundaries: true,
                                addAutomaticKeepAlives: true,
                                // Use builder for better performance
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  mainAxisSpacing: gridSpacing,
                                  crossAxisSpacing: gridSpacing,
                                  childAspectRatio: 1, // Cards are square
                                ),
                                // Optimize scrolling behavior based on content size
                                physics: isHardMode
                                    ? (totalHeight > viewportHeight
                                        ? const AlwaysScrollableScrollPhysics(
                                            parent: BouncingScrollPhysics(),
                                          )
                                        : const NeverScrollableScrollPhysics())
                                    : const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(4),
                                itemCount: gameProvider.cards.length,
                                // Increase cache extent for better scrolling performance
                                cacheExtent: cardWidth * 4,
                                itemBuilder: (context, index) {
                                  final card = gameProvider.cards[index];
                                  return MemoryCardWidget(
                                    // Use a unique key combining card ID and state
                                    key: ObjectKey('${card.id}_${card.isMatched}_${card.isFlipped}'),
                                    card: card,
                                    onTap: () => gameProvider.flipCard(index),
                                    size: cardWidth,
                                  );
                                },
                              ),
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
                                color: Colors.white.withOpacity(AppTheme.opacityHigh),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: size.width * 0.8,
                              height: 80,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary.withOpacity(AppTheme.opacityMedium),
                                  foregroundColor: Colors.white.withOpacity(AppTheme.opacityHigh),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 20,
                                  ),
                                ),
                                onPressed: () {
                                  gameProvider.resetGame();
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.home_rounded,
                                      size: 36,
                                      color: Colors.white.withOpacity(AppTheme.opacityHigh),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Back to Menu',
                                      style: theme.textTheme.headlineMedium?.copyWith(
                                        color: Colors.white.withOpacity(AppTheme.opacityHigh),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
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
        ],
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
        color: theme.colorScheme.surface.withOpacity(AppTheme.opacityMedium),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
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
                color: theme.colorScheme.onSurface.withOpacity(AppTheme.opacityMedium),
              ),
              const SizedBox(width: AppTheme.spacing4),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(AppTheme.opacityMedium),
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
