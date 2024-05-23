// import 'package:intl/intl.dart';

import 'package:easy_localization/easy_localization.dart';

import '../utils.dart';

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

  static String getTimeAgo(
    String date,
    String locale, {
    MaxTimeAgoType maxAgoType = MaxTimeAgoType.year,
    bool showTime = false,
    bool showSuffixText = true,
  }) {
    DateTime currentDate = DateTime.now();
    DateTime _date = DateTime.parse(date).toLocal();

    final different = currentDate.difference(_date);

    String handleSuffix(String date) {
      if (showSuffixText) return date;

      String suffixTxt = date.split(' ').last;
      return date.replaceAll(suffixTxt, "");
    }

    String formatDate(String date) {
      String formattedDate =
          DateFormat('${showTime ? 'HH:mm, ' : ''}dd/MM/yyyy', locale)
              .format(_date);

      if (!showSuffixText) {
        formattedDate = handleSuffix(formattedDate);
      }

      return formattedDate;
    }

    if (different.inDays > 365) {
      if (maxAgoType != MaxTimeAgoType.year) return formatDate(date);

      return handleSuffix(
          "TIME_AGO_YEAR".plural((different.inDays / 365).floor()));
    }

    if (different.inDays > 30) {
      if (maxAgoType.index < MaxTimeAgoType.month.index) {
        return formatDate(date);
      }

      return handleSuffix(
          "TIME_AGO_MONTH".plural((different.inDays / 30).floor()));
    }

    if (different.inDays > 7) {
      if (maxAgoType.index < MaxTimeAgoType.week.index) {
        return formatDate(date);
      }

      return handleSuffix(
          "TIME_AGO_WEEK".plural((different.inDays / 7).floor()));
    }

    if (different.inDays > 0) {
      if (maxAgoType.index < MaxTimeAgoType.day.index) {
        return formatDate(date);
      }

      return handleSuffix("TIME_AGO_DAY".plural(different.inDays));
    }

    if (different.inHours > 0) {
      if (maxAgoType.index < MaxTimeAgoType.hour.index) {
        return formatDate(date);
      }

      return handleSuffix("TIME_AGO_HOUR".plural(different.inHours));
    }

    if (different.inMinutes > 0) {
      if (maxAgoType.index < MaxTimeAgoType.minute.index) {
        return formatDate(date);
      }

      return handleSuffix("TIME_AGO_MINUTE".plural(different.inMinutes));
    }

    if (different.inMinutes == 0) {
      if (maxAgoType.index < MaxTimeAgoType.minute.index) {
        return formatDate(date);
      }

      return 'TIME_AGO_JUST_NOW'.tr();
    }

    return formatDate(date);
  }
}
