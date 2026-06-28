import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
                      'Terms of Service',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Terms of Use',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Effective: ${DateTime.now().year}',
                        style: const TextStyle(
                            color: AppTheme.textGrey, fontSize: 12),
                      ),
                      const SizedBox(height: 20),
                      const _Section(
                        title: 'Use of Application',
                        body:
                            'NetCalc Pro is provided free of charge as a professional calculation tool. You may use it for personal, educational, or professional purposes.',
                      ),
                      const _Section(
                        title: 'Accuracy',
                        body:
                            'While we strive for the highest mathematical accuracy, results should be verified for critical applications. The application and its developers are not liable for errors resulting from incorrect input or interpretation.',
                      ),
                      const _Section(
                        title: 'No Warranty',
                        body:
                            'This application is provided "as is" without warranty of any kind. By using this application, you agree to do so at your own risk.',
                      ),
                      const _Section(
                        title: 'Intellectual Property',
                        body:
                            'All design, code, and content within this application are the intellectual property of the NetCalc Pro development team. Reproduction or distribution without permission is prohibited.',
                      ),
                      const _Section(
                        title: 'Changes to Terms',
                        body:
                            'We reserve the right to update these terms at any time. Continued use of the application following any changes constitutes acceptance of the new terms.',
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

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
                color: AppTheme.textGrey, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }
}
