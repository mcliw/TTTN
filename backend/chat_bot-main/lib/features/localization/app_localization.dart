import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_home/features/localization/localization_controller.dart';
import 'package:smart_home/features/localization/localization_utils.dart';


class AppLocalization extends StatefulWidget {
  final Widget child;
  final List<Locale> supportedLocales;
  final AppLocale initLocale;

  const AppLocalization({
    super.key,
    required this.supportedLocales,
    required this.initLocale,
    required this.child,
  });

  // ignore: library_private_types_in_public_api
  static _LocalizationProvider? of(BuildContext context) => _LocalizationProvider.of(context);

  @override
  State<AppLocalization> createState() => _AppLocalizationState();
}

class _AppLocalizationState extends State<AppLocalization> {
  _AppLocalizationsDelegate? delegate;
  late final LocalizationController localizationController;
  late AppLocale _appLocale;

  @override
  void initState() {
    _appLocale = widget.initLocale;
    localizationController = LocalizationController(locale: _appLocale);
    localizationController.addListener(() {
      if (mounted) {
        setState(() {
          _appLocale = localizationController.locale;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    localizationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _LocalizationProvider(
      widget,
      localizationController,
      delegate: _AppLocalizationsDelegate(
        localizationController: localizationController,
        supportedLocales: widget.supportedLocales,
        appLocale: _appLocale,
      ),
    );
  }
}

class _LocalizationProvider extends InheritedWidget {
  final AppLocalization parent;
  final LocalizationController _localeState;
  final AppLocale? currentAppLocale;
  final _AppLocalizationsDelegate delegate;

  List<LocalizationsDelegate> get delegates => [
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  /// Get List of supported locales
  List<Locale> get supportedLocales => parent.supportedLocales;

  // _EasyLocalizationDelegate get delegate => parent.delegate;

  _LocalizationProvider(
    this.parent,
    this._localeState, {
    required this.delegate,
  })  : currentAppLocale = _localeState.locale,
        super(child: parent.child);

  /// Get current app locale
  AppLocale get appLocale => _localeState.locale;

  /// Change app locale
  Future<void> setLocale(AppLocale appLocale) async {
    // Check old locale
    // Remove temporary
    // if (appLocale != _localeState.locale) {
    //   assert(parent.supportedLocales.contains(appLocale.locale));
    //   await _localeState.setLocale(appLocale);
    // }
  }

  @override
  bool updateShouldNotify(_LocalizationProvider oldWidget) {
    return oldWidget.currentAppLocale != appLocale;
  }

  static _LocalizationProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_LocalizationProvider>();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<LocalizationUtils> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  final List<Locale>? supportedLocales;
  final LocalizationController? localizationController;
  final AppLocale? appLocale;

  _AppLocalizationsDelegate({
    this.supportedLocales,
    this.localizationController,
    this.appLocale,
  });

  @override
  bool isSupported(Locale locale) {
    return supportedLocales!.contains(locale);
  }

  @override
  Future<LocalizationUtils> load(Locale locale) async {
    if (localizationController!.translations == null) {
      await localizationController!.loadAssets();
    }
    LocalizationUtils.load(
      locale: locale,
      translations: localizationController!.translations,
    );
    return Future.value(LocalizationUtils.instance);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) {
    return appLocale?.locale != old.appLocale?.locale || appLocale?.isPro != old.appLocale?.isPro;
  }
}
