import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const url = String.fromEnvironment('SUPABASE_URL');
  const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (url.isEmpty || anonKey.isEmpty) {
    runApp(const MissingConfigApp());
    return;
  }

  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
  );

  runApp(const BibliotecaCancionesApp());
}

class BibliotecaCancionesApp extends StatelessWidget {
  const BibliotecaCancionesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Biblioteca',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        scaffoldBackgroundColor: const Color(0xFFF7F5FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(width: 1.5),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class MissingConfigApp extends StatelessWidget {
  const MissingConfigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Faltan las variables SUPABASE_URL y SUPABASE_ANON_KEY.\n\n'
              'Ejecuta la app con --dart-define para configurarlas.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }
}
