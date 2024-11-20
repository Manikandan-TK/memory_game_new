import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../providers/card_theme_provider.dart';
import 'card_face.dart';
import 'card_back_widget.dart';

class MemoryCardWidget extends StatelessWidget {
  final MemoryCard card;
  final double? size;
  final VoidCallback onTap;

  const MemoryCardWidget({
    Key? key,
    required this.card,
    this.size,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardTheme = context.watch<CardThemeProvider>().currentTheme;
    final cardSize = size ?? 100.0;
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return GestureDetector(
      onTap: onTap,
      child: CardFace(
        isFlipped: card.isFlipped,
        isMatched: card.isMatched,
        size: cardSize,
        front: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: EdgeInsets.all(cardSize * 0.04),
              child: Text(
                card.emoji,
                style: TextStyle(
                  fontSize: cardSize * (isSmallScreen ? 0.9 : 0.95),
                  height: 1,
                ),
              ),
            ),
          ),
        ),
        back: CardBackWidget(
          cardBackAsset: cardTheme.cardBackAsset,
          size: cardSize,
          isSmallScreen: isSmallScreen,
        ),
      ),
    );
  }
}
