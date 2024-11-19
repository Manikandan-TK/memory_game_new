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
            backgroundColor: theme.colorScheme.surface.withOpacity(AppTheme.opacityMedium),
            foregroundColor: Colors.white.withOpacity(AppTheme.opacityHigh),
          ),
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient layers
          Positioned.fill(
            child: CustomPaint(
              painter: GeometricPatternPainter(
                primaryColor: theme.colorScheme.primary,
                secondaryColor: theme.colorScheme.secondary,
                isGameScreen: true,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: highScores.isEmpty
              ? Center(
                  child: Text(
                    'No high scores yet!\nPlay some games to set records.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(AppTheme.opacityHigh),
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
