import 'package:flutter/material.dart';

enum CardThemeType {
  classic,
  geometric,
  nature,
  space,
  tech
}

class CardTheme {
  final String name;
  final CardThemeType type;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData frontIcon;
  final String? imagePath;
  final bool useCustomPainter;

  const CardTheme({
    required this.name,
    required this.type,
    required this.primaryColor,
    required this.secondaryColor,
    required this.frontIcon,
    this.imagePath,
    this.useCustomPainter = false,
  });

  factory CardTheme.classic() => const CardTheme(
    name: 'Classic',
    type: CardThemeType.classic,
    primaryColor: Colors.blue,
    secondaryColor: Colors.lightBlue,
    frontIcon: Icons.star,
    useCustomPainter: true,
  );

  factory CardTheme.geometric() => const CardTheme(
    name: 'Geometric',
    type: CardThemeType.geometric,
    primaryColor: Colors.purple,
    secondaryColor: Colors.deepPurple,
    frontIcon: Icons.shape_line,
    useCustomPainter: true,
  );

  factory CardTheme.nature() => const CardTheme(
    name: 'Nature',
    type: CardThemeType.nature,
    primaryColor: Colors.green,
    secondaryColor: Colors.lightGreen,
    frontIcon: Icons.eco,
  );

  factory CardTheme.space() => const CardTheme(
    name: 'Space',
    type: CardThemeType.space,
    primaryColor: Colors.indigo,
    secondaryColor: Colors.deepPurple,
    frontIcon: Icons.stars,
  );

  factory CardTheme.tech() => const CardTheme(
    name: 'Tech',
    type: CardThemeType.tech,
    primaryColor: Colors.cyan,
    secondaryColor: Colors.teal,
    frontIcon: Icons.computer,
  );
}
