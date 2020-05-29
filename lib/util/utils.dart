// General validation rules

import 'package:intl/intl.dart';

class Validate {
  // Validations
  static String validateTitle(String val) {
    return (val != null && val != "") ? null : "Title cannot be empty";
  }

  static String getExpiryStr(String expires) {
    var convertedDate = DateUtils.convertToDate(expires);
    var todaysDate = new DateTime.now();

    Duration diffirence = convertedDate.difference(todaysDate);
    int days = diffirence.inDays + 1;
    return (days > 0) ? days.toString() : "0";
  }

  static bool strToBool(String str) {
    return (int.parse(str) > 0) ? true : false;
  }

  static bool intToBool(int val) {
    return (val > 0) ? true : false;
  }

  static String boolToStr(bool val) {
    return (val == true) ? "1" : "0";
  }

  static int boolToInt(bool val) {
    return (val == true) ? 1 : 0;
  }
}

class DateUtils {
  static DateTime convertToDate(String input) {
    try {
      var convertedDate = new DateFormat("yyyy-MM-dd").parseStrict(input);
      return convertedDate;
    } catch (e) {
      return null;
    }
  }

  static String convertToDateFull(DateTime input) {
    try {
      var formatter = new DateFormat('dd MMM yyyy');
      return formatter.format(input);
    } catch (e) {
      return null;
    }
  }

  static bool isDate(String date) {
    try {
      var convertedDate = new DateFormat("yyyy-MM-dd").parseStrict(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isValidDate(String date) {
    if (date.isEmpty || !date.contains("-") || date.length < 10) return false;

    List<String> dateItems = date.split("-");
    var d = DateTime(int.parse(dateItems[0]), int.parse(dateItems[1]),
        int.parse(dateItems[2]));
    return d != null && isDate(date) && d.isAfter(new DateTime.now());
  }

  // String functions
  static String daysAheadAsStr(int daysAhead) {
    var now = new DateTime.now();
    DateTime ft = now.add(new Duration(days: daysAhead));
    return formatDateASStr(ft);
  }

  static String formatDateASStr(DateTime ft) {
    return ft.year.toString() +
        "-" +
        ft.month.toString().padLeft(2, "0") +
        "-" +
        ft.day.toString().padLeft(2, "0");
  }

  static String trimDate(String date){
    if(date.contains(" ")){
      List<String> p = date.split(" ");
      return p[0];
    }
    else{
      return date;
    }
  }
}
