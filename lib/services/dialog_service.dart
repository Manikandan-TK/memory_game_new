import 'package:flutter/material.dart';
import 'package:memory_game_new/theme/app_theme.dart';

/// Service responsible for showing game-related dialogs
/// Following Single Responsibility Principle - handles only dialog-related functionality
class DialogService {
  /// Shows a confirmation dialog when the user tries to exit the game
  static Future<bool> showExitConfirmation(BuildContext context) async {
    final theme = Theme.of(context);
    
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface.withOpacity(AppTheme.opacityMedium),
        title: Text(
          'Exit Game?',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white.withOpacity(AppTheme.opacityHigh),
          ),
        ),
        content: Text(
          'Your progress will be lost. Are you sure you want to exit?',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withOpacity(AppTheme.opacityHigh),
          ),
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withOpacity(AppTheme.opacityMedium),
              foregroundColor: Colors.white.withOpacity(AppTheme.opacityHigh),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withOpacity(AppTheme.opacityMedium),
              foregroundColor: Colors.white.withOpacity(AppTheme.opacityHigh),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    ) ?? false;
  }

  /// Shows the pause menu overlay
  static Future<PauseMenuAction?> showPauseMenu(BuildContext context) async {
    final theme = Theme.of(context);
    
    return await showDialog<PauseMenuAction>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(AppTheme.opacityMedium),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Paused',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white.withOpacity(AppTheme.opacityHigh),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              _buildPauseMenuItem(
                context,
                'Resume',
                Icons.play_arrow_rounded,
                PauseMenuAction.resume,
                theme,
              ),
              const SizedBox(height: 16),
              _buildPauseMenuItem(
                context,
                'Restart',
                Icons.refresh_rounded,
                PauseMenuAction.restart,
                theme,
              ),
              const SizedBox(height: 16),
              _buildPauseMenuItem(
                context,
                'Exit to Menu',
                Icons.exit_to_app_rounded,
                PauseMenuAction.exit,
                theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildPauseMenuItem(
    BuildContext context,
    String text,
    IconData icon,
    PauseMenuAction action,
    ThemeData theme,
  ) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary.withOpacity(AppTheme.opacityMedium),
          foregroundColor: Colors.white.withOpacity(AppTheme.opacityHigh),
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.of(context).pop(action),
        icon: Icon(icon),
        label: Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white.withOpacity(AppTheme.opacityHigh),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Possible actions from the pause menu
enum PauseMenuAction {
  resume,
  restart,
  exit,
}
