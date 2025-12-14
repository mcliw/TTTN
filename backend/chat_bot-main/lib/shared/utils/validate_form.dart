

import 'package:smart_home/features/localization/localizations.dart';

class Validation {
  Validation();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'validate.incorrect_email'.tr();
    }

    return null;
  }

  static String? validatePass(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.isNotEmpty && value.length < 6) {
      return 'validate.incorrect_pass.password_character'.tr();
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'validate.incorrect_pass.uppercase'.tr();
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'validate.incorrect_pass.specical_character'.tr();
    }

    return null;
  }

  static String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.isNotEmpty && value.length < 3) {
      return 'validate.incorrect_username'.tr();
    }
    return null;
  }
}
