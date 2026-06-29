import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/settings_manager.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  final List<Color> _accents = const [
    AppTheme.primaryBlue,
    AppTheme.primaryPurple,
    AppTheme.accentGreen,
    AppTheme.accentOrange,
    AppTheme.primaryPink,
    Color(0xFFFF3B30),
  ];

  @override
  Widget build(BuildContext context) {
    final manager = SettingsManager();

    return ListenableBuilder(
      listenable: manager,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : AppTheme.textDark;
        final cardColor = isDark ? const Color(0xFF1C2128) : Colors.white;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            decoration: BoxDecoration(
                gradient: isDark ? null : AppTheme.mainBackground),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              color: textColor, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text('Appearance',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: textColor)),
                      ],
                    ),
                  ),
                  Divider(color: isDark ? Colors.white10 : Colors.black12, height: 1),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // ── Theme Mode ────────────────────────────────────────
                        _sectionHeader('Theme Mode'),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Row(
                            children: [
                              _themeItem(context, 'System', ThemeMode.system, Icons.brightness_auto_rounded, manager),
                              _themeItem(context, 'Light', ThemeMode.light, Icons.light_mode_rounded, manager),
                              _themeItem(context, 'Dark', ThemeMode.dark, Icons.dark_mode_rounded, manager),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Accent Color ──────────────────────────────────────
                        _sectionHeader('Accent Color'),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(_accents.length, (i) {
                              final sel = manager.accentIndex == i;
                              return GestureDetector(
                                onTap: () => manager.setAccentIndex(i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: _accents[i],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: sel ? Colors.white : Colors.transparent,
                                      width: 3,
                                    ),
                                    boxShadow: sel
                                        ? [
                                            BoxShadow(
                                                color: _accents[i].withOpacity(0.5),
                                                blurRadius: 8)
                                          ]
                                        : [],
                                  ),
                                  child: sel
                                      ? const Icon(Icons.check_rounded,
                                          color: Colors.white, size: 18)
                                      : null,
                                ),
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Button Shape ──────────────────────────────────────
                        _sectionHeader('Button Shape'),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Row(
                            children:
                                ['Rounded', 'Square', 'Pill'].map((s) {
                              final active = manager.buttonShape == s;
                              return Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: GestureDetector(
                                    onTap: () => manager.setButtonShape(s),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? manager.accentColor
                                            : (isDark ? Colors.white10 : AppTheme.surface),
                                        borderRadius: BorderRadius.circular(
                                            s == 'Pill' ? 22 : s == 'Square' ? 4 : 12),
                                      ),
                                      child: Center(
                                        child: Text(s,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: active
                                                    ? Colors.white
                                                    : (isDark ? Colors.white70 : AppTheme.textGrey),
                                                fontSize: 13)),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Preview ───────────────────────────────────────────
                        _sectionHeader('Preview'),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: ['7', '8', '9', '÷'].map((b) {
                              final isOp = b == '÷';
                              return Padding(
                                padding: const EdgeInsets.all(6),
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: isOp
                                        ? manager.accentColor.withOpacity(0.1)
                                        : (isDark ? const Color(0xFF2D333B) : Colors.white),
                                    borderRadius: manager.buttonBorderRadius,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4))
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(b,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: isOp
                                                ? manager.accentColor
                                                : textColor)),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 2),
        child: Text(t,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppTheme.textGrey)),
      );

  Widget _themeItem(BuildContext context, String label, ThemeMode mode, IconData icon, SettingsManager manager) {
    final active = manager.themeMode == mode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => manager.setThemeMode(mode),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: active ? manager.accentColor : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: active ? Colors.white : (isDark ? Colors.white70 : Colors.black54), size: 24),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black87)),
          ],
        ),
      ),
    );
  }
}
