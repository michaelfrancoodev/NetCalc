import 'package:flutter/material.dart';

class AppTheme {
  // ── Core Brand Colors ──────────────────────────────────────────────────────
  static const Color primaryBlue   = Color(0xFF4C84FF);
  static const Color primaryPurple = Color(0xFF9061FF);
  static const Color primaryPink   = Color(0xFFFF6B9D);
  static const Color accentGreen   = Color(0xFF00C896);
  static const Color accentOrange  = Color(0xFFFF8C42);

  // ── Neutral Palette ────────────────────────────────────────────────────────
  static const Color background  = Color(0xFFF6F8FD);
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color displayBg   = Color(0xFFF0F3FF);

  static const Color textDark    = Color(0xFF1D1D21);
  static const Color textGrey    = Color(0xFF7E8494);
  static const Color textBlue    = Color(0xFF4C84FF);
  static const Color textOrange  = Color(0xFFFF9500);
  static const Color textPink    = Color(0xFFFF3B30);

  // ── Compatibility Aliases (kept for all screens that use them) ─────────────
  static const Color neonCyan    = primaryBlue;
  static const Color neonPink    = textPink;
  static const Color neonPurple  = primaryPurple;
  static const Color neonBlue    = primaryBlue;

  // Aliases used by history/help/about/settings that expect dark/light names
  static const Color textWhite   = Color(0xFF1D1D21);   // Maps to textDark on light theme
  static const Color textDim     = Color(0xFF7E8494);   // Maps to textGrey
  static const Color textSubdued = Color(0x661D1D21);

  static const Color darkBlueBg  = background;
  static const Color deepPurple  = background;
  static const Color cardDark    = surface;
  static const Color obsidianBg  = background;
  static const Color surfaceDark = surface;
  static const Color electricBlue = primaryBlue;
  static const Color dangerRed   = textPink;
  static const Color softGrey    = textGrey;

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryBlue, primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Used by Splash screen background
  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF1A1F35), Color(0xFF0D1117)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient mainBackground = LinearGradient(
    colors: [Color(0xFFF1F4FB), Color(0xFFFBFBFE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient displayGradient = LinearGradient(
    colors: [Color(0xFFF9FBFF), Color(0xFFF0F3FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient glassButton(Color tint) => LinearGradient(
    colors: [tint.withValues(alpha: 0.12), tint.withValues(alpha: 0.04)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Light Theme ────────────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
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
      titleLarge: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
    ),
    dividerColor: Colors.black12,
    cardColor: surface,
  );

  static ThemeData get darkTheme => lightTheme;
}
