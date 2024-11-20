import 'package:flutter/material.dart' hide CardTheme;
import 'package:provider/provider.dart';
import '../models/card_theme.dart';
import '../providers/card_theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

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
                  final isSelected = theme.type == themeProvider.currentTheme.type;

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

  Widget _buildThemeInfo(BuildContext context, CardTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withOpacity(0.9),
            theme.secondaryColor.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(theme.frontIcon, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            theme.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
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
  bool _isHovered = false;
  late final AnimationController _borderController;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _borderController,
          builder: (context, child) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: widget.isSelected
                    ? SweepGradient(
                        center: Alignment.center,
                        startAngle: 0,
                        endAngle: 3.14 * 2,
                        transform: GradientRotation(_borderController.value * 2 * 3.14),
                        colors: [
                          const Color(0xFFFFD700).withOpacity(1.0),  // Full opacity gold
                          const Color(0xFFFFF380),  // Light gold
                          const Color(0xFFDAA520),  // Golden rod
                          const Color(0xFFFFDF00),  // Golden yellow
                          const Color(0xFFFFD700).withOpacity(1.0),  // Full opacity gold
                        ],
                      )
                    : null,
              ),
              child: Container(
                margin: widget.isSelected ? const EdgeInsets.all(4.5) : const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  border: !widget.isSelected ? Border.all(
                    color: _isHovered 
                        ? const Color(0xFFFFD700)  // Gold on hover
                        : const Color(0xFFDAA520).withOpacity(0.7),  // Darker gold normally
                    width: 2.5,
                  ) : null,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.theme.primaryColor.withOpacity(_isHovered || widget.isSelected ? 0.95 : 0.8),
                      widget.theme.secondaryColor.withOpacity(_isHovered || widget.isSelected ? 0.95 : 0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.theme.primaryColor.withOpacity(widget.isSelected ? 0.3 : 0.1),
                      blurRadius: _isHovered ? 12 : 8,
                      offset: const Offset(0, 4),
                      spreadRadius: _isHovered ? 1 : 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.theme.frontIcon,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.theme.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
