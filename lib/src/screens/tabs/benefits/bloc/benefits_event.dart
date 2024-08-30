part of "benefits_bloc.dart";

sealed class BenefitsEvent extends Equatable {}

class InitBenefitsData extends BenefitsEvent {
  @override
  List<Object?> get props => [];
}

class LoadMoreBenefits extends BenefitsEvent {
  @override
  List<Object?> get props => [];
}

class RefreshBenefitsData extends BenefitsEvent {
  @override
  List<Object?> get props => [];
}

class InitCategoriesData extends BenefitsEvent {
  @override
  List<Object?> get props => [];
}

class InitMyClaim extends BenefitsEvent {
  @override
  List<Object?> get props => [];
}

class RefreshMyClaim extends BenefitsEvent {
  @override
  List<Object?> get props => [];
}

class ChangeTextSearch extends BenefitsEvent {
  final String text;

  ChangeTextSearch({required this.text});

  @override
  List<Object?> get props => [text];
}

class SelectCategory extends BenefitsEvent {
  final String categoryId;

  SelectCategory({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class ArchiveClaimedBenefit extends BenefitsEvent {
  final ClaimedBenefit claimedBenefit;
  final int index;

  ArchiveClaimedBenefit({required this.claimedBenefit, required this.index});

  @override
  List<Object?> get props => [claimedBenefit, index];
}

class RestoreClaimedBenefit extends BenefitsEvent {
  final ClaimedBenefit claimedBenefit;
  final int index;

  RestoreClaimedBenefit({required this.claimedBenefit, required this.index});

  @override
  List<Object?> get props => [claimedBenefit, index];
}

class ChangeFilter extends BenefitsEvent {
  final RangeValues? priceRange;
  final SortPrice? sortPrice;
  final SortName? sortName;

  ChangeFilter({
    this.priceRange,
    this.sortPrice,
    this.sortName,
  });

  @override
  List<Object?> get props => [priceRange, sortPrice, sortName];
}
