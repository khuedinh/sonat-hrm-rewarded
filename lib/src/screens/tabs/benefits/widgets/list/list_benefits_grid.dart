import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/no_data/no_data.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/bloc/benefits_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/widgets/list/benefit_item.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/widgets/list/skeleton_item.dart';

class ListBenefitsGrid extends StatelessWidget {
  const ListBenefitsGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BenefitsBloc, BenefitsState>(builder: (context, state) {
      final listBenefits = state.listBenefits;
      final isLoadingBenefits = state.isLoadingBenefits;
      final hasReachMax = state.hasReachedMaxBenefits;

      if (isLoadingBenefits) {
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          delegate: SliverChildListDelegate(
            [
              for (int i = 0; i < 6; i++) const SkeletonItem(),
            ],
          ),
        );
      }

      if (!isLoadingBenefits && listBenefits.isEmpty) {
        return const SliverFillRemaining(
          child: NoData(message: "No benefits found."),
        );
      }

      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildListDelegate(
          [
            for (final benefit in listBenefits) BenefitItem(benefit: benefit),
            if (!hasReachMax)
              for (int i = 0; i < 2; i++) const SkeletonItem(),
          ],
        ),
      );
    });
  }
}
