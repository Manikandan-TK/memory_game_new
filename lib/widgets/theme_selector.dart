import 'package:flutter/material.dart' hide CardTheme;
import 'package:provider/provider.dart';
import '../models/card_theme.dart';
import '../providers/card_theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  Widget _buildThemeInfo(BuildContext context, CardTheme theme) {
    final themeContext = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: themeContext.colorScheme.primary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        theme.name,
        style: themeContext.textTheme.bodyMedium?.copyWith(
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CardThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Text(
                    'Card Theme',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  _buildThemeInfo(context, themeProvider.currentTheme),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: themeProvider.availableThemes.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final theme = themeProvider.availableThemes[index];
                  final isSelected = theme.identifier == themeProvider.currentTheme.identifier;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _ThemeCard(
                      theme: theme,
                      isSelected: isSelected,
                      onTap: () => themeProvider.setTheme(theme),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeCard extends StatefulWidget {
  final CardTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<_ThemeCard> with SingleTickerProviderStateMixin {
  late final AnimationController _borderController;
  late final Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _borderAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _borderController,
      curve: Curves.easeInOut,
    ));

    if (widget.isSelected) {
      _borderController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_ThemeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _borderController.forward();
      } else {
        _borderController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBackAsset = widget.theme.cardBackAsset;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _borderAnimation,
        builder: (context, child) {
          return Container(
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected
                    ? theme.colorScheme.primary.withOpacity(0.8)
                    : Colors.white.withOpacity(0.2),
                width: widget.isSelected ? 2 * _borderAnimation.value : 1,
              ),
              color: theme.colorScheme.surface.withOpacity(0.1),
            ),
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cardBackAsset.borderColor.withOpacity(0.8),
                      width: 2,
                    ),
                    color: cardBackAsset.backgroundColor,
                    image: DecorationImage(
                      image: AssetImage(cardBackAsset.assetPath),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.theme.name,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
