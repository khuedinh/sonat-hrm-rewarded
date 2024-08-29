import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/screens/benefit_details/benefit_details_screen.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/my_claim/code_dialog.dart';
import 'package:transparent_image/transparent_image.dart';

class ClaimedBenefitItem extends StatelessWidget {
  const ClaimedBenefitItem({
    super.key,
    required this.claimedBenefit,
    this.isArchived = false,
    this.handleRestoreBenefit,
  });

  final ClaimedBenefit claimedBenefit;
  final bool isArchived;
  final void Function(ClaimedBenefit claimedBenefit)? handleRestoreBenefit;

  void _handleShowCode(
      BuildContext context, ClaimedBenefit claimedBenefit) async {
    showDialog(
      context: context,
      builder: (context) {
        return CodeDialog(
          qrCode: claimedBenefit.qrCode,
          code: claimedBenefit.code,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          context.push(BenefitDetailsScreen.routeName, extra: {
            'benefit': claimedBenefit.benefit,
            'claimedBenefit': claimedBenefit,
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: claimedBenefit.benefit.thumbnails
                        .firstWhere((thumbnail) => thumbnail.isPrimary)
                        .imageUrl,
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        claimedBenefit.benefit.name,
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      Text(
                        claimedBenefit.benefit.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Claimed at: ${claimedBenefit.formattedCreatedAt}"),
                SizedBox(
                  height: 28,
                  child: OutlinedButton(
                    onPressed: () {
                      if (isArchived) {
                        handleRestoreBenefit!(claimedBenefit);
                        return;
                      }
                      _handleShowCode(context, claimedBenefit);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      side: BorderSide(
                        width: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    child: Text(isArchived ? "Restore" : 'Show code'),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
