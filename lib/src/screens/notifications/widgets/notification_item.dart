import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sonat_hrm_rewarded/src/models/notification.dart';
import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/bloc/notification_bloc.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

class NotificationItem extends StatefulWidget {
  final NotificationData data;

  const NotificationItem({super.key, required this.data});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  String generateMessage(TransactionHistoryData transactionHistory) {
    if (transactionHistory.type == TransactionType.gain) {
      if (transactionHistory.event == TransactionEvent.update) {
        return "Admin updated your ${transactionHistory.currency.toString().split('.').last} balance.";
      }

      if (transactionHistory.event == TransactionEvent.allocate) {
        return "You have been allocated ${formatNumber(transactionHistory.amount)} ${transactionHistory.currency.toString().split('.').last}.";
      }

      if (transactionHistory.event == TransactionEvent.recognition) {
        return "You have been recognized by ${transactionHistory.source!.name} with ${formatNumber(transactionHistory.amount)} ${transactionHistory.currency.toString().split('.').last}.";
      }
    }

    if (transactionHistory.type == TransactionType.lose) {
      if (transactionHistory.event == TransactionEvent.recognition) {
        return "You recognized ${transactionHistory.sink!.map((item) => item.name).join(", ")} with ${formatNumber(transactionHistory.amount)} ${transactionHistory.currency.toString().split('.').last}.";
      }
      if (transactionHistory.event == TransactionEvent.redeem_benefit) {
        return "You redeemed ${transactionHistory.description} by ${formatNumber(transactionHistory.amount)}.";
      }
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    final DateTime dateTime =
        DateTime.parse(widget.data.createdAt ?? '').toLocal();
    final DateFormat dateFormat = DateFormat('dd MMMM, yyyy - HH:mm');
    final formattedDate = dateFormat.format(dateTime);

    return Material(
      child: InkWell(
        onTap: () {
          context
              .read<NotificationBloc>()
              .add(ReadNotiEvent(notiId: widget.data.id!));
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          color: !(widget.data.isRead ?? false)
              ? theme.colorScheme.primary.withOpacity(0.1)
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                generateMessage(widget.data.transactionHistory!),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.87),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              if (widget.data.transactionHistory?.description.trim() != null &&
                  widget.data.transactionHistory!.description.trim().isNotEmpty)
                Text(
                  widget.data.transactionHistory!.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.45),
                  ),
                ),
              const SizedBox(
                height: 4,
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
