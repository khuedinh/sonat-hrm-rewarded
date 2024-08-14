import 'package:sonat_hrm_rewarded/src/models/notification.dart';

final listNotifications = [
  Notification(
    id: "n1",
    from: "Dinh Ngoc Khue",
    to: "Sonat BI Team",
    content: "Receive 3000 points",
    createdAt: DateTime(2024, 08, 08, 12, 43, 33),
  ),
  Notification(
    id: "n2",
    from: "Sonat BI Team",
    to: "Sonat BI Team 2",
    content: "Sent 3000 points",
    createdAt: DateTime(2024, 08, 08, 10, 43, 33),
  ),
  Notification(
    id: "n3",
    from: "Dinh Ngoc Khue",
    to: "Sonat BI Team",
    content: "Receive 3000 points",
    createdAt: DateTime(2024, 08, 07, 09, 23, 33),
    hasRead: true,
  ),
  Notification(
    id: "n4",
    from: "Sonat BI Team 2",
    to: "Sonat BI Team",
    content: "Receive a secret card",
    createdAt: DateTime(2024, 08, 06, 18, 15, 33),
    hasRead: true,
  ),
  Notification(
    id: "n5",
    from: "Dinh Ngoc Khue",
    to: "Sonat BI Team 3",
    content: "Request to send 3000 points",
    createdAt: DateTime(2024, 08, 05, 16, 43, 33),
    hasRead: true,
  ),
];
