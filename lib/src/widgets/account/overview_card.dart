import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    this.isLoading = false,
  });

  final Color color;
  final IconData icon;
  final String title;
  final int value;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            Column(
              children: [
                Text(title, style: theme.textTheme.bodySmall),
                isLoading!
                    ? const Skeletonizer(
                        child: Bone.text(
                        words: 1,
                      ))
                    : Text(
                        "$value",
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: color,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
