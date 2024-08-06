import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/list/benefit_item.dart';

class ListBenefitsHorizontal extends StatelessWidget {
  const ListBenefitsHorizontal({
    super.key,
    required this.listBenefits,
  });

  final List<Benefit> listBenefits;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 236,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 16),
          scrollDirection: Axis.horizontal,
          itemCount: listBenefits.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 16);
          },
          itemBuilder: (context, index) {
            final Benefit benefit = listBenefits[index];
            return BenefitItem(benefit: benefit, onTapBenefit: () {});
          },
        ),
      ),
    );
  }
}
