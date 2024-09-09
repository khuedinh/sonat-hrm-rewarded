import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/no_data/no_data.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/bloc/benefits_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/widgets/my_claim/list/claimed_benefit_item.dart';

class ListClaimedBenefits extends StatefulWidget {
  const ListClaimedBenefits({
    super.key,
    required this.isDismissible,
  });

  final bool isDismissible;

  @override
  State<ListClaimedBenefits> createState() => _ListClaimedBenefitsState();
}

class _ListClaimedBenefitsState extends State<ListClaimedBenefits> {
  void _handleArchiveBenefit(
    ClaimedBenefit claimedBenefit,
    int index,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.archive_successfully),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed: () {
            context.read<BenefitsBloc>().add(
                  RestoreClaimedBenefit(
                    claimedBenefit: claimedBenefit,
                    index: index,
                  ),
                );
          },
        ),
      ),
    );

    context.read<BenefitsBloc>().add(
          ArchiveClaimedBenefit(
            claimedBenefit: claimedBenefit,
            index: index,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BenefitsBloc, BenefitsState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final listClaimedBenefits = state.listClaimedBenefits;
        final isLoadingMyClaim = state.isLoadingMyClaim;

        if (isLoadingMyClaim) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return const Skeletonizer(
                    child: Card(
                      child: ListTile(
                        leading: Bone.square(size: 76),
                        title: Bone.text(words: 2),
                        subtitle: Bone.text(
                          words: 5,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 8,
              ),
            ),
          );
        }

        if (listClaimedBenefits.isEmpty) {
          return const SliverFillRemaining(
            child: NoData(message: "No claimed benefits found."),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: listClaimedBenefits.length,
            itemBuilder: (context, index) {
              final ClaimedBenefit claimedBenefit = listClaimedBenefits[index];

              if (widget.isDismissible) {
                return Dismissible(
                  key: Key(claimedBenefit.id),
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
                            AppLocalizations.of(context)!.archive_benefit,
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
                    _handleArchiveBenefit(claimedBenefit, index);
                  },
                  child: ClaimedBenefitItem(claimedBenefit: claimedBenefit),
                );
              }

              return ClaimedBenefitItem(claimedBenefit: claimedBenefit);
            },
          ),
        );
      },
    );
  }
}
