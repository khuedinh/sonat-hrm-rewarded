import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

class DisplayAmount extends StatelessWidget {
  const DisplayAmount({
    super.key,
    required this.amount,
    required this.icon,
    this.suffix,
    this.fontSize = 14,
    this.iconSize = 16,
    this.iconColor,
    this.textColor,
    this.isBold = false,
    this.spacing = 8,
    this.isLoading = false,
  });

  final IconData icon;
  final String amount;
  final double fontSize;
  final bool isBold;
  final double? iconSize;
  final String? suffix;
  final Color? iconColor;
  final Color? textColor;
  final double? spacing;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String amountText =
        suffix != null ? '$amount $suffix' : '$formatShortenNumber(amount)';

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
            size: iconSize,
          ),
        ),
        SizedBox(width: spacing),
        isLoading
            ? const Skeletonizer(child: Bone.text(words: 1))
            : Text(
                amountText,
                style: theme.textTheme.titleSmall!.copyWith(
                  fontSize: fontSize,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: textColor ?? theme.colorScheme.onSurface,
                ),
              )
      ],
    );
  }
}
