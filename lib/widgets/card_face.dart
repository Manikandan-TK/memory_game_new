import 'package:flutter/material.dart' hide CardTheme;
import 'dart:math' as math;
import '../models/card_model.dart';
import '../models/card_theme.dart';

/// Represents a single side (face) of the memory card
class CardFace extends StatefulWidget {
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
  State<CardFace> createState() => _CardFaceState();
}

class _CardFaceState extends State<CardFace> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600), // Faster, smoother animation
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // Slightly bouncy flip
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15), // Subtle scale up
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 0.95), // Slight bounce back
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0), // Smooth return
        weight: 35,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
    ));

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.4), // Subtle initial glow
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.4, end: 0.2), // Fade slightly
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 0.3), // Maintain soft glow
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
    ));

    // Start animation if card is already matched
    if (widget.card.isMatched) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CardFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle flip animation
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    
    // Handle match animation - reset and replay for both cards
    if (widget.card.isMatched && !oldWidget.card.isMatched) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardSize = widget.size ?? 100.0;
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002) // Perspective
            ..rotateY(widget.isFlipped ? math.pi * _flipAnimation.value : 0),
          alignment: Alignment.center,
          child: Transform.scale(
            scale: widget.card.isMatched ? _scaleAnimation.value : 1.0,
            child: Container(
              width: cardSize,
              height: cardSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cardSize * 0.12),
                border: Border.all(
                  color: widget.card.isMatched 
                      ? Colors.green 
                      : widget.cardTheme.primaryColor,
                  width: isSmallScreen ? 2.0 : 2.5,
                ),
                color: widget.isFront 
                    ? widget.cardTheme.primaryColor 
                    : widget.cardTheme.secondaryColor,
                boxShadow: [
                  BoxShadow(
                    color: widget.card.isMatched
                        ? Colors.green.withOpacity(_glowAnimation.value)
                        : widget.cardTheme.primaryColor.withOpacity(0.2),
                    blurRadius: widget.card.isMatched
                        ? cardSize * 0.2 // More subtle blur
                        : cardSize * 0.04,
                    spreadRadius: widget.card.isMatched ? 4 : 0, // Reduced spread
                    offset: Offset(0, cardSize * 0.02),
                  ),
                ],
              ),
              child: widget.isFront
                  ? Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: EdgeInsets.all(cardSize * 0.04),
                          child: Text(
                            widget.card.emoji,
                            style: TextStyle(
                              fontSize: cardSize * (isSmallScreen ? 0.9 : 0.95),
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
