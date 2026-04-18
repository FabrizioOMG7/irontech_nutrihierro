import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales de IronTech NutriHierro
  static const Color primaryRed = Color(0xFFC62828); // Rojo Hierro (basado en el logo)
  static const Color secondaryOrange = Color(0xFFEF6C00); // Naranja cálido (energía/niños)
  static const Color backgroundLight = Color(0xFFF9FAFB); // Fondo limpio
  static const Color textDark = Color(0xFF1F2937); // Texto oscuro para lectura fácil
  static const Color textLight = Color(0xFF6B7280); // Texto secundario

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        primary: primaryRed,
        secondary: secondaryOrange,
        background: backgroundLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      
      // Tipografía limpia y amigable
      fontFamily: 'Roboto', // Flutter lo usa por defecto, luego podemos poner GoogleFonts
      
      // Estilo global de las tarjetas (Tarjetas informativas)
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      
      // Estilo global de los botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      
      // Estilo global de la barra superior (AppBar)
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}