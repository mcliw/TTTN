

import 'package:smart_home/features/localization/translate_extension.dart';

enum DateTimePicker {
  fromDate,
  toDate;
}

extension DateTimePickerExt on DateTimePicker{
  String get titleI18n{
    switch(this){
      case DateTimePicker.fromDate:return 'module.type_date.from_date'.tr();
      case DateTimePicker.toDate: return 'module.type_date.to_date'.tr();
    }
  }
}