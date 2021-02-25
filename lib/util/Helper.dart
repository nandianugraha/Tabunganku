import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class Helper {

  static String formatToDateTimetoString(DateTime date) {
    var formater = new DateFormat('dd MMMM yyyy');
    var now = formater.format(date);
    return now;
  }

  static showToast(BuildContext context, String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  static String formatCurrencyIdr(String value) {
    try {
      final formatter = new NumberFormat("#,###");
      return "Rp. ${formatter.format(int.parse(value))}";
    } catch (e) {
      return 'Rp. 0';
    }
  }
}