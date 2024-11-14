import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';
import 'package:sonat_hrm_rewarded/src/service/api/transaction_history_api.dart';

part 'transaction_history_event.dart';
part 'transaction_history_state.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  TransactionHistoryBloc() : super(const TransactionHistoryState()) {
    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(
        tab: event.tab,
      ));
    });

    //  point
    on<GetTransactionHistoryPointEvent>((event, emit) async {
      if (state.listPointTransactions.isNotEmpty) {
        return;
      }

      emit(state.copyWith(isLoading: true));

      final queryParams = {
        "page": state.pagePoint,
        "pageSize": state.pageSize,
        "currency": CurrencyType.points.toString().split('.').last,
      };

      final response = await TransactionHistoryApi.getTransactionHistory(
        queryParams: queryParams,
      );
      final responseData = TransactionHistoryResponse.fromJson(response);

      emit(
        state.copyWith(
          isLoading: false,
          hasReachedMaxPoint: responseData.page == responseData.totalPages,
          listPointTransactions: responseData.data,
        ),
      );
    });

    on<LoadMoreTransactionHistoryPointEvent>((event, emit) async {
      if (state.hasReachedMaxPoint) return;

      final queryParams = {
        "page": state.pagePoint + 1,
        "pageSize": state.pageSize,
        "currency": CurrencyType.points.toString().split('.').last,
      };

      final response = await TransactionHistoryApi.getTransactionHistory(
        queryParams: queryParams,
      );
      final responseData = TransactionHistoryResponse.fromJson(response);

      emit(
        state.copyWith(
          pagePoint: state.pagePoint + 1,
          hasReachedMaxPoint: responseData.page == responseData.totalPages,
          listPointTransactions: List.of(state.listPointTransactions)
            ..addAll(responseData.data),
        ),
      );
    }, transformer: droppable());

    on<RefreshTransactionHistoryPointEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, pagePoint: 1));

      final queryParams = {
        "page": 1,
        "pageSize": state.pageSize,
        "currency": CurrencyType.points.toString().split('.').last,
      };

      final response = await TransactionHistoryApi.getTransactionHistory(
        queryParams: queryParams,
      );
      final responseData = TransactionHistoryResponse.fromJson(response);

      emit(
        state.copyWith(
          isLoading: false,
          hasReachedMaxPoint: responseData.page == responseData.totalPages,
          listPointTransactions: responseData.data,
        ),
      );
    });

    // coin
    on<GetTransactionHistoryCoinEvent>((event, emit) async {
      if (state.listCoinTransactions.isNotEmpty) {
        return;
      }

      emit(state.copyWith(isLoading: true));

      final queryParams = {
        "page": state.pageCoin,
        "pageSize": state.pageSize,
        "currency": CurrencyType.coins.toString().split('.').last,
      };

      final response = await TransactionHistoryApi.getTransactionHistory(
        queryParams: queryParams,
      );
      final responseData = TransactionHistoryResponse.fromJson(response);

      emit(
        state.copyWith(
          isLoading: false,
          hasReachedMaxCoin: responseData.page == responseData.totalPages,
          listCoinTransactions: responseData.data,
        ),
      );
    });

    on<LoadMoreTransactionHistoryCoinEvent>((event, emit) async {
      if (state.hasReachedMaxCoin) return;

      final queryParams = {
        "page": state.pageCoin + 1,
        "pageSize": state.pageSize,
        "currency": CurrencyType.coins.toString().split('.').last,
      };

      final response = await TransactionHistoryApi.getTransactionHistory(
        queryParams: queryParams,
      );
      final responseData = TransactionHistoryResponse.fromJson(response);

      emit(
        state.copyWith(
          pageCoin: state.pageCoin + 1,
          hasReachedMaxCoin: responseData.page == responseData.totalPages,
          listCoinTransactions: List.of(state.listCoinTransactions)
            ..addAll(responseData.data),
        ),
      );
    }, transformer: droppable());

    on<RefreshTransactionHistoryCoinEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, pageCoin: 1));

      final queryParams = {
        "page": 1,
        "pageSize": state.pageSize,
        "currency": CurrencyType.coins.toString().split('.').last,
      };

      final response = await TransactionHistoryApi.getTransactionHistory(
        queryParams: queryParams,
      );
      final responseData = TransactionHistoryResponse.fromJson(response);

      emit(
        state.copyWith(
          isLoading: false,
          hasReachedMaxCoin: responseData.page == responseData.totalPages,
          listCoinTransactions: responseData.data,
        ),
      );
    });
  }
}
