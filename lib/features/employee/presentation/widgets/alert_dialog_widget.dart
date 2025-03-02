import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  final String message;

  const AlertDialogWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 16),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }

  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) => AlertDialogWidget(message: message),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
