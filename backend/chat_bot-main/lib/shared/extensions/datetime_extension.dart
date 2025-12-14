import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String format(String format) {
    return DateFormat(format).format(this);
  }

  DateTime get normalizeDate => DateTime(year, month, day);

  String get dayAgo {
    final now = DateTime.now().normalizeDate;
    if (now.difference(this).inDays == 0) {
      return 'Hôm nay';
    }
    if (now.difference(this).inDays.abs() == 1) {
      return 'Hôm qua';
    }
    return format('dd/MM/yyyy');
  }

  String get time12hFormat {
    return DateFormat('HH:mm:ss').format(this);
  }

  String get minAgo {
    final now = DateTime.now();
    final diffMins = now.difference(this).inMinutes.abs();
    final diffHours = now.difference(this).inHours.abs();
    if (diffHours > 8) {
      return format('HH:mm');
    }
    if (diffHours > 0) {
      return '$diffHours giờ trước';
    }
    if (diffMins == 0) {
      return 'Vừa xong';
    }
    return '$diffMins phút trước';
  }

  String get greetingKey {
    if (hour <= 12) {
      return 'home.greeting.morning';
    }
    if (hour > 12 && hour <= 18) {
      return 'home.greeting.afternoon';
    }
    return 'home.greeting.evening';
  }

  // TM_WEEKDAY 0=Sunday, ..., 6=Saturday
  int get convertToTmWday {
    return weekday % 7;
  }
}
