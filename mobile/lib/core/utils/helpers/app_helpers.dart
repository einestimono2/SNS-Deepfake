import 'package:flutter/material.dart';

class AppHelpers {
  AppHelpers._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  static String truncateText(String text, int maxLength) {
    return text.length < maxLength
        ? text
        : '${text.substring(0, maxLength)} ...';
  }
}
