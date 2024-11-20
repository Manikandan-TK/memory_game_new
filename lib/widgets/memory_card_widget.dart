import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../providers/card_theme_provider.dart';
import '../controllers/card_animation_controller.dart';
import 'card_face.dart';

class MemoryCardWidget extends StatefulWidget {
  final MemoryCard card;
  final VoidCallback onTap;
  final double? size;

  const MemoryCardWidget({
    Key? key,
    required this.card,
    required this.onTap,
    this.size,
  }) : super(key: key);

  @override
  State<MemoryCardWidget> createState() => _MemoryCardWidgetState();
}

class _MemoryCardWidgetState extends State<MemoryCardWidget> with SingleTickerProviderStateMixin {
  late final CardAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = CardAnimationController(
      vsync: this,
      initiallyFlipped: widget.card.isFlipped || widget.card.isMatched,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleCardTap() {
    if (!widget.card.isMatched) {
      _animationController.flipCard();
      widget.onTap();
    }
  }

  @override
  void didUpdateWidget(MemoryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.isFlipped != oldWidget.card.isFlipped) {
      _animationController.flipCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _animationController,
      builder: (context, child) {
        final cardTheme = context.watch<CardThemeProvider>().currentTheme;
        
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(pi * _animationController.flipAnimation.value),
          alignment: Alignment.center,
          child: _animationController.showFrontSide
              ? CardFace(
                  card: widget.card,
                  cardTheme: cardTheme,
                  isFront: true,
                  size: widget.size,
                  onTap: _handleCardTap,
                  isFlipped: widget.card.isFlipped,
                )
              : Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: CardFace(
                    card: widget.card,
                    cardTheme: cardTheme,
                    isFront: false,
                    size: widget.size,
                    onTap: _handleCardTap,
                    isFlipped: widget.card.isFlipped,
                  ),
                ),
        );
      },
    );
  }
}
