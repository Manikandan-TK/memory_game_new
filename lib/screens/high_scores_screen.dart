import 'package:flutter/material.dart';
import 'package:memory_game_new/widgets/geometric_pattern_painter.dart';
import 'package:provider/provider.dart';
import '../providers/score_provider.dart';
import '../widgets/score_display.dart';
import '../theme/app_theme.dart';

class HighScoresScreen extends StatelessWidget {
  const HighScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highScores = context.watch<ScoreProvider>().highScores;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'High Scores',
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
          onPressed: () => Navigator.of(context).pop(),
        ),
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
          // Content
          SafeArea(
            child: highScores.isEmpty
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(AppTheme.opacityMedium),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            size: 48,
                            color: Colors.white.withOpacity(AppTheme.opacityHigh),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No high scores yet!',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white.withOpacity(AppTheme.opacityHigh),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Play some games to set records.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(AppTheme.opacityHigh),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    itemCount: highScores.length,
                    itemBuilder: (context, index) {
                      final score = highScores[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
                        child: ScoreDisplay(
                          score: score,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
