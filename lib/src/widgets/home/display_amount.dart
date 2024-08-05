import 'package:flutter/material.dart';

class DisplayAmount extends StatelessWidget {
  const DisplayAmount(
      {super.key,
      required this.amount,
      required this.icon,
      this.suffix,
      this.iconSize});

  final IconData icon;
  final int amount;
  final double? iconSize;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.onSurface),
          ),
          child: Icon(
            icon,
            size: iconSize ?? 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$amount $suffix',
          style: theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        )
      ],
    );
  }
}
