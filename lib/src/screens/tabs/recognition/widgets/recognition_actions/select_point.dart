import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/display_amount/display_amount.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

const List<double> points = [100, 200, 300, 500];

class SelectPoint extends StatelessWidget {
  const SelectPoint({
    super.key,
    required this.isLoading,
    required this.balance,
    required this.value,
    required this.onChangePoint,
  });

  final bool isLoading;
  final int balance;
  final double value;
  final void Function(double point) onChangePoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScreenTitle(
          title: AppLocalizations.of(context)!.recognition_points,
          fontSize: 16,
          color: theme.colorScheme.onSurface,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.points_balance),
            const SizedBox(width: 8),
            isLoading
                ? const Skeletonizer(child: Bone.text(words: 1))
                : DisplayAmount(
                    amount: formatNumber(balance),
                    icon: Icons.currency_bitcoin_rounded,
                    iconSize: 14,
                    fontSize: 14,
                    suffix: AppLocalizations.of(context)!.points,
                  ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${value.toInt().toString()} ${AppLocalizations.of(context)!.points}",
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 12,
                ),
              ),
              child: Slider(
                mouseCursor: WidgetStateMouseCursor.textable,
                value: value,
                min: 5,
                max: 500,
                onChanged: onChangePoint,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: points.map((point) {
                return FilterChip(
                  label: Row(
                    children: [
                      const Icon(Icons.currency_bitcoin, size: 16),
                      Text("${point.toInt()}"),
                    ],
                  ),
                  selected: value.toInt() == point.toInt(),
                  onSelected: (bool selected) {
                    if (!selected) return;
                    onChangePoint(point);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
