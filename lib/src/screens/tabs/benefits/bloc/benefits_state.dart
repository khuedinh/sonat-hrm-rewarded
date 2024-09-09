part of "benefits_bloc.dart";

enum SortPrice {
  ascending,
  descending,
}

enum SortName { aToZ, zToA }

const RangeValues defaultPriceRange = RangeValues(0, 30000);

class BenefitsState extends Equatable {
  const BenefitsState({
    required this.listCategories,
    required this.listBenefits,
    required this.listClaimedBenefits,
    required this.listArchivedBenefits,
    this.isLoadingCategories = true,
    this.isLoadingBenefits = true,
    this.isLoadingMyClaim = true,
    this.selectedCategory = "",
    this.hasReachedMaxBenefits = false,
    this.page = 1,
    this.pageSize = 10,
    this.textSearch = "",
    this.sortPrice,
    this.sortName,
    this.priceRange = defaultPriceRange,
  });

  final List<CategoryData> listCategories;
  final List<BenefitData> listBenefits;
  final List<ClaimedBenefit> listClaimedBenefits;
  final List<ClaimedBenefit> listArchivedBenefits;
  final bool isLoadingCategories;
  final bool isLoadingBenefits;
  final bool isLoadingMyClaim;
  final bool hasReachedMaxBenefits;
  final String selectedCategory;
  final String textSearch;
  final int page;
  final int pageSize;
  final SortPrice? sortPrice;
  final SortName? sortName;
  final RangeValues? priceRange;

  BenefitsState copyWith({
    int? currentBalance,
    List<CategoryData>? listCategories,
    List<BenefitData>? listBenefits,
    List<ClaimedBenefit>? listClaimedBenefits,
    List<ClaimedBenefit>? listArchivedBenefits,
    bool? isLoadingCurrentBalance,
    bool? isLoadingCategories,
    bool? isLoadingBenefits,
    bool? isLoadingMyClaim,
    bool? hasReachedMaxBenefits,
    String? selectedCategory,
    String? textSearch,
    int? page,
    int? pageSize,
    SortPrice? sortPrice,
    SortName? sortName,
    RangeValues? priceRange,
  }) {
    return BenefitsState(
      listCategories: listCategories ?? this.listCategories,
      listBenefits: listBenefits ?? this.listBenefits,
      listClaimedBenefits: listClaimedBenefits ?? this.listClaimedBenefits,
      listArchivedBenefits: listArchivedBenefits ?? this.listArchivedBenefits,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingBenefits: isLoadingBenefits ?? this.isLoadingBenefits,
      isLoadingMyClaim: isLoadingMyClaim ?? this.isLoadingMyClaim,
      hasReachedMaxBenefits:
          hasReachedMaxBenefits ?? this.hasReachedMaxBenefits,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      textSearch: textSearch ?? this.textSearch,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      sortPrice: sortPrice,
      sortName: sortName,
      priceRange: priceRange,
    );
  }

  @override
  List<Object?> get props => [
        listCategories,
        listBenefits,
        listClaimedBenefits,
        listArchivedBenefits,
        isLoadingCategories,
        isLoadingBenefits,
        isLoadingMyClaim,
        hasReachedMaxBenefits,
        selectedCategory,
        textSearch,
        priceRange,
        sortPrice,
        sortName,
      ];
}
