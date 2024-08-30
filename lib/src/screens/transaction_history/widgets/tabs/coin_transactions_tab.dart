import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/no_data/no_data.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';
import 'package:sonat_hrm_rewarded/src/screens/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/transaction_history/widgets/list_skeleton.dart';
import 'package:sonat_hrm_rewarded/src/screens/transaction_history/widgets/list_transactions.dart';

class CoinTransactionsTab extends StatefulWidget {
  const CoinTransactionsTab({super.key});

  @override
  State<CoinTransactionsTab> createState() => _CoinTransactionsTabState();
}

class _CoinTransactionsTabState extends State<CoinTransactionsTab>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    BlocProvider.of<TransactionHistoryBloc>(context).add(
      GetTransactionHistoryCoinEvent(),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context
          .read<TransactionHistoryBloc>()
          .add(LoadMoreTransactionHistoryCoinEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        final List<TransactionHistoryData> listCoinTransactions =
            state.listCoinTransactions;
        final isLoading = state.isLoading;
        final hasReachedMax = state.hasReachedMaxCoin;

        if (isLoading) {
          return const ListSkeleton();
        }

        return RefreshableWidget(
            onRefresh: () async {
              BlocProvider.of<TransactionHistoryBloc>(context).add(
                RefreshTransactionHistoryCoinEvent(),
              );
            },
            slivers: [
              if (listCoinTransactions.isEmpty)
                const SliverFillRemaining(
                  child: NoData(message: "No transaction history found."),
                ),
              if (listCoinTransactions.isNotEmpty)
                ListTransactions(
                  listTransactions: listCoinTransactions,
                  hasReachedMax: hasReachedMax,
                )
            ]);
      },
    );
  }
}
