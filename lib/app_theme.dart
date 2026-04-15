import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cores_app.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: CoresApp.background,
    primaryColor: CoresApp.primary,
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: CoresApp.primary,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
          color: CoresApp.textHighContrast,
      ),
      bodyLarge: const TextStyle( // Texto principal
        fontSize: 16,
        color: CoresApp.textMedContrast,
      ),
      bodyMedium: const TextStyle( // Texto secundário
        fontSize: 14,
        color: CoresApp.textMedContrast,
      ),
      labelLarge: GoogleFonts.inter( // Para botões e badges
        fontWeight: FontWeight.bold,
        color: CoresApp.textOnDarkContainer,
      ),
    ),
  );
}