import 'package:flutter/material.dart';
import 'animations/card_animation_mixin.dart';
import 'animations/card_animation_builder.dart';
import '../models/game_config.dart';

/// Represents a single side (face) of the memory card
class CardFace extends StatefulWidget {
  final bool isFlipped;
  final bool isMatched;
  final Widget front;
  final Widget back;
  final double size;
  final Color glowColor;
  final GameDifficulty difficulty;

  const CardFace({
    Key? key,
    required this.isFlipped,
    required this.isMatched,
    required this.front,
    required this.back,
    required this.size,
    required this.difficulty,
    this.glowColor = Colors.green,
  }) : super(key: key);

  @override
  State<CardFace> createState() => _CardFaceState();
}

class _CardFaceState extends State<CardFace> with TickerProviderStateMixin, CardAnimationMixin<CardFace> {
  bool _wasFlipped = false;
  bool _wasMatched = false;

  @override
  GameDifficulty get difficulty => widget.difficulty;

  @override
  void didUpdateWidget(CardFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleCardStateChange(
      isFlipped: widget.isFlipped,
      wasFlipped: _wasFlipped,
      isMatched: widget.isMatched,
      wasMatched: _wasMatched,
    );
    _wasFlipped = widget.isFlipped;
    _wasMatched = widget.isMatched;
  }

  @override
  Widget build(BuildContext context) {
    return CardAnimationBuilder(
      controller: animationController,
      isFlipped: widget.isFlipped,
      isMatched: widget.isMatched,
      glowColor: widget.glowColor,
      cardSize: widget.size,
      difficulty: widget.difficulty,
      child: widget.isFlipped ? widget.front : widget.back,
    );
  }
}
