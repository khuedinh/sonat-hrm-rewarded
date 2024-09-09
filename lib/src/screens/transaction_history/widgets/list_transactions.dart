import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/activity_indicator/activity_indicator.dart';
import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';
import 'package:sonat_hrm_rewarded/src/utils/generate_message_history.dart';
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
                            ? const Icon(
                                Icons.input_rounded,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.output_rounded,
                                color: Colors.red,
                              ),
                        title: HtmlWidget(
                          generateMessage(item, context),
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
