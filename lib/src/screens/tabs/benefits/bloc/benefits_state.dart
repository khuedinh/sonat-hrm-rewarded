part of "benefits_bloc.dart";

enum SortPrice { descending, ascending }

enum SortName { aToZ, zToA }

const RangeValues defaultPriceRange = RangeValues(0, 30000);

class BenefitsState extends Equatable {
  const BenefitsState({
    this.currentBalance,
    required this.listCategories,
    required this.listBenefits,
    required this.listClaimedBenefits,
    required this.listArchivedBenefits,
    this.isLoadingCurrentBalance = true,
    this.isLoadingCategories = true,
    this.isLoadingBenefits = true,
    this.isLoadingMyClaim = true,
    this.selectedCategory = "",
    this.page = 1,
    this.pageSize = 12,
    this.textSearch = "",
    this.sortPrice,
    this.sortName,
    this.priceRange = defaultPriceRange,
  });

  final int? currentBalance;
  final List<CategoryData> listCategories;
  final List<BenefitData> listBenefits;
  final List<ClaimedBenefit> listClaimedBenefits;
  final List<ClaimedBenefit> listArchivedBenefits;
  final bool isLoadingCurrentBalance;
  final bool isLoadingCategories;
  final bool isLoadingBenefits;
  final bool isLoadingMyClaim;
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
    String? selectedCategory,
    String? textSearch,
    int? page,
    int? pageSize,
    SortPrice? sortPrice,
    SortName? sortName,
    RangeValues? priceRange,
  }) {
    return BenefitsState(
      currentBalance: currentBalance ?? this.currentBalance,
      listCategories: listCategories ?? this.listCategories,
      listBenefits: listBenefits ?? this.listBenefits,
      listClaimedBenefits: listClaimedBenefits ?? this.listClaimedBenefits,
      listArchivedBenefits: listArchivedBenefits ?? this.listArchivedBenefits,
      isLoadingCurrentBalance:
          isLoadingCurrentBalance ?? this.isLoadingCurrentBalance,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingBenefits: isLoadingBenefits ?? this.isLoadingBenefits,
      isLoadingMyClaim: isLoadingMyClaim ?? this.isLoadingMyClaim,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      textSearch: textSearch ?? this.textSearch,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      sortPrice: sortPrice ?? this.sortPrice,
      sortName: sortName ?? this.sortName,
      priceRange: priceRange ?? this.priceRange,
    );
  }

  @override
  List<Object?> get props => [
        currentBalance,
        listCategories,
        listBenefits,
        listClaimedBenefits,
        listArchivedBenefits,
        isLoadingCurrentBalance,
        isLoadingCategories,
        isLoadingBenefits,
        isLoadingMyClaim,
        selectedCategory,
        textSearch,
        priceRange,
        sortPrice,
        sortName,
      ];
}
