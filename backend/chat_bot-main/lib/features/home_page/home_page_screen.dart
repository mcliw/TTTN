import 'package:flutter/material.dart';
import 'package:smart_home/gen/assets.gen.dart';
import 'package:smart_home/routes.dart';
import 'package:smart_home/shared/extensions/extensions.dart';
import 'package:smart_home/shared/widgets/app_layout.dart';
import 'package:smart_home/shared/widgets/app_text.dart';
import 'package:smart_home/shared/widgets/buttons/app_button.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        child: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ReturnBox(),
          Expanded(
            child: Center(
              child: Assets.images.logo.image(
                fit: BoxFit.contain,
                color: context.colors.black,
                height: context.height / 6,
              ),
            ),
          ),
          AppText(
            textAlign: TextAlign.center,
            'Welcome to BrainBox',
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: context.colors.black,
          ),
          const SizedBox(height: 20),
          AppText(
            textAlign: TextAlign.center,
            'Start chatting with ChattyAI now.',
            fontSize: 18,
            color: context.colors.unHighlightTab,
          ),
          AppText(
            textAlign: TextAlign.center,
            '¥ou can ask me enything.',
            fontSize: 18,
            color: context.colors.unHighlightTab,
          ),
          const SizedBox(height: 40),
          AppButton(
              label: 'Get Started',
              onPressed: () {
                Navigator.pushNamed(context, RouteName.chatScreen);
              },
              radius: BorderRadius.circular(10),
              primaryColor: context.colors.black,
              padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 50)),
          const SizedBox(height: 30),
        ],
      ),
    )));
  }
}

class ReturnBox extends StatelessWidget {
  const ReturnBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(onTap: () {}, child: Assets.icons.leftChevon.svg()),
      ),
    );
  }
}
