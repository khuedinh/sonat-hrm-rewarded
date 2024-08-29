import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/blocs/user/user_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/transaction_history.dart';
import 'package:sonat_hrm_rewarded/src/models/user.dart';
import 'package:sonat_hrm_rewarded/src/widgets/transaction_history/balance_card.dart';
import 'package:sonat_hrm_rewarded/src/widgets/transaction_history/list_transactions.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  static const routeName = "/transaction-history";

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  int _currentTab = 0;

  void _handleTabChange(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const ScreenTitle(title: "Transaction history"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenTitle(
              title: "Available balance",
              color: theme.colorScheme.onSurface,
              fontSize: 18,
            ),
            const SizedBox(height: 12),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                final UserInfo? userInfo = state.userInfo;

                return  Row(
                  children: [
                    Expanded(
                      child: BalanceCard(
                        title: "Points",
                        value: userInfo?.balance.currentPoint ?? 0,
                        // rateChange: 18.212348,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BalanceCard(
                        title: "Coins",
                        value: userInfo?.balance.currentCoin ?? 0,
                        // rateChange: -24.11231232,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            ScreenTitle(
              title: "Transaction history",
              color: theme.colorScheme.onSurface,
              fontSize: 18,
            ),
            DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: TabBar(
                onTap: _handleTabChange,
                tabs: const [
                  Tab(text: "Points"),
                  Tab(text: "Coins"),
                ],
              ),
            ),
            if (_currentTab == 0)
              Expanded(
                child: ListTransactions(
                  listTransactions: listPointTransactions,
                ),
              ),
            if (_currentTab == 1)
              Expanded(
                child: ListTransactions(
                  listTransactions: listCoinTransactions,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
