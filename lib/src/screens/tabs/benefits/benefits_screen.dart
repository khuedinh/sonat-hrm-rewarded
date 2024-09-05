import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/common/blocs/user/user_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/display_amount/display_amount.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/bloc/benefits_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/widgets/filters/benefit_filters.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/widgets/gifts/gifts_tab.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/widgets/my_claim/my_claim_tab.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  static const screenTitle = 'Benefits';

  @override
  State<BenefitsScreen> createState() => _BenefitScreenState();
}

class _BenefitScreenState extends State<BenefitsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  void _handleOpenFilter(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<BenefitsBloc>(context),
        child: BenefitFilters(
          defaultPriceRange: context.read<BenefitsBloc>().state.priceRange ??
              const RangeValues(0, 30000),
          defaultSortPrice: context.read<BenefitsBloc>().state.sortPrice,
          defaultSortName: context.read<BenefitsBloc>().state.sortName,
        ),
      ),
    );
  }

  void _tabListener() {
    if (_currentTab != _tabController.animation!.value.round()) {
      setState(() {
        _currentTab = _tabController.animation!.value.round();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation!.addListener(_tabListener);
    context.read<UserBloc>().add(GetCurrentBalance());
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
          title: Row(
            children: [
              const ScreenTitle(title: "Current balance"),
              const SizedBox(width: 16),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  final isLoadingCurrentBalance = state.isLoadingCurrentBalance;
                  final currentCoin = state.currentBalance?.currentCoin ?? 0;

                  if (isLoadingCurrentBalance) {
                    return const Skeletonizer(
                      child: Bone.text(words: 1, fontSize: 16),
                    );
                  }

                  return DisplayAmount(
                    amount: formatNumber(currentCoin),
                    icon: Icons.currency_bitcoin_rounded,
                    suffix: "Coins",
                    isBold: true,
                    textColor: theme.colorScheme.onPrimary,
                  );
                },
              ),
            ],
          ),
          actions: [
            if (_currentTab == 0)
              BlocBuilder<BenefitsBloc, BenefitsState>(
                builder: (context, state) {
                  int filterCount = 0;
                  if (state.priceRange != null &&
                      (state.priceRange?.start != defaultPriceRange.start ||
                          state.priceRange?.end != defaultPriceRange.end)) {
                    filterCount++;
                  }
                  if (state.sortName != null) filterCount++;
                  if (state.sortPrice != null) filterCount++;

                  return IconButton(
                    icon: filterCount > 0
                        ? Badge.count(
                            count: filterCount,
                            child: const Icon(Icons.filter_alt_rounded))
                        : const Icon(Icons.filter_alt_outlined),
                    onPressed: () => _handleOpenFilter(context),
                  );
                },
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
                onTap: (int index) {
                  setState(() {
                    _currentTab = index;
                  });
                },
                controller: _tabController,
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
        body: TabBarView(
          controller: _tabController,
          children: const [
            GiftsTab(),
            MyClaimTab(),
          ],
        ),
      ),
    );
  }
}
