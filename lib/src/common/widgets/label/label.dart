import 'package:flutter/material.dart';

enum LabelType {
  primary,
  error,
  success,
  warning,
  info,
}

class Label extends StatelessWidget {
  const Label({
    super.key,
    required this.title,
    this.type = LabelType.primary,
  });

  final String title;
  final LabelType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor = theme.colorScheme.primary;

    if (type == LabelType.error) {
      backgroundColor = Colors.red;
    } else if (type == LabelType.success) {
      backgroundColor = Colors.green;
    } else if (type == LabelType.warning) {
      backgroundColor = const Color.fromARGB(255, 255, 154, 59);
    } else if (type == LabelType.info) {
      backgroundColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: theme.textTheme.bodySmall!.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
