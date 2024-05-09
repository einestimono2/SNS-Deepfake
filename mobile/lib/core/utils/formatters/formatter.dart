import 'package:intl/intl.dart';

import '../utils.dart';

class Formatter {
  Formatter._();

  static String formatDateWithSpecificWeekday(String dateStr, String locale) {
    DateTime date = DateTime.parse(dateStr).toLocal();
    DateTime now = DateTime.now();

    if (DateHelper.isToday(date)) {
      return DateFormat('HH:mm', locale).format(date);
    }

    Duration diff = now.difference(date);
    if (diff.inDays <= 7) {
      return DateFormat('EEEE', locale).format(date);
    } else if (diff.inDays <= 365) {
      return DateFormat('d/M', locale).format(date);
    }

    return DateFormat('d/M/yyyy', locale).format(date);
  }

  static String formatMessageTime(String dateStr, String locale) {
    DateTime date = DateTime.parse(dateStr).toLocal();
    DateTime now = DateTime.now();

    if (DateHelper.isToday(date)) {
      return DateFormat('HH:mm', locale).format(date);
    }

    Duration diff = now.difference(date);
    if (diff.inDays <= 7) {
      return DateFormat('HH:mm, EEEE', locale).format(date);
    } else if (diff.inDays <= 365) {
      return DateFormat('HH:mm, d/M', locale).format(date);
    }

    return DateFormat('HH:mm, d/M/yyyy', locale).format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: 'đ').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    return phoneNumber;
  }
}
