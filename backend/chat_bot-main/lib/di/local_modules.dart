import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/data/local/app_provider.dart';

Future<void> registerLocalModules(GetIt getIt) async {
  final prefs = await SharedPreferences.getInstance();
  getIt
    ..registerLazySingleton<SharedPreferences>(() => prefs)
    ..registerLazySingleton(() => AppProvider(getIt()));
}
