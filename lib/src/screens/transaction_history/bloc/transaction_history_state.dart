part of "transaction_history_bloc.dart";

class TransactionHistoryState extends Equatable {
  const TransactionHistoryState({
    this.tab = 0,
    this.isLoading = true,
    this.listPointTransactions = const [],
    this.listCoinTransactions = const [],
    this.hasReachedMaxPoint = false,
    this.hasReachedMaxCoin = false,
    this.pagePoint = 1,
    this.pageCoin = 1,
    this.pageSize = 10,
  });

  final int tab;
  final bool isLoading;
  final List<TransactionHistoryData> listPointTransactions;
  final List<TransactionHistoryData> listCoinTransactions;
  final bool hasReachedMaxPoint;
  final bool hasReachedMaxCoin;
  final int pagePoint;
  final int pageCoin;
  final int pageSize;

  TransactionHistoryState copyWith({
    int? tab,
    bool? isLoading,
    bool? hasReachedMaxPoint,
    bool? hasReachedMaxCoin,
    List<TransactionHistoryData>? listPointTransactions,
    List<TransactionHistoryData>? listCoinTransactions,
    int? pagePoint,
    int? pageCoin,
  }) {
    return TransactionHistoryState(
      tab: tab ?? this.tab,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMaxPoint: hasReachedMaxPoint ?? this.hasReachedMaxPoint,
      hasReachedMaxCoin: hasReachedMaxPoint ?? this.hasReachedMaxCoin,
      listPointTransactions:
          listPointTransactions ?? this.listPointTransactions,
      listCoinTransactions: listCoinTransactions ?? this.listCoinTransactions,
      pagePoint: pagePoint ?? this.pagePoint,
      pageCoin: pageCoin ?? this.pageCoin,
    );
  }

  @override
  List<Object?> get props => [
        tab,
        isLoading,
        listPointTransactions,
        listCoinTransactions,
        hasReachedMaxPoint,
        hasReachedMaxCoin,
        pagePoint,
        pageCoin,
        pageSize,
      ];
}
