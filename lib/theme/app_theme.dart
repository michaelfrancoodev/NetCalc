import 'package:flutter/material.dart';

class AppTheme {
  // Mockup-inspired Light Palette
  static const Color background    = Color(0xFFF6F8FD);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color displayBg     = Color(0xFFF0F3FF);
  
  static const Color textDark      = Color(0xFF1D1D21);
  static const Color textGrey      = Color(0xFF7E8494);
  static const Color textBlue      = Color(0xFF4C84FF);
  
  static const Color primaryBlue   = Color(0xFF4C84FF);
  static const Color primaryPurple = Color(0xFF9061FF);
  
  static const Color accentOrange  = Color(0xFFFFEAD2);
  static const Color accentPink    = Color(0xFFFFE2E2);
  static const Color textOrange    = Color(0xFFFF9500);
  static const Color textPink      = Color(0xFFFF3B30);

  // Compatibility Aliases
  static const Color neonCyan      = primaryBlue;
  static const Color neonPink      = textPink;
  static const Color neonPurple    = primaryPurple;
  static const Color neonBlue      = primaryBlue;
  static const Color darkBlueBg    = background;
  static const Color deepPurple    = background;
  static const Color cardDark      = surface;
  static const Color textWhite     = textDark;
  static const Color textDim       = textGrey;
  static const Color textSubdued   = Color(0x661D1D21);
  static const Color obsidianBg    = background;
  static const Color surfaceDark   = surface;
  static const Color electricBlue  = primaryBlue;
  static const Color dangerRed     = textPink;
  static const Color softGrey      = textGrey;

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryBlue, primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mainBackground = LinearGradient(
    colors: [Color(0xFFF1F4FB), Color(0xFFFBFBFE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient displayGradient = LinearGradient(
    colors: [
      Color(0xFFF9FBFF),
      Color(0xFFF0F3FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient glassButton(Color tint) {
    return LinearGradient(
      colors: [
        tint.withOpacity(0.12),
        tint.withOpacity(0.04),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryPurple,
        surface: surface,
        error: textPink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textDark, fontFamily: 'Roboto'),
        bodyMedium: TextStyle(color: textGrey, fontFamily: 'Roboto'),
        titleLarge: TextStyle(
            color: textDark, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      ),
      dividerColor: Colors.black12,
      cardColor: surface,
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
