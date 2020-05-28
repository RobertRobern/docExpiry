// General validation rules

import 'package:intl/intl.dart';

class Validate {
  // Validations
  static String validateTitle(String val) {
    return (val != null && val != "") ? null : "Title cannot be empty";
  }

  static String getExpiryStr(String expires) {
    var e = DateUtils.convertToDate(expires);
    var td = new DateTime.now();

    Duration dif = e.difference(td);
    int dd = dif.inDays + 1;
    return (dd > 0) ? dd.toString() : "0";
  }

  static bool strToBool(String str){
    return (int.parse(str) > 0) ? true : false;
  }

  static bool intToBool(int val){
    return (val > 0) ? true : false;
  }

  static String boolToStr(bool val){
    return (val == true) ? "1" : "0";
  }
  
  static int boolToInt(bool val){
    return (val == true) ? 1: 0;
  }
}

class DateUtils {

  static DateTime convertToDate(String input){
    try {
      var d  = new DateFormat("yyyy-MM-dd").parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  static String convertToDateFull(DateTime input){
    try {
      var formatter = new DateFormat('dd MMM yyyy');
      return formatter.format(input);
    } catch (e) {
      return null;
    }
  }

  static bool isDate(String date){
    try {
      var d = new DateFormat("yyyy-MM-dd").parseStrict(date);
      return true;
    } catch (e) {
      return false;
    }
  }
}
