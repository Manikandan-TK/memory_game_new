import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'providers/card_theme_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'package:logging/logging.dart';
import 'utils/logger.dart';

void main() {
  GameLogger.init(level: Level.INFO);  // Changed from Level.ALL to Level.INFO
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => CardThemeProvider()),
      ],
      child: MaterialApp(
        title: 'Memory Game',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        home: const HomeScreen(),
      ),
    );
  }
}
