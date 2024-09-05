import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ScreenTitle(title: "Success"),
            const SizedBox(height: 20),
            const Icon(Icons.check, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            Center(
              child: Text(
                message,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
