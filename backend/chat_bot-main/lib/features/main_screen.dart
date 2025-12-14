import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/features/history_chat/history_chat_screen.dart';
import 'package:smart_home/features/home_page/home_page_screen.dart';
import 'package:smart_home/features/selection/selection_screen.dart';
import 'package:smart_home/features/setting_profile/setting_profile_screen.dart';
import 'package:smart_home/gen/assets.gen.dart' show Assets;
import 'package:smart_home/routes.dart';
import 'package:smart_home/shared/cubits/app_cubit/app_cubit.dart';
import 'package:smart_home/shared/extensions/extensions.dart';
import 'package:smart_home/shared/widgets/app_text.dart';
import 'package:smart_home/shared/widgets/bottom_navigation/custom_bottom_navigation.dart';
import 'package:smart_home/shared/widgets/custom_app_bar.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
//   final _bottomNavKey = GlobalKey<BottomNavigationState>();
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AppCubit, AppState>(
//       listener: (_, state) {
//         state.whenOrNull(
//           unAuthorized: () => Navigator.of(context).pushNamedAndRemoveUntil(
//             RouteName.login,
//             (_) => false,
//           ),
//         );
//       },
//       child: BottomNavigation(
//         key: _bottomNavKey,
//         initIndex: 1,
//         inActiveColor: context.colors.unHighlightTab,
//         activeColor: context.colors.highlightTab,
//         backgroundColor: context.colors.primaryBackground,
//         iconSize: 30,
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: context.colors.divider,
//               blurRadius: 5,
//             )
//           ],
//         ),
//         items: [
//           BottomNavigationItem(
//             icon: Assets.icons..path,
//             page: BlocProvider(
//               create: (_) => GetIt.I<HomePageCubit>(),
//               child: const HomePage(),
//             ),
//           ),
//           BottomNavigationItem(
//             icon: Assets.icons.device.path,
//             page: const ModulePage(),
//           ),
//           BottomNavigationItem(
//             icon: Assets.icons.profile.path,
//             page: const ProfilePage(),
//           ),
//         ],
//       ),
//     );
//   }
// }
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final bottomNavKey = GlobalKey<BottomNavigationState>();

  @override
  Widget build(BuildContext context) {
    return BottomNavigation(
      initIndex: 0,
      inActiveColor: context.colors.unHighlightTab,
      activeColor: context.colors.highlightTab,
      backgroundColor: context.colors.primaryBackground,
      iconSize: 30,
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: context.colors.divider,
      //       blurRadius: 5,
      //     )
      //   ],
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          )
        ],
      ),
      items: [
        BottomNavigationItem(
          icon: Assets.icons.home.path,
          page: const HomePageScreen(),
        ),
        BottomNavigationItem(
          icon: Assets.icons.selection.path,
          page: const SelectionScreen(),
        ),
        BottomNavigationItem(
          icon: Assets.icons.historiChat.path,
          page: const ChatHistoryScreen(),
        ),
        BottomNavigationItem(
          icon: Assets.icons.settingProfile.path,
          page: const SettingProfileScreen(),
        ),
      ],
    );
  }
}
