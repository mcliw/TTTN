import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';
import 'package:smart_home/gen/assets.gen.dart';
import 'package:smart_home/shared/cubits/app_cubit/app_cubit.dart';
import 'package:smart_home/shared/widgets/app_text.dart';

import '../../routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    context.read<AppCubit>().checkAuthState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AppCubit, AppState>(
      listener: (context, state) => state.whenOrNull(
        authorized: (user) =>
            Navigator.of(context).pushReplacementNamed(RouteName.main),
        unAuthorized: () =>
            Navigator.of(context).pushReplacementNamed(RouteName.intro),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Lottie.asset(
                  Assets.images.liveChatBot,
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
            ),
          ),
          const AppText(
            'BrainBox',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    ));
  }
}
