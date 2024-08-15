import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/my_claim/list/claimed_benefit_item.dart';

class ListClaimedBenefits extends StatelessWidget {
  const ListClaimedBenefits({
    super.key,
    required this.listClaimedBenefits,
    required this.isDismissible,
    this.handleArchiveBenefit,
  });

  final List<Benefit> listClaimedBenefits;
  final bool isDismissible;
  final void Function(Benefit benefit, int index)? handleArchiveBenefit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listClaimedBenefits.length,
      itemBuilder: (context, index) {
        final Benefit benefit = listClaimedBenefits[index];
        if (isDismissible && handleArchiveBenefit != null) {
          return Dismissible(
            key: Key(benefit.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: theme.colorScheme.error.withOpacity(0.9),
              margin: theme.cardTheme.margin,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Archive benefit?",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: theme.colorScheme.onError,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            behavior: HitTestBehavior.opaque,
            onDismissed: (direction) {
              handleArchiveBenefit!(benefit, index);
            },
            child: ClaimedBenefitItem(benefit: benefit),
          );
        }

        return ClaimedBenefitItem(benefit: benefit);
      },
    );
  }
}
