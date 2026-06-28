import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainBackground),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.textWhite, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Terms of Service',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textWhite)),
                  ],
                ),
              ),
              const Divider(color: Colors.white12, height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Terms of Use',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textWhite)),
                      const SizedBox(height: 8),
                      Text('Effective: ${DateTime.now().year}',
                          style: const TextStyle(
                              color: AppTheme.textDim, fontSize: 12)),
                      const SizedBox(height: 20),
                      const _Section(
                        title: 'Use of Application',
                        body: 'NetCalc Pro is provided free of charge as a professional calculation tool. You may use it for personal, educational, or professional purposes.',
                      ),
                      const _Section(
                        title: 'Accuracy',
                        body: 'While we strive for the highest mathematical accuracy, results should be verified for critical applications. The application and its developers are not liable for errors resulting from incorrect input or interpretation.',
                      ),
                      const _Section(
                        title: 'No Warranty',
                        body: 'This application is provided "as is" without warranty of any kind. By using this application, you agree to do so at your own risk.',
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
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppTheme.neonCyan,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(body,
              style: const TextStyle(
                  color: AppTheme.textDim, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }
}
