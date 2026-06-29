import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/local_storage.dart';
import '../theme/app_theme.dart';
import '../theme/settings_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final manager = SettingsManager();

    return ListenableBuilder(
      listenable: manager,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : AppTheme.textDark;
        final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            decoration: BoxDecoration(gradient: isDark ? null : AppTheme.mainBackground),
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
                        Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: textColor),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: isDark ? Colors.white10 : Colors.black12, height: 1),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // ── Calculator ──────────────────────────────────────────
                        _header('Calculator', manager.accentColor),
                        _card(cardColor, [
                          _dropdownTile('Angle Mode', manager.angleMode,
                              ['DEG', 'RAD', 'GRAD'], manager.accentColor, textColor,
                              (v) => manager.setAngleMode(v!)),
                          Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                          _sliderTile('Decimal Precision', manager.precision, 2, 15, manager.accentColor, textColor,
                              (v) => manager.setPrecision(v.round())),
                          Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                          _dropdownTile(
                              'Number Format',
                              manager.numberFormat,
                              ['US (1,000.00)', 'EU (1.000,00)', 'IN (1,00,000)'], manager.accentColor, textColor,
                              (v) => manager.setNumberFormat(v!)),
                        ]),

                        const SizedBox(height: 16),

                        // ── Feedback ───────────────────────────────────────────
                        _header('Feedback', manager.accentColor),
                        _card(cardColor, [
                          _switchTile('Haptic Feedback', Icons.vibration_rounded,
                              manager.haptic, manager.accentColor, textColor, (v) => manager.setHaptic(v)),
                          Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                          _switchTile('Sound Effects', Icons.volume_up_rounded,
                              manager.sound, manager.accentColor, textColor, (v) => manager.setSound(v)),
                        ]),

                        const SizedBox(height: 16),

                        // ── Data ───────────────────────────────────────────────
                        _header('Data', manager.accentColor),
                        _card(cardColor, [
                          _actionTile(
                            'Clear All History',
                            Icons.delete_sweep_rounded,
                            AppTheme.textPink,
                            () => _confirm(
                              'Clear History',
                              'This will permanently delete all calculation history.',
                              () async {
                                final messenger = ScaffoldMessenger.of(context);
                                await LocalStorage.clearHistory();
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('History cleared'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ),
                          Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                          _actionTile(
                            'Clear All Favorites',
                            Icons.star_border_rounded,
                            AppTheme.textPink,
                            () => _confirm(
                              'Clear Favorites',
                              'This will permanently delete all saved favorites.',
                              () async {
                                final messenger = ScaffoldMessenger.of(context);
                                await LocalStorage.clearFavorites();
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Favorites cleared'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ),
                          Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                          _actionTile(
                            'Reset Onboarding',
                            Icons.refresh_rounded,
                            AppTheme.primaryPurple,
                            () async {
                              final messenger = ScaffoldMessenger.of(context);
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('onboarding_completed', false);
                              if (!mounted) return;
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Onboarding reset. Restart the app.'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ]),

                        const SizedBox(height: 16),

                        // ── About ──────────────────────────────────────────────
                        _header('About', manager.accentColor),
                        _card(cardColor, [
                          _infoTile(Icons.info_outline_rounded, Colors.black45,
                              'Version', 'NetCalc Pro 1.0.0', textColor),
                          Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                          _infoTile(Icons.code_rounded, Colors.black45,
                              'Built with Flutter', 'Offline • No Ads • No Tracking', textColor),
                        ]),
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

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _header(String t, Color color) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          t,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 1.4),
        ),
      );

  Widget _card(Color cardColor, List<Widget> children) => Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: cardColor,
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
          String label, IconData icon, bool val, Color color, Color textColor, void Function(bool) onChange) =>
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
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: textColor)),
        trailing: Switch.adaptive(
            value: val,
            onChanged: onChange,
            activeThumbColor: color),
      );

  Widget _dropdownTile(String label, String val, List<String> options, Color color, Color textColor,
          void Function(String?) onChange) =>
      ListTile(
        title: Text(label,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: textColor)),
        trailing: DropdownButton<String>(
          value: val,
          underline: const SizedBox(),
          dropdownColor: Theme.of(context).cardColor,
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto'),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: onChange,
        ),
      );

  Widget _sliderTile(String label, int val, int min, int max, Color color, Color textColor,
          void Function(double) onChange) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15, color: textColor)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('$val digits',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: color)),
              ),
            ]),
            const SizedBox(height: 4),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: color,
                inactiveTrackColor: color.withOpacity(0.2),
                thumbColor: color,
                overlayColor: color.withOpacity(0.1),
                trackHeight: 4,
              ),
              child: Slider(
                value: val.toDouble(),
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: max - min,
                onChanged: onChange,
              ),
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
          IconData icon, Color iconColor, String label, String value, Color textColor) =>
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
            style: TextStyle(
                fontWeight: FontWeight.w700, color: textColor)),
      );

  Future<void> _confirm(
      String title, String message, Future<void> Function() onConfirm) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.textDark;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(title,
            style: TextStyle(color: textColor)),
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
