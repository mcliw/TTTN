import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_home/app_config.dart';
import 'package:smart_home/shared/cubits/app_cubit/app_cubit.dart';


import 'cubit_modules.dart';
import 'local_modules.dart';
import 'remote_modules.dart';
import 'repository_modules.dart';

Future<void> setupDI() async {
  final getIt = GetIt.I;
  getIt.registerLazySingleton(() => AppConfig());
  await registerLocalModules(getIt);
  await registerRemoteModules(getIt);
  await registerRepositoryModules(getIt);
  await registerCubitModules(getIt);
}

dynamic get globalProviders => [
      BlocProvider(create: (_) => GetIt.I<AppCubit>()),
      // BlocProvider(create: (_) => GetIt.I<SocketCubit>()),
    ]; // Define all global provider
