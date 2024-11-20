import 'package:flutter/material.dart';

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
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Exit Game?',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Your progress will be lost. Are you sure you want to exit?',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Exit',
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
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
            color: theme.colorScheme.surface,
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
                  color: theme.colorScheme.onSurface,
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
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          foregroundColor: theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.of(context).pop(action),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
