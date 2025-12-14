import 'package:intl/intl.dart';

extension NumberExtension on num {
  String toCurrency({int decimalDigits = 0}) {
    return NumberFormat.currency(
      locale: 'vi',
      symbol: r'đ',
      decimalDigits: decimalDigits,
    ).format(this).trim();
  }

  bool get isInt => this % 1 == 0;

  String get toArc {
    if ((this - 1) % 10 == 0) {
      return '${this}st';
    }
    if ((this - 2) % 10 == 0) {
      return '${this}nd';
    }
    if ((this - 3) % 10 == 0) {
      return '${this}rd';
    }
    return '${this}th';
  }
}
