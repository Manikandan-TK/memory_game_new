import 'package:flutter/material.dart' hide CardTheme;
import '../models/card_model.dart';
import '../providers/card_theme_provider.dart';
import '../widgets/card_pattern_painter.dart';
import '../models/card_theme.dart';

/// Represents a single side (face) of the memory card
class CardFace extends StatelessWidget {
  final MemoryCard card;
  final CardTheme cardTheme;
  final bool isFront;
  final double? size;
  final VoidCallback? onTap;
  final bool isFlipped;

  const CardFace({
    Key? key,
    required this.card,
    required this.cardTheme,
    required this.isFront,
    this.size,
    this.onTap,
    required this.isFlipped,
  }) : super(key: key);

  Color _getBorderColor(ColorScheme colorScheme) {
    if (card.isMatched) {
      return Colors.green;
    }
    return isFlipped
        ? cardTheme.primaryColor
        : colorScheme.outline;
  }

  List<BoxShadow>? _getBoxShadow() {
    if (!isFlipped && !card.isMatched) return null;

    return [
      BoxShadow(
        color: card.isMatched
            ? Colors.green.withOpacity(0.3)
            : cardTheme.primaryColor.withOpacity(0.3),
        blurRadius: 8,
        spreadRadius: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: RepaintBoundary(
        child: Material(
          elevation: isFlipped ? 8 : 2,
          shadowColor: card.isMatched
              ? Colors.green.withOpacity(0.5)
              : colorScheme.shadow.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getBorderColor(colorScheme),
                  width: 2,
                ),
                color: cardTheme.primaryColor.withOpacity(0.1),
                boxShadow: _getBoxShadow(),
              ),
              child: isFront
                  ? Stack(
                      children: [
                        CustomPaint(
                          painter: CardPatternPainter(
                            primaryColor: cardTheme.primaryColor,
                            secondaryColor: cardTheme.secondaryColor,
                            themeType: cardTheme.type,
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  card.emoji,
                                  style: TextStyle(
                                    fontSize: size != null ? size! * 0.85 : 40,
                                    height: 1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : CustomPaint(
                      painter: CardPatternPainter(
                        primaryColor: cardTheme.primaryColor,
                        secondaryColor: cardTheme.secondaryColor,
                        themeType: cardTheme.type,
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
