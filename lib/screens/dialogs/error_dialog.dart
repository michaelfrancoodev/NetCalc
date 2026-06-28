import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

Future<void> showErrorDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppTheme.textPink, size: 22),
          const SizedBox(width: 8),
          const Text('Error',
              style: TextStyle(color: AppTheme.textDark, fontSize: 18)),
        ],
      ),
      content: Text(message,
          style: const TextStyle(color: AppTheme.textGrey, fontSize: 14)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('OK',
              style: TextStyle(
                  color: AppTheme.primaryBlue, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
}
