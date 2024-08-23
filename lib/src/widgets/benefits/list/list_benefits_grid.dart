import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/list/benefit_item.dart';

class ListBenefitsGrid extends StatelessWidget {
  const ListBenefitsGrid({super.key, required this.listBenefits});

  final List listBenefits;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildListDelegate([
        for (final benefit in listBenefits)
          BenefitItem(
            benefit: benefit,
            onTapBenefit: () {},
          ),
      ]),
    );
  }
}
