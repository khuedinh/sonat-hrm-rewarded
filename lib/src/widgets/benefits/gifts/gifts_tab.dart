import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/models/category.dart';
import 'package:sonat_hrm_rewarded/src/service/api/benefit_api.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/list/list_benefits_grid.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/list/list_categories.dart';

class GiftsTab extends StatefulWidget {
  const GiftsTab({super.key});

  @override
  State<GiftsTab> createState() => _GiftsTabState();
}

class _GiftsTabState extends State<GiftsTab> {
  List listBenefits = [];
  List listCategories = [];
  bool isLoadingBenefits = true;
  bool isLoadingCategories = true;
  String _selectedCategory = "";

  void handleSelectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void handleGetListBenefit() async {
    final queryParams = {
      "categoryId": _selectedCategory,
    };
    final res = await BenefitApi.getListBenefit(queryParams: queryParams);

    if (mounted) {
      setState(() {
        listBenefits =
            res.map((item) => BenefitResponse.fromJson(item)).toList();
        isLoadingBenefits = false;
      });
    }
  }

  void handleGetListCategories() async {
    final res = await BenefitApi.getListCategories();
    if (mounted) {
      setState(() {
        listCategories =
            res.map((item) => CategoryResponse.fromJson(item)).toList();
        isLoadingCategories = false;
      });
    }
  }

  void handleRedeemBenefit(String benefitId) async {
    final res = await BenefitApi.redeemBenefit(data: {benefitId: benefitId});
    print(res);
  }

  @override
  void initState() {
    super.initState();
    handleGetListBenefit();
    handleGetListCategories();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingCategories || isLoadingBenefits) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ListCategories(
            listCategories: listCategories,
            handleSelectCategory: handleSelectCategory,
            selectedCategory: _selectedCategory,
          ),
          ListBenefitsGrid(
            listBenefits: listBenefits,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
