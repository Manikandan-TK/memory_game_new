import 'package:flutter/material.dart' hide CardTheme;
import '../models/card_model.dart';
import '../models/card_theme.dart';

/// Represents a single side (face) of the memory card
class CardFace extends StatelessWidget {
  final MemoryCard card;
  final CardTheme cardTheme;
  final bool isFront;
  final double? size;
  final bool isFlipped;

  const CardFace({
    Key? key,
    required this.card,
    required this.cardTheme,
    required this.isFront,
    this.size,
    required this.isFlipped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardSize = size ?? 100.0;
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    
    return Container(
      width: cardSize,
      height: cardSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardSize * 0.12),  // Proportional border radius
        border: Border.all(
          color: card.isMatched ? Colors.green : cardTheme.primaryColor,
          width: isSmallScreen ? 2.0 : 2.5,
        ),
        color: isFront ? cardTheme.primaryColor : cardTheme.secondaryColor,
        boxShadow: [
          BoxShadow(
            color: cardTheme.primaryColor.withOpacity(0.2),
            blurRadius: cardSize * 0.04,  // Proportional blur
            offset: Offset(0, cardSize * 0.02),  // Proportional offset
          ),
        ],
      ),
      child: isFront
          ? Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.all(cardSize * 0.04),  // Minimal padding for maximum emoji size
                  child: Text(
                    card.emoji,
                    style: TextStyle(
                      fontSize: cardSize * (isSmallScreen ? 0.9 : 0.95),  // Maximum practical emoji size
                      height: 1,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
