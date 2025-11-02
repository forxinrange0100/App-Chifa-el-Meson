import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  String formattedDate = DateFormat('dd-MM-yyyy, hh:mm a').format(dateTime);
  return formattedDate;
}

String formatHourMinute(DateTime dateTime) {
  String formattedDate = DateFormat('HH:mm').format(dateTime);
  return formattedDate;
}