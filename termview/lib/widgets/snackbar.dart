import 'package:flutter/material.dart';

void showTerminalSnackbar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  final backgroundColor = isDark
      ? const Color(0xFF1E1E1E)
      : const Color(0xFFF5F5F5);

  final borderColor = isError
      ? (isDark ? const Color(0xFFA41623) : const Color(0xFFA41623))
      : (isDark ? const Color(0xFF00FF00) : const Color(0xFF007700));

  final textColor = isDark ? const Color(0xFF00FF00) : const Color(0xFF007700);

  final icon = isError
      ? Icon(Icons.error_outline, color: textColor)
      : Icon(Icons.check_circle_outline, color: textColor);

  final snackBar = SnackBar(
    content: Row(
      children: [
        icon,
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontFamily: 'FiraCode',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: borderColor, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
