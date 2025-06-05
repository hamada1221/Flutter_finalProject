import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF1F241F), // Dark Green
  scaffoldBackgroundColor: const Color(0xFFC5EFCB), // Light Green
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1F241F),
    secondary: Color(0xFF020402), // Near Black
    surface: Color(0xFFC5EFCB),
    onPrimary: Colors.white,
    onSecondary: Color(0xFFC5EFCB),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF1F241F),
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1F241F),
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 16,
      color: const Color(0xFF1F241F),
    ),
    labelLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1F241F),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      elevation: 4,
      textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF1F241F)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF1F241F)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF020402), width: 2),
    ),
    labelStyle: GoogleFonts.roboto(color: const Color(0xFF1F241F)),
  ),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
    color: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF020402),
    foregroundColor: Color(0xFFC5EFCB),
    elevation: 2,
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFFC5EFCB),
    ),
  ),
);
