part of "transaction_history_bloc.dart";

sealed class TransactionHistoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeTabEvent extends TransactionHistoryEvent {
  final int tab;

  ChangeTabEvent({required this.tab});

  @override
  List<Object> get props => [tab];
}

class GetTransactionHistoryPointEvent extends TransactionHistoryEvent {
  GetTransactionHistoryPointEvent();

  @override
  List<Object> get props => [];
}

class GetTransactionHistoryCoinEvent extends TransactionHistoryEvent {
  GetTransactionHistoryCoinEvent();

  @override
  List<Object> get props => [];
}

class LoadMoreTransactionHistoryPointEvent extends TransactionHistoryEvent {
  LoadMoreTransactionHistoryPointEvent();
  @override
  List<Object> get props => [];
}

class LoadMoreTransactionHistoryCoinEvent extends TransactionHistoryEvent {
  LoadMoreTransactionHistoryCoinEvent();
  @override
  List<Object> get props => [];
}

class RefreshTransactionHistoryPointEvent extends TransactionHistoryEvent {
  RefreshTransactionHistoryPointEvent();

  @override
  List<Object> get props => [];
}

class RefreshTransactionHistoryCoinEvent extends TransactionHistoryEvent {
  RefreshTransactionHistoryCoinEvent();

  @override
  List<Object> get props => [];
}
