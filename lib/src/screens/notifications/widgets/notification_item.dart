import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sonat_hrm_rewarded/src/models/notification.dart';

class NotificationItem extends StatefulWidget {
  final NotificationData data;

  const NotificationItem({super.key, required this.data});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
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
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          color: !(widget.data.isRead ?? false)
              ? theme.colorScheme.primary.withOpacity(0.1)
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.data.transactionHistory?.event ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.87),
                  )),
              const SizedBox(
                height: 5,
              ),
              Text(widget.data.transactionHistory?.description ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.45),
                  )),
              const SizedBox(
                height: 5,
              ),
              Text(formattedDate,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
