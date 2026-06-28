import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainBackground),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top Bar ──────────────────────────────────────────────────
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
                      'About NetCalc Pro',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black12, height: 1),

              // ── Body ─────────────────────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Logo + App name
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: AppTheme.accentGradient,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Image.asset(
                              'assets/images/splash_logo.png',
                              width: 48,
                              height: 48,
                              errorBuilder: (c, e, s) => const Icon(
                                  Icons.calculate_rounded,
                                  color: Colors.white,
                                  size: 48),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'NetCalc Pro',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textDark,
                                letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Premium Edition  •  Version 1.0.0',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textGrey,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // App info card
                    _card([
                      _infoTile('Developer', 'NetCalc Team', Icons.person_outline_rounded),
                      const Divider(height: 1),
                      _infoTile('Platform', 'Android & iOS', Icons.phone_android_rounded),
                      const Divider(height: 1),
                      _infoTile('Framework', 'Flutter 3.x', Icons.code_rounded),
                      const Divider(height: 1),
                      _infoTile('License', 'Premium', Icons.verified_outlined),
                    ]),

                    const SizedBox(height: 16),

                    // Sections
                    _card([
                      _InfoSection(
                        title: 'Our Mission',
                        content:
                            'NetCalc Pro is designed to provide a high-precision, offline-first calculation experience. We believe that professional tools should be private, fast, and free from the distractions of advertisements and online tracking.',
                      ),
                      const Divider(height: 1),
                      _InfoSection(
                        title: 'Premium Features',
                        content:
                            'This edition offers a full suite of scientific functions, a comprehensive unit converter, and a secure local history and favorites system. Every element is crafted for professionals who value both utility and design.',
                      ),
                      const Divider(height: 1),
                      _InfoSection(
                        title: 'Academic Origins',
                        content:
                            'Developed as a capstone project by students of the Diploma in ICT programme (Third Year, Group 2) under the course IT 6322 — Mobile Networks and Computing, guided by Mr. Alexander Richard.',
                      ),
                      const Divider(height: 1),
                      _InfoSection(
                        title: 'The Team',
                        content:
                            'Built with passion by Michael Francoo, Rehema Thomas Mtavangu, Jacob Godwin Mwansambe, Joseph Peter Kambaulaya, and Chance Elias.',
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Links card — Privacy, Terms, Rate, Feedback
                    _card([
                      _linkTile(
                        'Privacy Policy',
                        Icons.privacy_tip_outlined,
                        () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const PrivacyScreen())),
                      ),
                      const Divider(height: 1),
                      _linkTile(
                        'Terms of Service',
                        Icons.description_outlined,
                        () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const TermsScreen())),
                      ),
                      const Divider(height: 1),
                      _linkTile(
                        'Rate on Play Store',
                        Icons.star_outline_rounded,
                        () {/* Future: launch URL */},
                      ),
                      const Divider(height: 1),
                      _linkTile(
                        'Send Feedback',
                        Icons.mail_outline_rounded,
                        () {/* Future: launch mailto */},
                      ),
                    ]),

                    const SizedBox(height: 32),

                    // Footer
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Designed for Privacy & Precision',
                            style: TextStyle(
                              color: AppTheme.textGrey.withOpacity(0.6),
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '© 2025 NetCalc Pro. All rights reserved.',
                            style: TextStyle(
                              color: AppTheme.textGrey.withOpacity(0.4),
                              fontSize: 10,
                            ),
                          ),
                        ],
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

  Widget _infoTile(String label, String value, IconData icon) => ListTile(
        leading: Icon(icon, color: AppTheme.primaryBlue, size: 20),
        title: Text(label,
            style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)),
        trailing: Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppTheme.textDark)),
      );

  Widget _linkTile(String label, IconData icon, VoidCallback onTap) => ListTile(
        leading: Icon(icon, color: AppTheme.primaryBlue, size: 20),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 14, color: AppTheme.textGrey),
        onTap: onTap,
      );
}

// ── Info Section widget ──────────────────────────────────────────────────────
class _InfoSection extends StatelessWidget {
  final String title;
  final String content;
  const _InfoSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textGrey,
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
