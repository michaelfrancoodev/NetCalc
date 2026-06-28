import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  final String expression;
  final String result;

  const ResultScreen({
    super.key,
    required this.expression,
    required this.result,
  });

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
                          color: AppTheme.textDark, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Result',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark)),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppTheme.displayGradient,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(expression,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: AppTheme.textGrey,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(height: 12),
                          Text('= $result',
                              style: const TextStyle(
                                  fontSize: 40,
                                  color: AppTheme.textDark,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
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
