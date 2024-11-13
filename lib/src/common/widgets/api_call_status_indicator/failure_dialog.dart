import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';

class FailureDialog extends StatelessWidget {
  const FailureDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ScreenTitle(
              title: "Failure",
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 20),
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 20),
            Center(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
