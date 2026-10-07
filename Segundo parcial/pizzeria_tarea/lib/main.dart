import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/pizzeria_provider.dart';
import 'screens/role_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PizzeriaProvider(),
      child: const PizzeriaApp(),
    ),
  );
}

class PizzeriaApp extends StatelessWidget {
  const PizzeriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizza LeDo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC62828),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFC62828),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: const RoleScreen(),
    );
  }
}
