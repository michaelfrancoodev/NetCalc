import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainBackground),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top Bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.textWhite, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'About NetCalc Pro',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textWhite),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10, height: 1),

              // ── Body ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo + App name centered at top
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/splash_logo.png',
                              width: 80, height: 80,
                              errorBuilder: (c, o, s) => const Icon(
                                  Icons.calculate_rounded,
                                  color: AppTheme.neonCyan, size: 80),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'NetCalc Pro',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textWhite,
                                  letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Premium Edition • Version 1.0.0',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSubdued,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // ── Description ──
                      const _InfoSection(
                        title: 'Our Mission',
                        content: 'NetCalc Pro is designed to provide a high-precision, offline-first calculation experience. We believe that professional tools should be private, fast, and free from the distractions of advertisements and online tracking.',
                      ),

                      const _InfoSection(
                        title: 'Premium Features',
                        content: 'This edition offers a full suite of scientific functions, a comprehensive unit converter, and a secure local history and favorites system. Every element is crafted for professionals who value both utility and design.',
                      ),

                      const _InfoSection(
                        title: 'Academic Origins',
                        content: 'Developed as a capstone project by students of the Diploma in ICT programme (Third Year, Group 2) under the course IT 6322 — Mobile Networks and Computing, guided by Mr. Alexander Richard.',
                      ),

                      const _InfoSection(
                        title: 'The Team',
                        content: 'Built with passion by Michael Francoo, Rehema Thomas Mtavangu, Jacob Godwin Mwansambe, Joseph Peter Kambaulaya, and Chance Elias.',
                      ),

                      const SizedBox(height: 48),

                      // ── Footer ──
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Designed for Privacy & Precision',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '© 2025 NetCalc Pro. All rights reserved.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.15),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String content;
  const _InfoSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.neonCyan,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textDim,
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
