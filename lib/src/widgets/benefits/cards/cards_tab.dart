import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/benefit.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/list/list_benefits_grid.dart';

class CardsTab extends StatelessWidget {
  const CardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final listCards = listBenefits.where((item) {
      return item.type == BenefitType.card;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ListBenefitsGrid(
            listBenefits: listCards,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
