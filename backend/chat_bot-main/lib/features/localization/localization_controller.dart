import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

class AppLocale extends Equatable {
  final Locale locale;
  final bool isPro;

  const AppLocale({
    required this.locale,
    this.isPro = false,
  });

  String get toStringWithSeparator => '${locale.languageCode}-${locale.countryCode}';

  String get languageCode => locale.languageCode;

  String? get countryCode => locale.countryCode;

  @override
  List<Object?> get props => [locale, isPro];
}

class LocalizationController extends ChangeNotifier {
  late AppLocale _locale;

  Map<String, dynamic>? _translations;
  Map<String, dynamic>? get translations => _translations;

  LocalizationController({
    required AppLocale locale,
  }) : _locale = locale;

  AppLocale get locale => _locale;

  Future<void> setLocale(AppLocale locale) async {
    _locale = locale;
    await loadAssets();
    notifyListeners();
  }

  Future<bool> loadAssets() async {
    final _isPro = _locale.isPro;
    Map<String, dynamic> _proJson = {};
    try {
      final proStr = await rootBundle.loadString(
          'assets/i18n/${_locale.toStringWithSeparator}-${LocalizationConstants.proPrefix}.json');
      _proJson = expandJson(json.decode(proStr));
    } catch (_) {}
    final rootStr =
        await rootBundle.loadString('assets/i18n/${_locale.toStringWithSeparator}.json');
    _translations = mergeJson(
      _isPro,
      expandJson(json.decode(rootStr)),
      _proJson,
    );
    return true;
  }

  Map<String, dynamic> mergeJson(
    bool override,
    Map<String, dynamic> json1,
    Map<String, dynamic> json2,
  ) {
    json2.forEach((key, value) {
      if (!json1.containsKey(key)) {
        json1.addEntries([MapEntry(key, value)]);
      } else {
        if (override) {
          json1[key] = value;
        }
      }
    });
    return json1;
  }

  Map<String, dynamic> expandJson(
    Map<String, dynamic> json1, {
    Map<String, dynamic>? json2,
    String? initKey,
  }) {
    json2 ??= {};
    for (final key in json1.keys) {
      final value = json1[key];
      final newKey = initKey == null ? key : '$initKey.$key';
      if (value is Map) {
        json2.addAll(
          expandJson(
            value as Map<String, dynamic>,
            json2: json2,
            initKey: newKey,
          ),
        );
      } else {
        json2.addEntries([MapEntry(newKey, value)]);
      }
    }
    return json2;
  }
}
