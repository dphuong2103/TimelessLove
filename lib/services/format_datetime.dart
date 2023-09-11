// ignore: file_names
import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final format = DateFormat('yyyy-MM-dd hh:mm');
  return format.format(dateTime);
}

String formatDate(DateTime dateTime) {
  final format = DateFormat('yyyy-MM-dd');
  return format.format(dateTime);
}

String formatTime(DateTime dateTime) {
  final format = DateFormat('hh:mm a');
  return format.format(dateTime);
}

String formatDateVnLocale(DateTime dateTime) {
  final format = DateFormat('dd/MM/yyyy');
  return format.format(dateTime);
}
