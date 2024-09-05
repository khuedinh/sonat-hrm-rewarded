import 'package:intl/intl.dart';

DateTime parseDate(String date) {
  return DateTime.parse(date);
}

String formatDate(DateTime date, {String? format}) {
  return DateFormat(format ?? "dd/MM/yyyy HH:mm:ss").format(date.toLocal());
}
