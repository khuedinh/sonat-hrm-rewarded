import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/notification.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  static const routeName = "/notifications";

  @override
  State<NotificationsScreen> createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        centerTitle: true,
        title: const ScreenTitle(title: "Notifications"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  content: const Text("Mark all as read successfully!"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {},
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: listNotifications.length,
        itemBuilder: (context, index) {
          final notification = listNotifications[index];
          return Container(
            decoration: BoxDecoration(
              color: !notification.hasRead!
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : null,
            ),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: const SizedBox(
                width: 50,
                height: 50,
                child: CircleAvatar(
                  child: Icon(Icons.notifications),
                ),
              ),
              title: Text(
                notification.content,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: notification.hasRead!
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${notification.content.contains('Receive') ? "From" : "To"} ${notification.from}',
              ),
              trailing: PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: "mark_as_read",
                    child: Text("Mark as read"),
                  ),
                  const PopupMenuItem(
                    value: "remove",
                    child: Text('Remove'),
                  ),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
