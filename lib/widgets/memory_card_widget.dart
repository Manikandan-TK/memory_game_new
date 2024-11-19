import 'package:flutter/material.dart' hide CardTheme;
import 'dart:math';
import '../models/card_model.dart';
import 'package:provider/provider.dart';
import '../providers/card_theme_provider.dart';
import '../widgets/card_pattern_painter.dart';
import '../utils/logger.dart';

class MemoryCardWidget extends StatefulWidget {
  final MemoryCard card;
  final VoidCallback onTap;
  final double? size;

  const MemoryCardWidget({
    super.key,
    required this.card,
    required this.onTap,
    this.size,
  });

  @override
  State<MemoryCardWidget> createState() => _MemoryCardWidgetState();
}

class _MemoryCardWidgetState extends State<MemoryCardWidget> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<MemoryCardWidget> {
  late final AnimationController _controller;
  late final Animation<double> _flipAnimation;
  late final Animation<double> _scaleAnimation;
  bool _showFrontSide = false;

  @override
  bool get wantKeepAlive => widget.card.isMatched || widget.card.isFlipped;

  void _onFlipAnimationChanged() {
    if (!mounted) return; // Safety check
    
    // Only log when animation reaches key points
    if (_flipAnimation.value == 1.0 || _flipAnimation.value == 0.0) {
      GameLogger.d('Flip animation completed: ${_flipAnimation.value}');
    }
    
    if (_flipAnimation.value > 0.5 && !_showFrontSide) {
      GameLogger.d('Card flipped to front');
      setState(() => _showFrontSide = true);
    } else if (_flipAnimation.value <= 0.5 && _showFrontSide) {
      GameLogger.d('Card flipped to back');
      setState(() => _showFrontSide = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _showFrontSide = widget.card.isFlipped || widget.card.isMatched;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      value: widget.card.isFlipped || widget.card.isMatched ? 1.0 : 0.0,
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.1),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0),
        weight: 0.5,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _flipAnimation.addListener(_onFlipAnimationChanged);
  }

  @override
  void didUpdateWidget(MemoryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update keep alive state if needed
    if (oldWidget.card.isMatched != widget.card.isMatched ||
        oldWidget.card.isFlipped != widget.card.isFlipped) {
      updateKeepAlive();
    }

    if (widget.card.isFlipped != oldWidget.card.isFlipped) {
      GameLogger.d('Card flip state changed: ${widget.card.isFlipped}');
      if (widget.card.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipAnimation.removeListener(_onFlipAnimationChanged);
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;
    final cardTheme = context.watch<CardThemeProvider>().currentTheme;
    
    final matchedGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.green.shade300,
        Colors.green.shade100,
        Colors.green.shade200,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final flippedGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        cardTheme.primaryColor,
        cardTheme.primaryColor.withOpacity(0.8),
        cardTheme.secondaryColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final unflippedGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colorScheme.surfaceContainerHighest,
        colorScheme.surface,
        colorScheme.surfaceContainerHighest,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..scale(_scaleAnimation.value)
            ..rotateY(pi * _flipAnimation.value),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: RepaintBoundary(
              child: Material(
                elevation: widget.card.isFlipped ? 8 : 2,
                shadowColor: widget.card.isMatched
                    ? Colors.green.withOpacity(0.5)
                    : colorScheme.shadow.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: widget.card.isMatched ? null : widget.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.card.isMatched
                            ? Colors.green.shade300
                            : widget.card.isFlipped
                                ? cardTheme.primaryColor
                                : colorScheme.outline.withOpacity(0.2),
                        width: 2,
                      ),
                      gradient: widget.card.isMatched
                          ? matchedGradient
                          : _showFrontSide
                              ? flippedGradient
                              : unflippedGradient,
                      boxShadow: widget.card.isMatched
                          ? [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Transform(
                        transform: Matrix4.identity()
                          ..rotateY(_showFrontSide ? 0 : pi),
                        alignment: Alignment.center,
                        child: _showFrontSide
                            ? Text(
                                widget.card.emoji,
                                style: TextStyle(
                                  fontSize: widget.size != null ? widget.size! * 0.7 : 32,
                                ),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
