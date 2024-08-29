import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/bloc/benefits_bloc.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/list/benefit_item.dart';

class ListBenefitsGrid extends StatelessWidget {
  const ListBenefitsGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BenefitsBloc, BenefitsState>(builder: (context, state) {
      final listBenefits = state.listBenefits;
      final isLoadingBenefits = state.isLoadingBenefits;

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
              for (int i = 0; i < 6; i++)
                const Skeletonizer(
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    child: SizedBox(
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Bone.square(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Bone.text(words: 2, fontSize: 14),
                                    SizedBox(height: 4),
                                    Bone.text(words: 3, fontSize: 12),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }

      if (!isLoadingBenefits && listBenefits.isEmpty) {
        return const SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_off),
                SizedBox(height: 4),
                Text("No data found."),
              ],
            ),
          ),
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
          ],
        ),
      );
    });
  }
}
