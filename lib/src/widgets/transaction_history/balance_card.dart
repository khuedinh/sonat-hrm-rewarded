import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/label/label.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.title,
    required this.value,
    required this.rateChange,
  });

  final String title;
  final int value;
  final double rateChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    LabelType labelType = LabelType.primary;
    if (rateChange > 0) {
      labelType = LabelType.success;
    }
    if (rateChange < 0) {
      labelType = LabelType.error;
    }

    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall,
            ),
            Text(
              '$value',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Label(
              title:
                  '${rateChange == 0 ? "" : rateChange > 0 ? "+" : "-"}${rateChange.abs().toStringAsFixed(2)}%',
              type: labelType,
            ),
          ],
        ),
      ),
    );
  }
}
