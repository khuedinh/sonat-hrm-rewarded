import 'package:flutter/material.dart';
// import 'package:sonat_hrm_rewarded/src/common/widgets/label/label.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.title,
    required this.value,
    // required this.rateChange,
  });

  final String title;
  final int value;
  // final double rateChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // LabelType labelType = LabelType.primary;
    // if (rateChange > 0) {
    //   labelType = LabelType.success;
    // }
    // if (rateChange < 0) {
    //   labelType = LabelType.error;
    // }

    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
            Text(
              formatNumber(value),
              style: theme.textTheme.bodyLarge,
            ),
            // const SizedBox(height: 4),
            // Label(
            //   title:
            //       '${rateChange == 0 ? "" : rateChange > 0 ? "+" : "-"}${rateChange.abs().toStringAsFixed(2)}%',
            //   type: labelType,
            // ),
          ],
        ),
      ),
    );
  }
}
