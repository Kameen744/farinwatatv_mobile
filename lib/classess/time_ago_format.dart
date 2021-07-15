import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeAgoFormat {
  static String format({date}) {
    return timeago
        .format(DateTime.parse(date), allowFromNow: true, locale: 'en')
        .toString();
  }

  static String formatDate({date}) {
    return DateFormat('dd-MM-yyyy – kk:mm')
        .format(DateTime.parse(date))
        .toString();
  }
}
