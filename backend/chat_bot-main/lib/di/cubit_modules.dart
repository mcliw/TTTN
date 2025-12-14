import 'package:get_it/get_it.dart';
import 'package:smart_home/shared/cubits/app_cubit/app_cubit.dart';


Future<void> registerCubitModules(GetIt getIt) async {
  // register cubit modules
  getIt
    ..registerLazySingleton(() => AppCubit(authRepository: getIt()));
    // ..registerLazySingleton(
    //   () => SocketCubit(userRepository: getIt()),
    // )
    // ..registerFactoryParam<ModuleDetailsCubit, Module, dynamic>(
    //   (module, _) => ModuleDetailsCubit(
    //     moduleRespository: getIt(),
    //     userRepository: getIt(),
    //     module: module,
    //   ),
    // )
    // ..registerFactory(
    //   () => AddModuleCubit(
    //     moduleRespository: getIt(),
    //     appCubit: getIt(),
    //     userRepository: getIt(),
    //   ),
    // )
    // ..registerFactory(
    //   () => LoginCubit(
    //     authRepository: getIt(),
    //     appCubit: getIt(),
    //   ),
    // )
    // ..registerFactory(() => RenameNodeCubit(moduleRespository: getIt()))
    // ..registerFactory(
    //     () => GetHistoryConnectionCubit(moduleRespository: getIt()))
    // ..registerFactory(
    //   () => SignupCubit(
    //     authRepository: getIt(),
    //   ),
    // )
    // ..registerFactory(
    //   () => ModuleCubit(
    //     moduleRespository: getIt(),
    //     userRepository: getIt(),
    //   ),
    // )
    // ..registerFactoryParam<ModuleMenuCubit, Module, dynamic>(
    //   (module, _) => ModuleMenuCubit(
    //     moduleRespository: getIt(),
    //     userRepository: getIt(),
    //     module: module,
    //   ),
    // );
}
