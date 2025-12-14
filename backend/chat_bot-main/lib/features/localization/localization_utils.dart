import 'package:flutter/material.dart';

class LocalizationUtils {
  Map<String, dynamic>? _translations;
  late Locale _locale;
  Locale get locale => _locale;
  static LocalizationUtils? _instance;
  static LocalizationUtils get instance => _instance ?? (_instance = LocalizationUtils());

  LocalizationUtils();

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static LocalizationUtils? of(BuildContext context) {
    return Localizations.of<LocalizationUtils>(context, LocalizationUtils);
  }

  final RegExp _replaceArgRegex = RegExp('{}');
  final RegExp _linkKeyMatcher = RegExp(r'(?:@(?:\.[a-z]+)?:(?:[\w\-_|.]+|\([\w\-_|.]+\)))');
  final RegExp _linkKeyPrefixMatcher = RegExp(r'^@(?:\.([a-z]+))?:');
  final RegExp _bracketsMatcher = RegExp('[()]');
  final _modifiers = <String, String Function(String?)>{
    'upper': (String? val) => val!.toUpperCase(),
    'lower': (String? val) => val!.toLowerCase(),
    'capitalize': (String? val) => '${val![0].toUpperCase()}${val.substring(1)}'
  };

  static bool load({
    required Locale locale,
    Map<String, dynamic>? translations,
  }) {
    instance._locale = locale;
    instance._translations = translations;
    return translations != null;
  }

  String tr(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? prefix,
  }) {
    late String res;
    if (prefix != null) {
      res = _prefix(key, prefix: prefix);
    } else {
      res = _resolve(key);
    }
    res = _replaceLinks(res);
    res = _replaceNamedArgs(res, namedArgs);
    return _replaceArgs(res, args);
  }

  String _prefix(
    String key, {
    required String prefix,
  }) {
    return _resolve('$prefix.$key');
  }

  String _replaceLinks(String res) {
    final matches = _linkKeyMatcher.allMatches(res);
    var result = res;

    for (final match in matches) {
      final link = match[0]!;
      final linkPrefixMatches = _linkKeyPrefixMatcher.allMatches(link);
      final linkPrefix = linkPrefixMatches.first[0]!;
      final formatterName = linkPrefixMatches.first[1];

      // Remove the leading @:, @.case: and the brackets
      final linkPlaceholder = link.replaceAll(linkPrefix, '').replaceAll(_bracketsMatcher, '');

      var translated = _resolve(linkPlaceholder);

      if (formatterName != null) {
        if (_modifiers.containsKey(formatterName)) {
          translated = _modifiers[formatterName]!(translated);
        }
      }
      result = translated.isEmpty ? result : result.replaceAll(link, translated);
    }

    return result;
  }

  String _replaceArgs(String res, List<String>? args) {
    if (args == null || args.isEmpty) return res;
    for (final str in args) {
      res = res.replaceFirst(_replaceArgRegex, str);
    }
    return res;
  }

  String _replaceNamedArgs(String res, Map<String, String>? args) {
    if (args == null || args.isEmpty) return res;
    args.forEach((String key, String value) => res = res.replaceAll(RegExp('{$key}'), value));
    return res;
  }

  String _resolve(String key) {
    return _translations?[key] ?? key;
  }
}
