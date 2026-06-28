import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/local_storage.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const Text('Settings',
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
                    _SectionHeader(title: 'App'),
                    _SettingsTile(
                      icon: Icons.calculate_rounded,
                      iconColor: AppTheme.neonCyan,
                      title: 'Calculator',
                      subtitle: 'Scientific mode always enabled',
                      trailing: const Icon(Icons.check_circle_rounded,
                          color: AppTheme.neonCyan, size: 20),
                    ),
                    _SettingsTile(
                      icon: Icons.vibration_rounded,
                      iconColor: AppTheme.primaryPurple,
                      title: 'Haptic Feedback',
                      subtitle: 'Light tap vibration on button press',
                      trailing: const Icon(Icons.check_circle_rounded,
                          color: AppTheme.neonCyan, size: 20),
                    ),

                    const SizedBox(height: 20),
                    _SectionHeader(title: 'Data'),
                    _SettingsTile(
                      icon: Icons.history_rounded,
                      iconColor: AppTheme.primaryBlue,
                      title: 'Calculation History',
                      subtitle: 'Stores up to 100 entries locally',
                      trailing: const Icon(Icons.chevron_right_rounded,
                          color: Colors.black26),
                    ),
                    _ActionTile(
                      icon: Icons.delete_sweep_rounded,
                      iconColor: AppTheme.neonPink,
                      title: 'Clear All History',
                      subtitle: 'Remove all saved calculations',
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            title: const Text('Clear History',
                                style: TextStyle(color: AppTheme.textDark)),
                            content: const Text(
                                'This will permanently delete all history.',
                                style: TextStyle(color: AppTheme.textGrey)),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel',
                                      style: TextStyle(color: AppTheme.textGrey))),
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete',
                                      style: TextStyle(color: AppTheme.neonPink))),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await LocalStorage.clearHistory();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('History cleared'),
                                backgroundColor: AppTheme.textDark,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    _ActionTile(
                      icon: Icons.star_border_rounded,
                      iconColor: AppTheme.neonCyan,
                      title: 'Clear All Favorites',
                      subtitle: 'Remove all saved favorite calculations',
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            title: const Text('Clear Favorites',
                                style: TextStyle(color: AppTheme.textDark)),
                            content: const Text(
                                'This will permanently delete all favorites.',
                                style: TextStyle(color: AppTheme.textGrey)),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel',
                                      style: TextStyle(color: AppTheme.textGrey))),
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete',
                                      style: TextStyle(color: AppTheme.neonPink))),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await LocalStorage.clearFavorites();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Favorites cleared'),
                                backgroundColor: AppTheme.textDark,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    _ActionTile(
                      icon: Icons.refresh_rounded,
                      iconColor: AppTheme.primaryPurple,
                      title: 'Reset Onboarding',
                      subtitle: 'Show onboarding screens on next start',
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('onboarding_completed', false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Onboarding reset! Restart the app.'),
                              backgroundColor: AppTheme.primaryPurple,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                    _SectionHeader(title: 'About'),
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: Colors.black45,
                      title: 'Version',
                      subtitle: 'NetCalc Pro 1.0.0',
                      trailing: const SizedBox.shrink(),
                    ),
                    _SettingsTile(
                      icon: Icons.code_rounded,
                      iconColor: Colors.black45,
                      title: 'Built with Flutter',
                      subtitle: 'Offline • No Ads • No Tracking',
                      trailing: const SizedBox.shrink(),
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
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.neonCyan,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
        trailing: trailing,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                color: AppTheme.neonPink,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black12),
        onTap: onTap,
      ),
    );
  }
}
