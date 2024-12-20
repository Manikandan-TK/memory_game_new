import 'package:flutter/material.dart';
import '../models/score_model.dart';
import '../theme/app_theme.dart';

class ScoreDisplay extends StatelessWidget {
  final Score score;

  const ScoreDisplay({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
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
          Text(
            'Score',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            '${score.value}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDetail(
                theme,
                Icons.timer_outlined,
                '${score.time.inSeconds}s',
              ),
              const SizedBox(width: AppTheme.spacing16),
              _buildDetail(
                theme,
                Icons.swap_horiz_rounded,
                '${score.moves} moves',
              ),
              const SizedBox(width: AppTheme.spacing16),
              _buildDetail(
                theme,
                Icons.trending_up_rounded,
                score.difficulty,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(ThemeData theme, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
        const SizedBox(width: AppTheme.spacing4),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
