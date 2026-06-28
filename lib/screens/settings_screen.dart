import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/local_storage.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _angleMode = 'DEG';
  int _precision = 10;
  bool _haptic = true;
  bool _sound = false;
  String _numberFormat = 'US (1,000.00)';

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
        _angleMode    = p.getString('angle_mode')    ?? 'DEG';
        _precision    = p.getInt('precision')         ?? 10;
        _haptic       = p.getBool('haptic')           ?? true;
        _sound        = p.getBool('sound')            ?? false;
        _numberFormat = p.getString('number_format')  ?? 'US (1,000.00)';
      });
    } catch (_) {
      // SharedPreferences unavailable — keep defaults silently
    }
  }

  Future<void> _save() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString('angle_mode',    _angleMode);
      await p.setInt('precision',         _precision);
      await p.setBool('haptic',           _haptic);
      await p.setBool('sound',            _sound);
      await p.setString('number_format',  _numberFormat);
    } catch (_) {
      // Persist failure is non-fatal — UI already reflects latest state
    }
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
                    const Text(
                      'Settings',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black12, height: 1),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ── Calculator ──────────────────────────────────────────
                    _header('Calculator'),
                    _card([
                      _dropdownTile('Angle Mode', _angleMode,
                          ['DEG', 'RAD', 'GRAD'],
                          (v) { setState(() => _angleMode = v!); _save(); }),
                      const Divider(height: 1),
                      _sliderTile('Decimal Precision', _precision, 2, 15,
                          (v) { setState(() => _precision = v.round()); _save(); }),
                      const Divider(height: 1),
                      _dropdownTile(
                          'Number Format',
                          _numberFormat,
                          ['US (1,000.00)', 'EU (1.000,00)', 'IN (1,00,000)'],
                          (v) { setState(() => _numberFormat = v!); _save(); }),
                    ]),

                    const SizedBox(height: 16),

                    // ── Feedback ───────────────────────────────────────────
                    _header('Feedback'),
                    _card([
                      _switchTile('Haptic Feedback', Icons.vibration_rounded,
                          _haptic, (v) { setState(() => _haptic = v); _save(); }),
                      const Divider(height: 1),
                      _switchTile('Sound Effects', Icons.volume_up_rounded,
                          _sound, (v) { setState(() => _sound = v); _save(); }),
                    ]),

                    const SizedBox(height: 16),

                    // ── Data ───────────────────────────────────────────────
                    _header('Data'),
                    _card([
                      _actionTile(
                        'Clear All History',
                        Icons.delete_sweep_rounded,
                        AppTheme.textPink,
                        () => _confirm(
                          'Clear History',
                          'This will permanently delete all calculation history.',
                          () async {
                            await LocalStorage.clearHistory();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('History cleared'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      _actionTile(
                        'Clear All Favorites',
                        Icons.star_border_rounded,
                        AppTheme.textPink,
                        () => _confirm(
                          'Clear Favorites',
                          'This will permanently delete all saved favorites.',
                          () async {
                            await LocalStorage.clearFavorites();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Favorites cleared'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      _actionTile(
                        'Reset Onboarding',
                        Icons.refresh_rounded,
                        AppTheme.primaryPurple,
                        () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('onboarding_completed', false);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Onboarding reset. Restart the app.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // ── About ──────────────────────────────────────���───────
                    _header('About'),
                    _card([
                      _infoTile(Icons.info_outline_rounded, Colors.black45,
                          'Version', 'NetCalc Pro 1.0.0'),
                      const Divider(height: 1),
                      _infoTile(Icons.code_rounded, Colors.black45,
                          'Built with Flutter', 'Offline • No Ads • No Tracking'),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _header(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          t,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryBlue,
              letterSpacing: 1.4),
        ),
      );

  Widget _card(List<Widget> children) => Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(children: children),
      );

  Widget _switchTile(
          String label, IconData icon, bool val, void Function(bool) onChange) =>
      ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
        ),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        trailing: Switch.adaptive(
            value: val, onChanged: onChange, activeColor: AppTheme.primaryBlue),
      );

  Widget _dropdownTile(String label, String val, List<String> options,
          void Function(String?) onChange) =>
      ListTile(
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        trailing: DropdownButton<String>(
          value: val,
          underline: const SizedBox(),
          style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto'),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: onChange,
        ),
      );

  Widget _sliderTile(String label, int val, int min, int max,
          void Function(double) onChange) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15)),
              const Spacer(),
              Text('$val digits',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryBlue)),
            ]),
            Slider(
              value: val.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              onChanged: onChange,
              activeColor: AppTheme.primaryBlue,
            ),
          ],
        ),
      );

  Widget _actionTile(
          String label, IconData icon, Color color, VoidCallback onTap) =>
      ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 15, color: color)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: Colors.black26),
        onTap: onTap,
      );

  Widget _infoTile(
          IconData icon, Color iconColor, String label, String value) =>
      ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(label,
            style: const TextStyle(
                color: AppTheme.textGrey,
                fontSize: 13,
                fontWeight: FontWeight.w400)),
        trailing: Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppTheme.textDark)),
      );

  Future<void> _confirm(
      String title, String message, Future<void> Function() onConfirm) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(title,
            style: const TextStyle(color: AppTheme.textDark)),
        content: Text(message,
            style: const TextStyle(color: AppTheme.textGrey)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel',
                  style: TextStyle(color: AppTheme.textGrey))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete',
                  style: TextStyle(color: AppTheme.textPink))),
        ],
      ),
    );
    if (ok == true) await onConfirm();
  }
}
