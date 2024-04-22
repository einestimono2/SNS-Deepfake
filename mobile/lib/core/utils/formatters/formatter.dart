import 'package:intl/intl.dart';

class Formatter {
  Formatter._();

  static String formatDate(DateTime? date) {
    date ??= DateTime.now();

    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: 'đ').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    return phoneNumber;
  }
}
