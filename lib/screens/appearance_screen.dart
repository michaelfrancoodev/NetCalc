import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  String _buttonShape = 'Rounded';
  // We store the accent color index
  int _accentIndex = 0;

  final List<Color> _accents = const [
    AppTheme.primaryBlue,
    AppTheme.primaryPurple,
    AppTheme.accentGreen,
    AppTheme.accentOrange,
    AppTheme.primaryPink,
    Color(0xFFFF3B30),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _buttonShape = p.getString('button_shape') ?? 'Rounded';
        _accentIndex = p.getInt('accent_index') ?? 0;
      });
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString('button_shape', _buttonShape);
      await p.setInt('accent_index', _accentIndex);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainBackground),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.textDark, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Appearance',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark)),
                  ],
                ),
              ),
              const Divider(color: Colors.black12, height: 1),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ── Accent Color ──────────────────────────────────────
                    _sectionHeader('Accent Color'),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(_accents.length, (i) {
                          final sel = _accentIndex == i;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _accentIndex = i);
                              _save();
                            },
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
                                            color: _accents[i].withValues(alpha: 0.5),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10)
                        ],
                      ),
                      child: Row(
                        children:
                            ['Rounded', 'Square', 'Pill'].map((s) {
                          final active = _buttonShape == s;
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _buttonShape = s);
                                  _save();
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: active
                                        ? AppTheme.primaryBlue
                                        : AppTheme.surface,
                                    borderRadius: BorderRadius.circular(
                                        s == 'Pill' ? 22 : s == 'Square' ? 4 : 12),
                                  ),
                                  child: Center(
                                    child: Text(s,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: active
                                                ? Colors.white
                                                : AppTheme.textGrey,
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
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
                                gradient: isOp ? null : null,
                                color: isOp
                                    ? const Color(0xFFE3F2FD)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                    _buttonShape == 'Pill'
                                        ? 28
                                        : _buttonShape == 'Square'
                                            ? 4
                                            : 16),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
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
                                            ? _accents[_accentIndex]
                                            : AppTheme.textDark)),
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
  }

  Widget _sectionHeader(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 2),
        child: Text(t,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppTheme.textGrey)),
      );
}
