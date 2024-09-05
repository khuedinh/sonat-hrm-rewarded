import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/activity_indicator/activity_indicator.dart';
import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

class ListTransactions extends StatelessWidget {
  const ListTransactions({
    super.key,
    required this.listTransactions,
    required this.hasReachedMax,
  });

  final List<TransactionHistoryData> listTransactions;
  final bool hasReachedMax;

  List<dynamic> groupTransactionHistoryByDate(
    List<TransactionHistoryData> listTransactionHistory,
  ) {
    final Map<String, List<TransactionHistoryData>> groupedTransactionHistory =
        {};

    for (var transactionHistory in listTransactionHistory) {
      final String dateKey = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(transactionHistory.createdAt).toLocal());
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

  String generateMessage(TransactionHistoryData transactionHistory) {
    if (transactionHistory.type == TransactionType.gain) {
      if (transactionHistory.event == TransactionEvent.update) {
        return "Admin updated your ${transactionHistory.currency.toString().split('.').last} balance.";
      }

      if (transactionHistory.event == TransactionEvent.allocate) {
        return "You have been allocated <b>${formatNumber(transactionHistory.amount)} ${transactionHistory.currency.toString().split('.').last}</b>.";
      }

      if (transactionHistory.event == TransactionEvent.recognition) {
        return "You have been recognized with <b>${formatNumber(transactionHistory.amount)} ${transactionHistory.currency.toString().split('.').last}</b>.";
      }
    }

    if (transactionHistory.type == TransactionType.lose) {
      if (transactionHistory.event == TransactionEvent.recognition) {
        return "You recognized <b>${transactionHistory.sink!.map((item) => item.name).join(", ")}</b> with <b>${formatNumber(transactionHistory.amount)} ${transactionHistory.currency.toString().split('.').last}</b>.";
      }
      if (transactionHistory.event == TransactionEvent.redeem_benefit) {
        return "You redeemed <b>${transactionHistory.description}</b> with <b>${formatNumber(transactionHistory.amount)}</b>.";
      }
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedTransaction = groupTransactionHistoryByDate(listTransactions);

    return SliverList.builder(
      itemCount: hasReachedMax
          ? groupedTransaction.length
          : groupedTransaction.length + 1,
      itemBuilder: (context, index) {
        return index >= groupedTransaction.length
            ? const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(child: ActivityIndicator()),
              )
            : Padding(
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
                        groupedTransaction[index]['date'],
                        style: theme.textTheme.titleSmall!.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    ...groupedTransaction[index]['transactions'].map((item) {
                      return ListTile(
                        titleTextStyle: TextStyle(
                            fontSize: theme.textTheme.bodyMedium!.fontSize,
                            color: theme.colorScheme.onSurface),
                        leading: item.type == TransactionType.gain
                            ? const Icon(Icons.arrow_forward)
                            : const Icon(Icons.arrow_back),
                        title: HtmlWidget(
                          generateMessage(item),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ending balance: ${formatNumber(item.endingBalance)}",
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              DateFormat('HH:mm:ss').format(
                                DateTime.parse(item.createdAt).toLocal(),
                              ),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${item.type == TransactionType.gain ? "+" : "-"}${formatNumber(item.amount)}',
                          style: TextStyle(
                            color: item.type == TransactionType.gain
                                ? Colors.green
                                : Colors.red,
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
