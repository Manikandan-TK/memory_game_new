import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide CardTheme;
import '../models/card_theme.dart';

class CardThemeProvider with ChangeNotifier {
  CardTheme _currentTheme = CardTheme.classic();
  final List<CardTheme> _availableThemes = [
    CardTheme.classic(),
    CardTheme.geometric(),
    CardTheme.nature(),
    CardTheme.space(),
    CardTheme.tech(),
  ];

  CardTheme get currentTheme => _currentTheme;
  List<CardTheme> get availableThemes => List.unmodifiable(_availableThemes);

  void setTheme(CardTheme theme) {
    if (_currentTheme.type != theme.type) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  void setThemeByType(CardThemeType type) {
    final theme = _availableThemes.firstWhere(
      (t) => t.type == type,
      orElse: () => CardTheme.classic(),
    );
    setTheme(theme);
  }
}
