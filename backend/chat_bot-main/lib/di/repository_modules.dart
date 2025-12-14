import 'package:get_it/get_it.dart';
import 'package:smart_home/repository/auth_repository.dart';
import 'package:smart_home/repository/module_repository.dart';
import 'package:smart_home/repository/user_repository.dart';

Future<void> registerRepositoryModules(GetIt getIt) async {
  getIt
    ..registerLazySingleton(() => ModuleRespository(getIt(), getIt()))
    ..registerLazySingleton(() => AuthRepository(getIt(), getIt()))
    ..registerLazySingleton(
      () => UserRepository(appProvider: getIt(), appConfig: getIt()),
    );
}
