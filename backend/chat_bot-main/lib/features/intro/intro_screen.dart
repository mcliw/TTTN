import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/features/intro/component/intro.dart';
import 'package:smart_home/features/localization/localizations.dart';
import 'package:smart_home/gen/assets.gen.dart';
import 'package:smart_home/routes.dart';
import 'package:smart_home/shared/extensions/build_context_extension.dart';
import 'package:smart_home/shared/theme/styles.dart';

import 'package:smart_home/shared/widgets/app_layout.dart';
import 'package:smart_home/shared/widgets/app_text.dart';
import 'package:smart_home/shared/widgets/buttons/app_button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  final _intro = [
    Intro.first(),
    Intro.second(),
    Intro.third(),
    Intro.fourth(),
  ];
  int pageIndex = 0;

  void _toLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteName.login,
      (route) => false,
    );
  }

  void _toSignup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteName.register,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        child: Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemBuilder: (context, index) {
            final data = _intro[index];

            if (index == _intro.length - 1) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            data.animationPath,
                            fit: BoxFit.contain,
                            color: context.colors.black,
                            height: context.height / 6,
                          ),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: List.generate(
                      //     _intro.length,
                      //     (index) => AnimatedContainer(
                      //       duration: const Duration(milliseconds: 250),
                      //       width: 10,
                      //       height: 10,
                      //       margin: const EdgeInsets.symmetric(horizontal: 5),
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: index == pageIndex
                      //             ? context.colors.black
                      //             : context.colors.white,
                      //         border: Border.all(color: context.colors.white),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: context.colors.black.withOpacity(0.4),
                      //             blurRadius: 4,
                      //             offset: const Offset(0, 2),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      AppText(
                        textAlign: TextAlign.center,
                        data.title.tr(),
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: context.colors.black,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      AppButton(
                        label: 'Log in',
                        primaryColor: context.colors.black,
                        onPressed: _toLogin,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AppButton(
                        label: 'Sign Up',
                        primaryColor: context.colors.offlineColor,
                        onPressed: _toSignup,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      AppText('Continue with Accounts',
                          fontSize: 16, color: context.colors.offlineColor),
                      SizedBox(height: 20),
                      Container(
                        width: context.width / 2.4,
                        decoration: BoxDecoration(
                          color: context.colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Assets.icons.google.svg(
                                width: 40,
                                height: 40,
                              ),
                            ),
                            SizedBox(width: 19),
                            Assets.icons.divide.svg(
                              color: context.colors.black.withOpacity(0.4),
                            ),
                            SizedBox(width: 19),
                            IconButton(
                              onPressed: () {},
                              icon: Assets.icons.team.svg(
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer()
                      // AppText(data.description.tr(),
                      //     textAlign: TextAlign.center,
                      //     fontSize: 16,
                      //     color: context.colors.black),
                    ],
                  ),
                ),
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      data.animationPath,
                      fit: BoxFit.contain,
                      height: context.height / 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _intro.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == pageIndex
                                ? context.colors.black
                                : context.colors.white,
                            border: Border.all(color: context.colors.white),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.black.withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AppText(
                      data.title.tr(),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AppText(data.description.tr(),
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        color: context.colors.black),
                  ],
                ),
              ),
            );
          },
          itemCount: _intro.length,
          onPageChanged: (value) {
            setState(() {
              pageIndex = value;
            });
          },
        ),
        if (pageIndex != _intro.length - 1)
          Positioned(
            right: 8,
            child: SafeArea(
              child: InkWell(
                onTap: _toLogin,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: AppText(
                    'Skip',
                    fontSize: 16,
                    textDecoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          left: 145,
          right: 0,
          bottom: 25,
          child: SafeArea(
            child: Row(
              children: [
                if (pageIndex != _intro.length - 1)
                  //   Container(
                  //     alignment: Alignment.center,
                  //     height: AppSize.buttonHeight,
                  //     decoration: BoxDecoration(
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: context.colors.black.withOpacity(0.3),
                  //           blurRadius: 10,
                  //           offset: const Offset(0, 20),
                  //         ),
                  //       ],
                  //       color: context.colors.white,
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: InkWell(
                  //       onTap: _toLogin,
                  //       child: AppText(
                  //         'Start',
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //         color: context.colors.black,
                  //       ),
                  //     ),
                  //     width: 120,
                  //   )
                  // else
                  Container(
                    width: context.width / 3 * 0.85,
                    height: AppSize.buttonHeight,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 20),
                        ),
                      ],
                      color: context.colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // NÚT TRÁI
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (pageIndex > 0) {
                                _controller.previousPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.linear,
                                );
                              }
                            },
                            child: Center(
                              child: Assets.icons.left.svg(
                                width: 24,
                                height: 24,
                                color: context.colors.black,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Assets.icons.divide.svg(
                          width: 24,
                          height: 24,
                          color: context.colors.divider,
                        ),

                        const SizedBox(width: 8),

                        // NÚT PHẢI
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (pageIndex < _intro.length - 1) {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.linear,
                                );
                              }
                            },
                            child: Center(
                              child: Assets.icons.right.svg(
                                width: 24,
                                height: 24,
                                color: context.colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
