import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide CardTheme;
import '../models/card_theme.dart';
import '../models/theme_identifier.dart';

class CardThemeProvider with ChangeNotifier {
  CardTheme _currentTheme = CardTheme.classic;
  final List<CardTheme> _availableThemes = CardTheme.allThemes;

  CardTheme get currentTheme => _currentTheme;
  List<CardTheme> get availableThemes => List.unmodifiable(_availableThemes);

  void setTheme(CardTheme theme) {
    if (_currentTheme.identifier != theme.identifier) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  void setThemeByIdentifier(ThemeIdentifier identifier) {
    final theme = CardTheme.fromIdentifier(identifier);
    setTheme(theme);
  }
}
