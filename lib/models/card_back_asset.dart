import 'package:flutter/material.dart';

/// Abstract class defining how to get card back assets
abstract class CardBackAsset {
  String get assetPath;
  Color get borderColor;
  Color get backgroundColor;
}

/// Implementation for themed card backs
class ThemedCardBackAsset implements CardBackAsset {
  final String _assetPath;
  final Color _borderColor;
  final Color _backgroundColor;

  @override
  String get assetPath => _assetPath;

  @override
  Color get borderColor => _borderColor;

  @override
  Color get backgroundColor => _backgroundColor;

  const ThemedCardBackAsset({
    required String assetPath,
    required Color borderColor,
    required Color backgroundColor,
  })  : _assetPath = assetPath,
        _borderColor = borderColor,
        _backgroundColor = backgroundColor;
}
