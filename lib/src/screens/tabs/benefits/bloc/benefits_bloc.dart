import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    on<InitBenefitsData>((BenefitsEvent event, Emitter emit) async {
      if (state.listBenefits.isNotEmpty) return;

      emit(state.copyWith(isLoadingBenefits: true));

      final benefitResponse = await fetchBenefits(state, null);

      emit(state.copyWith(
        isLoadingBenefits: false,
        listBenefits: benefitResponse.data,
        hasReachedMaxBenefits:
            benefitResponse.page == benefitResponse.totalPages,
      ));
    });

    on<LoadMoreBenefits>(
      (event, emit) async {
        if (state.hasReachedMaxBenefits) return;

        final benefitResponse = await fetchBenefits(state, state.page + 1);

        emit(
          state.copyWith(
            page: state.page + 1,
            listBenefits: [...state.listBenefits, ...benefitResponse.data],
            hasReachedMaxBenefits:
                benefitResponse.page == benefitResponse.totalPages,
          ),
        );
      },
      transformer: restartable(),
    );

    on<RefreshBenefitsData>((BenefitsEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingBenefits: true, page: 1));

      final benefitResponse = await fetchBenefits(state, null);

      emit(state.copyWith(
        isLoadingBenefits: false,
        listBenefits: benefitResponse.data,
        hasReachedMaxBenefits:
            benefitResponse.page == benefitResponse.totalPages,
      ));
    });

    on<InitCategoriesData>((BenefitsEvent event, Emitter emit) async {
      if (state.listCategories.isNotEmpty) return;

      emit(state.copyWith(isLoadingCategories: true));

      final listCategories = await fetchCategories();

      emit(state.copyWith(
        listCategories: listCategories,
        isLoadingCategories: false,
      ));
    });

    on<InitMyClaim>((BenefitsEvent event, Emitter emit) async {
      if (state.listArchivedBenefits.isNotEmpty ||
          state.listClaimedBenefits.isNotEmpty) return;

      emit(state.copyWith(isLoadingMyClaim: true));
      final claimedBenefits = await fetchMyClaim();

      emit(state.copyWith(
        isLoadingMyClaim: false,
        listClaimedBenefits: claimedBenefits.readyToUse ?? [],
        listArchivedBenefits: claimedBenefits.archivedBox ?? [],
      ));
    });

    on<RefreshMyClaim>((BenefitsEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingMyClaim: true));
      final claimedBenefits = await fetchMyClaim();

      emit(state.copyWith(
        isLoadingMyClaim: false,
        listClaimedBenefits: claimedBenefits.readyToUse ?? [],
        listArchivedBenefits: claimedBenefits.archivedBox ?? [],
      ));
    });

    on<ChangeTextSearch>(
      (ChangeTextSearch event, Emitter emit) async {
        emit(state.copyWith(
          textSearch: event.text,
          isLoadingBenefits: true,
          page: 1,
        ));

        await Future.delayed(const Duration(milliseconds: 500));
        if (emit.isDone) return;

        final benefitResponse = await fetchBenefits(state, null);

        emit(state.copyWith(
          listBenefits: benefitResponse.data,
          isLoadingBenefits: false,
          hasReachedMaxBenefits:
              benefitResponse.page == benefitResponse.totalPages,
        ));
      },
      transformer: restartable(),
    );

    on<SelectCategory>(
      (SelectCategory event, Emitter emit) async {
        emit(state.copyWith(
          selectedCategory: event.categoryId,
          isLoadingBenefits: true,
          page: 1,
        ));

        await Future.delayed(const Duration(milliseconds: 300));
        if (emit.isDone) return;

        final benefitResponse = await fetchBenefits(state, null);

        emit(state.copyWith(
          listBenefits: benefitResponse.data,
          isLoadingBenefits: false,
          hasReachedMaxBenefits:
              benefitResponse.page == benefitResponse.totalPages,
        ));
      },
      transformer: restartable(),
    );

    on<ChangeFilter>((ChangeFilter event, Emitter emit) async {
      emit(state.copyWith(
        isLoadingBenefits: true,
        page: 1,
        sortPrice: event.sortPrice,
        sortName: event.sortName,
        priceRange: event.priceRange,
      ));

      final benefitResponse = await fetchBenefits(state, null);

      emit(state.copyWith(
        listBenefits: benefitResponse.data,
        isLoadingBenefits: false,
        hasReachedMaxBenefits:
            benefitResponse.page == benefitResponse.totalPages,
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

  Future fetchBenefits(BenefitsState state, int? page) async {
    try {
      final queryParams = {
        'categoryId': state.selectedCategory,
        'page': page ?? state.page,
        'pageSize': state.pageSize,
        'search': state.textSearch,
        "sortPrice": state.sortPrice != null
            ? state.sortPrice == SortPrice.ascending
                ? "ASC"
                : "DESC"
            : null,
        "sortName": state.sortName != null
            ? state.sortName == SortName.aToZ
                ? "ASC"
                : "DESC"
            : null,
        "minPrice": state.priceRange?.start,
        "maxPrice": state.priceRange?.end,
      };

      print(queryParams);

      final response =
          await BenefitApi.getListBenefits(queryParams: queryParams);
      if (response != null) {
        final benefitResponse = BenefitResponse.fromJson(response);

        return benefitResponse;
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
    if (response != null) return CurrentBalance.fromJson(response);
  }

  Future fetchMyClaim() async {
    final response = await BenefitApi.getListClaimedBenefits();
    return MyClaimResponse.fromJson(response);
  }
}
