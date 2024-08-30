import 'dart:convert';

import 'package:flutter/material.dart';

class CodeDialog extends StatelessWidget {
  const CodeDialog({super.key, required this.qrCode, required this.code});

  final String qrCode;
  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.bold,
      ),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Your code"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Show QR code or input code to admin"),
          const SizedBox(height: 8),
          SizedBox(
            width: 160,
            height: 160,
            child: Image.memory(
              base64Decode(qrCode.split('base64,').last),
              width: 160,
              height: 160,
            ),
          ),
          const SizedBox(height: 8),
          Text(code, style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          SizedBox(
            height: 28,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                side: BorderSide(
                  width: 2,
                  color: theme.colorScheme.primary,
                ),
              ),
              label: const Text('Copy code'),
              icon: const Icon(Icons.copy, size: 16),
            ),
          )
        ],
      ),
    );
  }
}
