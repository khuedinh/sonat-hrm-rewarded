import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle(
      {super.key, required this.title, this.color, this.fontSize});

  final String title;
  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium!.copyWith(
        color: color ?? theme.colorScheme.onPrimary,
        fontSize: fontSize ?? 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
