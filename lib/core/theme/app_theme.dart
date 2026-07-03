import 'package:flutter/material.dart';

class AppTheme {
  // Colores institucionales / culturales
  static const Color primaryColor = Color(0xFF13322B); // Guinda 0xFF621132
  static const Color accentColor = Color(0xFF8C1A3B);  // Verde Jade 0xFF13322B / Turquesa 0xFF26A69A
  static const Color backgroundColor = Color(0xFFF8EBD8); // Crema / Arena claro 0xFFF7F4F0
  // Primario → 0xFF3BBF8C
  // Acento → 0xFF8C1A3B
  // Background → 0xFFF8EBD8
  
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: accentColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}