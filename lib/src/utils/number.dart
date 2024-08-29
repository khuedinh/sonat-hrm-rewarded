import 'package:intl/intl.dart';

String formatShortenNumber(int number) {
  return NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '',
  ).format(number);
}

String formatNumber(int number) {
  return NumberFormat.decimalPattern("en_US").format(number);
}
