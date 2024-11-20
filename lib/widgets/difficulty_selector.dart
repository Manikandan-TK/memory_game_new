import '../models/game_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class DifficultySelector extends StatelessWidget {
  const DifficultySelector({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final gameProvider = context.watch<GameProvider>();
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDifficultyButton(
          context: context,
          difficulty: 'easy',
          title: isSmallScreen ? 'EASY' : 'EASY (4X4)',
          subtitle: '4x4 Grid • Perfect for Beginners',
          icon: Icons.sentiment_satisfied_rounded,
          isSelected: gameProvider.config.difficulty == GameDifficulty.easy,
          onTap: () => gameProvider.updateDifficulty(GameDifficulty.easy),
        ),
        const SizedBox(height: AppTheme.spacing12),
        _buildDifficultyButton(
          context: context,
          difficulty: 'medium',
          title: isSmallScreen ? 'MEDIUM' : 'MEDIUM (6X4)',
          subtitle: '6x4 Grid • Test Your Skills',
          icon: Icons.sentiment_neutral_rounded,
          isSelected: gameProvider.config.difficulty == GameDifficulty.medium,
          onTap: () => gameProvider.updateDifficulty(GameDifficulty.medium),
        ),
        const SizedBox(height: AppTheme.spacing12),
        _buildDifficultyButton(
          context: context,
          difficulty: 'hard',
          title: isSmallScreen ? 'HARD' : 'HARD (12X4)',
          subtitle: '12x4 Grid • Ultimate Challenge',
          icon: Icons.sentiment_very_dissatisfied_rounded,
          isSelected: gameProvider.config.difficulty == GameDifficulty.hard,
          onTap: () => gameProvider.updateDifficulty(GameDifficulty.hard),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty, bool isSelected) {
    switch (difficulty) {
      case 'easy':
        return isSelected ? const Color(0xFF4ADE80) : const Color(0xFF22C55E); // Vibrant green
      case 'medium':
        return isSelected ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B); // Warm yellow/orange
      case 'hard':
        return isSelected ? const Color(0xFFEF4444) : const Color(0xFFDC2626); // Bright red
      default:
        return Colors.white;
    }
  }

  Widget _buildDifficultyButton({
    required BuildContext context,
    required String difficulty,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final difficultyColor = _getDifficultyColor(difficulty, isSelected);
    final backgroundColor = isSelected
        ? difficultyColor.withOpacity(AppTheme.opacityLight)
        : theme.colorScheme.surface.withOpacity(AppTheme.opacityMedium);
    final borderColor = isSelected
        ? difficultyColor
        : theme.colorScheme.surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: isSelected ? [
              BoxShadow(
                color: difficultyColor.withOpacity(AppTheme.opacityMedium),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ] : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? difficultyColor : difficultyColor.withOpacity(0.7),
                size: 32,
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: difficultyColor,
                        fontSize: 18,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: AppTheme.spacing8),
                Icon(
                  Icons.check_circle_rounded,
                  color: difficultyColor,
                  size: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
