import 'package:flutter/material.dart';

class DisplayAmount extends StatelessWidget {
  const DisplayAmount({
    super.key,
    required this.amount,
    required this.icon,
    this.suffix,
    this.iconSize,
    this.iconColor,
    this.textColor,
    this.spacing,
  });

  final IconData icon;
  final int amount;
  final double? iconSize;
  final String? suffix;
  final Color? iconColor;
  final Color? textColor;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String amountText = suffix != null ? '$amount $suffix' : '$amount';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: iconColor ?? const Color.fromARGB(255, 255, 154, 59),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.onSurface),
          ),
          child: Icon(
            icon,
            size: iconSize ?? 16,
          ),
        ),
        SizedBox(width: spacing ?? 8),
        Text(
          amountText,
          style: theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor ?? theme.colorScheme.onSurface,
          ),
        )
      ],
    );
  }
}
