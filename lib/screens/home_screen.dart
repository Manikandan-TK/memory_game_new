import 'package:flutter/material.dart';
import 'package:memory_game_new/widgets/geometric_pattern_painter.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/theme_selector.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';
import '../widgets/difficulty_selector.dart';
import 'high_scores_screen.dart'; // Added import for HighScoresScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacing8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surface
                        .withOpacity(AppTheme.opacityMedium),
                  ),
                  icon: Icon(
                    Icons.emoji_events_rounded,
                    size: 26,
                    color: Colors.white.withOpacity(AppTheme.opacityHigh),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HighScoresScreen(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surface
                        .withOpacity(AppTheme.opacityMedium),
                  ),
                  icon: Icon(
                    Icons.settings_rounded,
                    size: 26,
                    color: Colors.white.withOpacity(AppTheme.opacityHigh),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings coming soon!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withOpacity(AppTheme.opacityHigh),
                    theme.colorScheme.tertiary.withOpacity(AppTheme.opacityMedium),
                    theme.colorScheme.secondary.withOpacity(AppTheme.opacityLight),
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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    size.width > 600 ? size.width * 0.1 : AppTheme.spacing24,
              ),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  // Title Section
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Game Icon with Background
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacing16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary
                                  .withOpacity(AppTheme.opacityMedium),
                              theme.colorScheme.secondary
                                  .withOpacity(AppTheme.opacityMedium),
                            ],
                          ),
                          border: Border.all(
                            color:
                                Colors.white.withOpacity(AppTheme.opacityLight),
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Icon(
                              Icons.extension_rounded, // Puzzle piece icon
                              size: size.height * 0.06,
                              color: Colors.white
                                  .withOpacity(AppTheme.opacityHigh),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Icon(
                                Icons
                                    .refresh_rounded, // Small refresh icon to indicate memory/matching
                                size: size.height * 0.025,
                                color: theme.colorScheme.secondary
                                    .withOpacity(AppTheme.opacityHigh),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title with Gradient
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(AppTheme.opacityHigh),
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'Memory Game',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  // Game Settings
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface
                          .withOpacity(AppTheme.opacityMedium),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const DifficultySelector(),
                        const SizedBox(height: 16),
                        const ThemeSelector(),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: theme.colorScheme.primary
                                  .withOpacity(AppTheme.opacityMedium),
                              foregroundColor: Colors.white
                                  .withOpacity(AppTheme.opacityHigh),
                            ),
                            onPressed: () {
                              context.read<GameProvider>().initializeGame();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const GameScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text(
                              'Start Game',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
