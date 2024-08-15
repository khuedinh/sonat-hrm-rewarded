import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CodeDialog extends StatelessWidget {
  const CodeDialog({super.key});

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
          SizedBox(
            width: 160,
            height: 160,
            child: QrImageView(
              data: "1234567890",
              version: QrVersions.auto,
              size: 80,
            ),
          ),
          Text('1234567890', style: theme.textTheme.titleMedium),
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
                  color: theme.colorScheme.primaryContainer,
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
