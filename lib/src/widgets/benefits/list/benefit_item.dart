import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/screens/benefit_detail/benefit_detail_screen.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';

class BenefitItem extends StatelessWidget {
  const BenefitItem(
      {super.key, required this.benefit, required this.onTapBenefit});

  final Benefit benefit;
  final void Function() onTapBenefit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.push(BenefitDetailScreen.routeName, extra: benefit);
        },
        child: SizedBox(
          width: 160,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      benefit.image,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            benefit.name,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          DisplayAmount(
                            amount: benefit.price,
                            icon: Icons.currency_bitcoin_rounded,
                            iconSize: 12,
                            suffix: "coins",
                            spacing: 4,
                          )
                        ]),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
