import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
                      'Privacy Policy',
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
                        'Privacy Commitment',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: ${DateTime.now().year}',
                        style: const TextStyle(
                            color: AppTheme.textGrey, fontSize: 12),
                      ),
                      const SizedBox(height: 20),
                      const _Section(
                        title: 'Data Collection',
                        body:
                            'NetCalc Pro does not collect, store, or transmit any personal data. All calculations and history are stored exclusively on your device using local storage.',
                      ),
                      const _Section(
                        title: 'No Internet Required',
                        body:
                            'This application works entirely offline. No network connections are made at any time, ensuring your data never leaves your device.',
                      ),
                      const _Section(
                        title: 'No Advertising',
                        body:
                            'NetCalc Pro contains no advertisements and no advertising SDKs, providing a clean and private environment.',
                      ),
                      const _Section(
                        title: 'No Analytics',
                        body:
                            'We do not use any analytics or tracking tools. Your usage of the calculator is entirely private to you.',
                      ),
                      const _Section(
                        title: 'Local Storage',
                        body:
                            'Calculation history is saved locally on your device using SharedPreferences. You can delete this data at any time from the Settings screen.',
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
