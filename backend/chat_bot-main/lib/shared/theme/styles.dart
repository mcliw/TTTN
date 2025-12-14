import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/gen/fonts.gen.dart';


import 'colors.dart';

class AppRadius {
  static const double inputRadius = 23;
}

class AppSize {
  static const double buttonHeight = 44;
  static const double inputHeight = 44;
  static const double tagItemHeight = 32;
}

class AppTheme {
  final ColorTheme colors;

  AppTheme(this.colors);

  InputDecorationTheme get lightInputDecorationTheme => InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 16,
        ),
        errorStyle: TextStyle(
          fontFamily: FontFamily.roboto,
          color: colors.textError,
          fontSize: 12,
        ),
        hintStyle: TextStyle(
          fontFamily: FontFamily.roboto,
          color: colors.placeholderColor,
          fontSize: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.inputBorder,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.inputBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.focusedInputBorder,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.focusedInputBorder,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.erroredInputBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.inputBorder,
          ),
        ),
      );

  InputDecorationTheme get darkInputDecorationTheme => InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 16,
        ),
        errorStyle: TextStyle(
          color: colors.textError,
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.inputBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.inputBorder,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.inputBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.focusedInputBorder,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.focusedInputBorder,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputRadius),
          borderSide: BorderSide(
            color: colors.erroredInputBorder,
          ),
        ),
      );

  ThemeData get lightTheme {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
      ),
      primaryColor: colors.primaryColor,
      primarySwatch: colors.swatches,
      brightness: Brightness.light,
      fontFamily: FontFamily.roboto,
      inputDecorationTheme: lightInputDecorationTheme,
      scaffoldBackgroundColor: Colors.white,
      sliderTheme: SliderThemeData(
        trackHeight: 2,
        activeTrackColor: colors.activeSlider,
        activeTickMarkColor: colors.activeSlider,
        inactiveTrackColor: colors.inactiveSlider,
        inactiveTickMarkColor: colors.inactiveSlider,
        thumbColor: colors.inactiveSlider,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        rangeThumbShape:
            const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      primaryColor: colors.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: colors.swatches,
      brightness: Brightness.dark,
      fontFamily: FontFamily.roboto,
      inputDecorationTheme: darkInputDecorationTheme,
      sliderTheme: SliderThemeData(
        trackHeight: 2,
        activeTrackColor: colors.activeSlider,
        activeTickMarkColor: colors.activeSlider,
        inactiveTrackColor: colors.inactiveSlider,
        inactiveTickMarkColor: colors.inactiveSlider,
        thumbColor: colors.inactiveSlider,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        rangeThumbShape:
            const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
      ),
      timePickerTheme: TimePickerThemeData(
        dialTextColor: colors.primaryButton,
        dayPeriodColor: colors.primaryButton.withOpacity(0.1),
        dayPeriodTextColor: colors.primaryButton,
        hourMinuteColor: colors.primaryButton.withOpacity(0.1),
        hourMinuteTextColor: colors.primaryButton,
        dialHandColor: colors.primaryButton.withOpacity(0.2),
      ),
    );
  }
}
