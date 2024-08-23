import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/user.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/filters/benefit_filters.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/gifts/gifts_tab.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/my_claim/my_claim_tab.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';

class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  static const screenTitle = 'Benefits';

  @override
  State<BenefitsScreen> createState() => _BenefitScreenState();
}

class _BenefitScreenState extends State<BenefitsScreen> {
  void _handleOpenFilter() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) => const BenefitFilters(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            title: Row(children: [
              const ScreenTitle(title: "Current balance"),
              const SizedBox(width: 16),
              DisplayAmount(
                amount: currentUser.coin,
                icon: Icons.currency_bitcoin_rounded,
                suffix: "Coins",
                isBold: true,
                textColor: theme.colorScheme.onPrimary,
              )
            ]),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_alt),
                onPressed: _handleOpenFilter,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight - 8),
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                margin: EdgeInsets.zero,
                child: TabBar(
                  indicatorColor: theme.colorScheme.primary,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                  tabs: const [
                    Tab(text: "Gifts"),
                    Tab(text: "My claim"),
                  ],
                ),
              ),
            ),
          ),
          body: const TabBarView(children: [
            GiftsTab(),
            MyClaimTab(),
          ])),
    );
  }
}
