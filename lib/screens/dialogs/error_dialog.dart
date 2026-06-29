import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

Future<void> showErrorDialog(BuildContext context, String message) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final textColor = isDark ? Colors.white : AppTheme.textDark;

  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppTheme.textPink, size: 22),
          const SizedBox(width: 8),
          Text('Error',
              style: TextStyle(color: textColor, fontSize: 18)),
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
