import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/screens/benefit_details/benefit_details_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/home/widgets/display_amount.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';
import 'package:transparent_image/transparent_image.dart';

class BenefitItem extends StatelessWidget {
  const BenefitItem({super.key, required this.benefit});

  final BenefitData benefit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.push(BenefitDetailsScreen.routeName, extra: {
            "benefit": benefit,
          });
        },
        child: SizedBox(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: FadeInImage.memoryNetwork(
                      image: benefit.thumbnails.first.imageUrl ?? "",
                      placeholder: kTransparentImage,
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
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: DisplayAmount(
                                amount: formatNumber(benefit.exchangePrice),
                                icon: Icons.currency_bitcoin_rounded,
                                iconSize: 10,
                                fontSize: 12,
                                suffix: "coins",
                                spacing: 4,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.end,
                                "Stock: ${benefit.inStock}",
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
