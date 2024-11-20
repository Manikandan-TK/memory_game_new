import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../providers/card_theme_provider.dart';
import 'card_face.dart';

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

    return GestureDetector(
      onTap: onTap,
      child: CardFace(
        card: card,
        cardTheme: cardTheme,
        isFront: card.isFlipped,
        size: size,
        isFlipped: card.isFlipped,
      ),
    );
  }
}
