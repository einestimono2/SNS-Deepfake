// import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static bool is30MinutesDifference(String dateStr1, String dateStr2) {
    DateTime date1 = DateTime.parse(dateStr1);
    DateTime date2 = DateTime.parse(dateStr2);

    return date1.difference(date2).inMinutes.abs() <= 30;
  }

  static bool isYesterday(dynamic dateStr) {
    DateTime now = DateTime.now();
    late final DateTime date;

    if (dateStr is DateTime) {
      date = dateStr;
    } else {
      date = DateTime.parse(dateStr).toLocal();
    }

    return DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        -1;
  }

  static bool isToday(dynamic dateStr) {
    DateTime now = DateTime.now();
    late final DateTime date;

    if (dateStr is DateTime) {
      date = dateStr;
    } else {
      date = DateTime.parse(dateStr).toLocal();
    }

    return DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        0;
  }

  static bool isTomorrow(dynamic dateStr) {
    DateTime now = DateTime.now();
    late final DateTime date;

    if (dateStr is DateTime) {
      date = dateStr;
    } else {
      date = DateTime.parse(dateStr).toLocal();
    }

    return DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        1;
  }
}
