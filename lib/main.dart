import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

const _mint = Color(0xFF98F5C4);
const _offWhite = Color(0xFFF8F5EE);
const _charcoal = Color(0xFF1F2522);
const _purple = Color(0xFF7B4DFF);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frontier Dives',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: _mint,
          onPrimary: _charcoal,
          secondary: _purple,
          onSecondary: Colors.white,
          tertiary: const Color(0xFFB9E8D0),
          onTertiary: _charcoal,
          error: const Color(0xFFB00020),
          onError: Colors.white,
          surface: _offWhite,
          onSurface: _charcoal,
        ),
        scaffoldBackgroundColor: _offWhite,
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
            color: _charcoal,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: _charcoal,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: _charcoal,
          ),
          titleLarge: TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: _charcoal,
          ),
          titleMedium: TextStyle(
            fontFamily: 'serif',
            fontWeight: FontWeight.w600,
            color: _charcoal,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'serif',
            height: 1.55,
            color: _charcoal,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'serif',
            height: 1.55,
            color: _charcoal,
          ),
          labelLarge: TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: _charcoal,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}