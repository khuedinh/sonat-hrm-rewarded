import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/benefit.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/user.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/list/list_benefits_grid.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/list/list_benefits_horizontal.dart';

class GiftsTab extends StatelessWidget {
  const GiftsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final listGifts = listBenefits.where((item) {
      return item.type == BenefitType.gift;
    }).toList();

    final listFeaturedGifts = listGifts.where((item) {
      return item.isFeatured!;
    }).toList();

    final listExchangeableGifts = listGifts.where((item) {
      return item.price < currentUser.coin;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverToBoxAdapter(
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'What are you looking for?',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                prefixIcon: Icon(Icons.search, size: 28),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(
            child: ScreenTitle(
              title: 'Featured',
              color: theme.colorScheme.onSurface,
              fontSize: 18,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          ListBenefitsHorizontal(
            listBenefits: listFeaturedGifts,
          ),
          SliverToBoxAdapter(
            child: ScreenTitle(
              title: 'Exchangeable',
              color: theme.colorScheme.onSurface,
              fontSize: 18,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          ListBenefitsHorizontal(
            listBenefits: listExchangeableGifts,
          ),
          SliverToBoxAdapter(
            child: ScreenTitle(
              title: 'Others',
              color: theme.colorScheme.onSurface,
              fontSize: 18,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          ListBenefitsGrid(
            listBenefits: listGifts,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
