import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NflScoreboardApp());
}

class NflScoreboardApp extends StatelessWidget {
  const NflScoreboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NFL Scoreboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF123B63),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
