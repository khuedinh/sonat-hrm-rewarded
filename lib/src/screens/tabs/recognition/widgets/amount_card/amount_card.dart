import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AmountCard extends StatelessWidget {
  const AmountCard({
    super.key,
    required this.isLoading,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  final bool isLoading;
  final String title;
  final int amount;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                isLoading
                    ? const Skeletonizer(
                        child: Bone.text(words: 1),
                      )
                    : Text("$amount")
              ],
            )
          ],
        ),
      ),
    );
  }
}
