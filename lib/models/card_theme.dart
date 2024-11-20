import 'package:flutter/material.dart';
import 'card_back_asset.dart';
import 'theme_identifier.dart';

/// Represents a theme for memory cards
class CardTheme {
  final ThemeIdentifier identifier;
  final CardBackAsset cardBackAsset;

  const CardTheme({
    required this.identifier,
    required this.cardBackAsset,
  });

  String get name => identifier.name;

  // Predefined themes
  static const classic = CardTheme(
    identifier: ThemeIdentifier.classic,
    cardBackAsset: ThemedCardBackAsset(
      assetPath: 'assets/images/card_backs/classic_back.webp',
      borderColor: Colors.blue,
      backgroundColor: Colors.white,
    ),
  );

  static const geometry = CardTheme(
    identifier: ThemeIdentifier.geometry,
    cardBackAsset: ThemedCardBackAsset(
      assetPath: 'assets/images/card_backs/geometry_back.webp',
      borderColor: Colors.teal,
      backgroundColor: Colors.white,
    ),
  );

  static const nature = CardTheme(
    identifier: ThemeIdentifier.nature,
    cardBackAsset: ThemedCardBackAsset(
      assetPath: 'assets/images/card_backs/nature_back.webp',
      borderColor: Colors.green,
      backgroundColor: Colors.white,
    ),
  );

  static const space = CardTheme(
    identifier: ThemeIdentifier.space,
    cardBackAsset: ThemedCardBackAsset(
      assetPath: 'assets/images/card_backs/space_back.webp',
      borderColor: Colors.purple,
      backgroundColor: Colors.white,
    ),
  );

  static const tech = CardTheme(
    identifier: ThemeIdentifier.tech,
    cardBackAsset: ThemedCardBackAsset(
      assetPath: 'assets/images/card_backs/tech_back.webp',
      borderColor: Colors.cyan,
      backgroundColor: Colors.white,
    ),
  );

  static const List<CardTheme> allThemes = [
    classic,
    geometry,
    nature,
    space,
    tech,
  ];

  static CardTheme fromIdentifier(ThemeIdentifier identifier) {
    return allThemes.firstWhere(
      (theme) => theme.identifier == identifier,
      orElse: () => classic,
    );
  }
}
