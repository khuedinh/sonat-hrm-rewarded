import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/no_data/no_data.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';
import 'package:sonat_hrm_rewarded/src/screens/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/transaction_history/widgets/list_skeleton.dart';
import 'package:sonat_hrm_rewarded/src/screens/transaction_history/widgets/list_transactions.dart';

class PointTransactionsTab extends StatefulWidget {
  const PointTransactionsTab({super.key});

  @override
  State<PointTransactionsTab> createState() => _PointTransactionsTabState();
}

class _PointTransactionsTabState extends State<PointTransactionsTab>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    BlocProvider.of<TransactionHistoryBloc>(context).add(
      GetTransactionHistoryPointEvent(),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context
          .read<TransactionHistoryBloc>()
          .add(LoadMoreTransactionHistoryPointEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        final List<TransactionHistoryData> listPointTransactions =
            state.listPointTransactions;
        final isLoading = state.isLoading;
        final hasReachedMax = state.hasReachedMaxPoint;

        if (isLoading) {
          return const ListSkeleton();
        }

        return RefreshableWidget(
            controller: _scrollController,
            onRefresh: () async {
              BlocProvider.of<TransactionHistoryBloc>(context).add(
                RefreshTransactionHistoryPointEvent(),
              );
            },
            slivers: [
              if (listPointTransactions.isEmpty)
                const SliverFillRemaining(
                  child: NoData(message: "No transaction history found."),
                ),
              if (listPointTransactions.isNotEmpty)
                ListTransactions(
                  listTransactions: listPointTransactions,
                  hasReachedMax: hasReachedMax,
                )
            ]);
      },
    );
  }
}
