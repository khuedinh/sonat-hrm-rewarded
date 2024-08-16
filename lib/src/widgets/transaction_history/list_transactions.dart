import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';

class ListTransactions extends StatelessWidget {
  const ListTransactions({
    super.key,
    required this.listTransactions,
  });

  final List<TransactionHistory> listTransactions;

  List<dynamic> groupTransactionHistoryByDate(
    List<TransactionHistory> listTransactionHistory,
  ) {
    final Map<String, List<TransactionHistory>> groupedTransactionHistory = {};

    for (var transactionHistory in listTransactionHistory) {
      final String dateKey =
          DateFormat('dd-MM-yyyy').format(transactionHistory.createdAt);
      if (groupedTransactionHistory.containsKey(dateKey)) {
        groupedTransactionHistory[dateKey]!.add(transactionHistory);
      } else {
        groupedTransactionHistory[dateKey] = [transactionHistory];
      }
    }

    List<Map<String, dynamic>> result = [];

    groupedTransactionHistory.forEach((key, value) {
      result.add({
        "date": key,
        "transactions": value,
      });
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedTransaction = groupTransactionHistoryByDate(listTransactions);

    return ListView.builder(
      itemCount: groupedTransaction.length,
      itemBuilder: (context, index) {
        final transactionHistory = groupedTransaction[index];
        final listTransactions =
            transactionHistory['transactions'] as List<TransactionHistory>;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                ),
                child: Text(
                  transactionHistory['date'],
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              ...listTransactions.map((item) {
                final amountChange = item.currentBalance - item.previousBalance;
                return ListTile(
                  leading: item.content.contains("Received")
                      ? const Icon(Icons.arrow_forward)
                      : const Icon(Icons.arrow_back),
                  title: Text(
                    item.content,
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ending balance: ${item.currentBalance}",
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        DateFormat('HH:mm:ss').format(
                          item.createdAt,
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: Text(
                    '${amountChange > 0 ? "+" : "-"}${amountChange.abs()}',
                    style: TextStyle(
                      color: amountChange > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
