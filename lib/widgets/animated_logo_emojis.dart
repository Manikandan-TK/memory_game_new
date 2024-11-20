import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedLogoEmojis extends StatefulWidget {
  const AnimatedLogoEmojis({super.key});

  @override
  State<AnimatedLogoEmojis> createState() => _AnimatedLogoEmojisState();
}

class _AnimatedLogoEmojisState extends State<AnimatedLogoEmojis> {
  // Animal emojis that match the game theme
  final List<String> emojis = ['🦊', '🐼', '🦊', '🐼'];
  final List<bool> isFlipped = [false, false, false, false];
  final List<bool> isMatched = [false, false, false, false];
  Timer? _timer;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        switch (_currentStep % 6) {
          case 0:
            isFlipped[0] = true;
            break;
          case 1:
            isFlipped[2] = true;
            break;
          case 2:
            // Match found
            isMatched[0] = true;
            isMatched[2] = true;
            break;
          case 3:
            isFlipped[1] = true;
            break;
          case 4:
            isFlipped[3] = true;
            break;
          case 5:
            // Match found
            isMatched[1] = true;
            isMatched[3] = true;
            // Reset after complete cycle
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  for (int i = 0; i < 4; i++) {
                    isFlipped[i] = false;
                    isMatched[i] = false;
                  }
                });
              }
            });
            break;
        }
        _currentStep++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Create darker base colors for the gradient
    final darkPrimary = HSLColor.fromColor(theme.colorScheme.primary)
        .withLightness(0.15) // Darken the primary color
        .toColor();
    final darkSecondary = HSLColor.fromColor(theme.colorScheme.secondary)
        .withLightness(0.15) // Darken the secondary color
        .toColor();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            darkPrimary.withOpacity(0.95),
            darkSecondary.withOpacity(0.95),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateY(isFlipped[index] ? 0 : 3.14),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isMatched[index]
                      ? darkPrimary.withOpacity(0.95)
                      : isFlipped[index]
                          ? darkSecondary.withOpacity(0.9)
                          : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isMatched[index]
                        ? theme.colorScheme.primary.withOpacity(0.6)
                        : isFlipped[index]
                            ? theme.colorScheme.secondary.withOpacity(0.4)
                            : Colors.white.withOpacity(0.15),
                    width: isFlipped[index] ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: isMatched[index] ? 8 : 4,
                      spreadRadius: isMatched[index] ? 1 : 0,
                      offset: const Offset(0, 2),
                    ),
                    if (isMatched[index])
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: -2,
                      ),
                  ],
                ),
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isFlipped[index] ? 1.0 : 0.0,
                    child: Text(
                      emojis[index],
                      style: TextStyle(
                        fontSize: 28, // Slightly larger for better visibility
                        shadows: [
                          if (isMatched[index])
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.5),
                              blurRadius: 16,
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
