import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cores_app.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: CoresApp.background,
    primaryColor: CoresApp.yellow,
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: CoresApp.yellow,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
          color: CoresApp.textWhite,
      ),
      bodyLarge: const TextStyle( // Texto principal
        fontSize: 16,
        color: CoresApp.textcinza,
      ),
      bodyMedium: const TextStyle( // Texto secundário
        fontSize: 14,
        color: CoresApp.textcinza,
      ),
      labelLarge: GoogleFonts.inter( // Para botões e badges
        fontWeight: FontWeight.bold,
        color: CoresApp.textBlack,
      ),
    ),
  );
}