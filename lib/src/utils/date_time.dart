import 'package:intl/intl.dart';

DateTime parseDate(String date) {
  return DateTime.parse(date);
}

String formatDate(DateTime date) {
  return DateFormat("dd/MM/yyyy HH:mm:ss").format(date);
}
