import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sonat_hrm_rewarded/src/models/balance.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/models/category.dart';
import 'package:sonat_hrm_rewarded/src/service/api/balance_api.dart';
import 'package:sonat_hrm_rewarded/src/service/api/benefit_api.dart';

part 'benefits_event.dart';
part 'benefits_state.dart';

class BenefitsBloc extends Bloc<BenefitsEvent, BenefitsState> {
  BenefitsBloc()
      : super(
          const BenefitsState(
            listCategories: [],
            listBenefits: [],
            listClaimedBenefits: [],
            listArchivedBenefits: [],
            currentBalance: 0,
          ),
        ) {
    on<InitCurrentBalance>((BenefitsEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingCurrentBalance: true));

      final balanceData = await fetchCurrentBalance();

      emit(state.copyWith(
        isLoadingCurrentBalance: false,
        currentBalance: balanceData.currentCoin ?? 0,
      ));
    });

    on<InitBenefitsData>((BenefitsEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingBenefits: true));

      final listBenefits = await fetchBenefits(state);

      emit(state.copyWith(
        isLoadingBenefits: false,
        listBenefits: listBenefits,
      ));
    });

    on<InitCategoriesData>((BenefitsEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingCategories: true));

      final listCategories = await fetchCategories();

      emit(state.copyWith(
        listCategories: listCategories,
        isLoadingCategories: false,
      ));
    });

    on<InitMyClaim>((BenefitsEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingMyClaim: true));
      final claimedBenefits = await fetchMyClaim();

      emit(state.copyWith(
        isLoadingMyClaim: false,
        listClaimedBenefits: claimedBenefits.readyToUse ?? [],
      ));
    });

    on<ChangeTextSearch>(
      (ChangeTextSearch event, Emitter emit) async {
        emit(state.copyWith(textSearch: event.text, isLoadingBenefits: true));

        await Future.delayed(const Duration(milliseconds: 500));
        if (emit.isDone) return;

        final listBenefitsBySearch = await fetchBenefits(state);

        emit(state.copyWith(
          listBenefits: listBenefitsBySearch,
          isLoadingBenefits: false,
        ));
      },
      transformer: restartable(),
    );

    on<SelectCategory>(
      (SelectCategory event, Emitter emit) async {
        emit(state.copyWith(
          selectedCategory: event.categoryId,
          isLoadingBenefits: true,
        ));

        await Future.delayed(const Duration(milliseconds: 300));
        if (emit.isDone) return;

        final listBenefitsByCategory = await fetchBenefits(state);

        emit(state.copyWith(
          listBenefits: listBenefitsByCategory,
          isLoadingBenefits: false,
        ));
      },
      transformer: restartable(),
    );

    on<ChangeFilter>((ChangeFilter event, Emitter emit) async {
      emit(state.copyWith(
        isLoadingBenefits: true,
        sortPrice: event.sortPrice,
        sortName: event.sortName,
        priceRange: event.priceRange,
      ));

      final filteredBenefits = await fetchBenefits(state);

      emit(state.copyWith(
        listBenefits: filteredBenefits,
        isLoadingBenefits: false,
      ));
    });

    on<ArchiveClaimedBenefit>((
      ArchiveClaimedBenefit event,
      Emitter emit,
    ) async {
      final currentListClaimedBenefits = state.listClaimedBenefits;
      currentListClaimedBenefits.remove(event.claimedBenefit);

      emit(state.copyWith(
        listClaimedBenefits: currentListClaimedBenefits,
        listArchivedBenefits: [
          ...state.listArchivedBenefits,
          event.claimedBenefit,
        ],
      ));

      final response = await BenefitApi.toggleArchiveBenefit(
        event.claimedBenefit.id,
        "marked_as_used",
      );

      if (!response["success"]) {
        currentListClaimedBenefits.insert(event.index, event.claimedBenefit);
        emit(state.copyWith(
          listClaimedBenefits: currentListClaimedBenefits,
          listArchivedBenefits: state.listArchivedBenefits
              .where((benefit) => benefit.id != event.claimedBenefit.id)
              .toList(),
        ));
      }
    });

    on<RestoreClaimedBenefit>((
      RestoreClaimedBenefit event,
      Emitter emit,
    ) async {
      final currentListClaimedBenefits = state.listClaimedBenefits;
      currentListClaimedBenefits.insert(event.index, event.claimedBenefit);

      emit(state.copyWith(
        listClaimedBenefits: currentListClaimedBenefits,
        listArchivedBenefits: state.listArchivedBenefits
            .where((benefit) => benefit.id != event.claimedBenefit.id)
            .toList(),
      ));

      await BenefitApi.toggleArchiveBenefit(event.claimedBenefit.id, "restore");
    });
  }

  Future fetchBenefits(BenefitsState state) async {
    try {
      final queryParams = {
        'categoryId': state.selectedCategory,
        'page': state.page,
        'pageSize': state.pageSize,
        'search': state.textSearch,
        "sortPrice": state.sortPrice == SortPrice.ascending ? "ASC" : "DESC",
        "sortName": state.sortName == SortName.aToZ ? "ASC" : "DESC",
        "minPrice": state.priceRange?.start,
        "maxPrice": state.priceRange?.end,
      };

      final response =
          await BenefitApi.getListBenefits(queryParams: queryParams);
      if (response != null) {
        final benefitResponse = BenefitResponse.fromJson(response);

        return benefitResponse.data;
      }
      return [];
    } catch (error) {
      return [];
    }
  }

  Future fetchCategories() async {
    try {
      final response = await BenefitApi.getListCategories();
      if (response != null) {
        final listCategories = (response as List)
            .map((benefit) => CategoryData.fromJson(benefit))
            .toList();

        return listCategories;
      }
      return [];
    } catch (error) {
      return [];
    }
  }

  Future fetchCurrentBalance() async {
    final response = await BalanceApi.getCurrentBalance();
    if (response != null) return Balance.fromJson(response);
  }

  Future fetchMyClaim() async {
    final response = await BenefitApi.getListClaimedBenefits();
    return MyClaimResponse.fromJson(response);
  }
}
