import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String datetime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(datetime).toLocal();
  }

  @override
  String toJson(DateTime datetime) =>
      DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(datetime);
}

class DateTimeOrNullConverter implements JsonConverter<DateTime?, String?> {
  const DateTimeOrNullConverter();

  @override
  DateTime? fromJson(String? datetime) {
    return datetime == null
        ? null
        : DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(datetime).toLocal();
  }

  @override
  String? toJson(DateTime? datetime) => datetime == null
      ? null
      : DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(datetime);
}
