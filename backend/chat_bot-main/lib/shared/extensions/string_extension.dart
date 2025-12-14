extension StringExtension on String? {
  String? get standardlizePhone {
    if (this != null) {
      if (this!.startsWith('0')) {
        return this!.substring(1);
      }
    }
    return this;
  }
}
