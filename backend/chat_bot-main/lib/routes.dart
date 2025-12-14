import 'package:flutter/material.dart';
import 'package:smart_home/features/common/splash_screen.dart';
import 'package:smart_home/features/history_chat/history_chat_screen.dart';
import 'package:smart_home/features/home_page/chat_message_screen.dart';
import 'package:smart_home/features/home_page/home_page_screen.dart';
import 'package:smart_home/features/intro/intro_screen.dart';
import 'package:smart_home/features/login/login_screen.dart';
import 'package:smart_home/features/main_screen.dart';
import 'package:smart_home/features/register/register.dart';
import 'package:smart_home/features/selection/selection_screen.dart';
import 'package:smart_home/features/setting_profile/setting_profile_screen.dart';

class RouteName {
  static const String splash = '/';
  static const String main = '/main';
  static const String register = '/register';
  static const String login = '/login';
  static const String intro = '/intro';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String selection = '/selection';
  static const String historyChat = '/historyChat';
  static const String chatScreen = '/chatScreen';
}

RouteFactory onGenerateRoutes() {
  return (RouteSettings settings) {
    // if (settings.name == RouteName.splash) {
    //   return MaterialPageRoute(
    //     settings: settings,
    //     builder: (context) => const SplashScreen(),
    //   );
    // }

    //   if (settings.name == RouteName.intro) {
    //   return MaterialPageRoute(
    //     settings: settings,
    //     builder: (context) =>
    //         const IntroScreen(), 
    //   );
    // }
    if (settings.name == RouteName.profile) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) =>
            const SettingProfileScreen(), 
      );
    }
    if(settings.name== RouteName.chatScreen){
      return MaterialPageRoute(settings: settings,builder: (context)=>const ChatScreen());
    }
    if (settings.name == RouteName.home) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) =>
            const HomePageScreen(), 
      );
    }
    if (settings.name == RouteName.historyChat) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) =>
            const ChatHistoryScreen(), 
      );
    }
    if (settings.name == RouteName.selection) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) =>
            const SelectionScreen(), 
      );
    }

    if (settings.name == RouteName.main) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) =>
            const MainScreen(), 
      );
    }

    if(settings.name == RouteName.register){
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const RegisterScreen(),
      );
    }
    if(settings.name == RouteName.login) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const LoginScreen(),
      );
    }

  };
}


