// import 'package:flutter/material.dart';
// import 'package:smart_home/gen/assets.gen.dart';
// import 'package:smart_home/shared/widgets/app_text.dart';
// import 'package:smart_home/shared/widgets/custom_app_bar.dart';

// class SettingProfileScreen extends StatelessWidget {
//   const SettingProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Profile',
//       ),
//       body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Center(
//                 child: SizedBox(
//                   width: 110,
//                   height: 110,
//                   child: Assets.images.accountOwner.image(
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               AppText(
//                 textAlign: TextAlign.center,
//                 'John Doe',
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//               AppText(
//                 textAlign: TextAlign.center,
//                 'joinDor@gmail.com',
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//               const SizedBox(height: 32),
//               BoxIconWidget(
//                 prexifixIcon: Assets.icons.settings.svg(width: 24, height: 24),
//                 title: 'Preferences',
//                 suffixIcon:
//                     Assets.icons.chevronRight.svg(width: 20, height: 20),
//               ),
//               const SizedBox(height: 16),
//               BoxIconWidget(
//                 prexifixIcon: Assets.icons.lock.svg(width: 24, height: 24),
//                 title: 'Account Security',
//                 suffixIcon:
//                     Assets.icons.chevronRight.svg(width: 20, height: 20),
//               ),
//               const SizedBox(height: 16),
//               BoxIconWidget(
//                 prexifixIcon: Assets.icons.help.svg(width: 24, height: 24),
//                 title: 'Customer Support',
//                 suffixIcon:
//                     Assets.icons.chevronRight.svg(width: 20, height: 20),
//               ),
//             ],
//           )),
//     );
//   }
// }

// class BoxIconWidget extends StatelessWidget {
//   final Widget prexifixIcon;
//   final Widget suffixIcon;
//   final String title;
//   final VoidCallback? onTap;
//   const BoxIconWidget(
//       {super.key,
//       required this.prexifixIcon,
//       required this.suffixIcon,
//       required this.title,
//       this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 prexifixIcon,
//                 const SizedBox(width: 12),
//                 AppText(
//                   textAlign: TextAlign.left,
//                   title,
//                   fontSize: 16,
//                 ),
//               ],
//             ),
//             suffixIcon,
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:smart_home/gen/assets.gen.dart';
import 'package:smart_home/shared/extensions/extensions.dart';
import 'package:smart_home/shared/widgets/app_text.dart';

class SettingProfileScreen extends StatelessWidget {
  const SettingProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const AppText(
          'Profile',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.red,
            ),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Avatar với edit button
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colors.easyColor.withOpacity(0.3),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Assets.images.accountOwner.image(
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: context.colors.easyColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.easyColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Name
              const AppText(
                'Tom Hillson',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),

              const SizedBox(height: 6),

              // Email
              AppText(
                'tomhillson@gmail.com',
                fontSize: 14,
                color: Colors.grey.shade600,
              ),

              const SizedBox(height: 40),

              // Menu Items
              _buildMenuItem(
                context,
                icon: Icons.settings_outlined,
                title: 'Preferences',
                onTap: () {
                  // Navigate to preferences
                },
              ),

              const SizedBox(height: 12),

              _buildMenuItem(
                context,
                icon: Icons.lock_outline_rounded,
                title: 'Account Security',
                onTap: () {
                  // Navigate to security
                },
              ),

              const SizedBox(height: 12),

              _buildMenuItem(
                context,
                icon: Icons.help_outline_rounded,
                title: 'Customer Support',
                onTap: () {
                  // Navigate to support
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    bool showArrow = true,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      (iconColor ?? context.colors.easyColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? context.colors.easyColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppText(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black87,
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.red),
              SizedBox(width: 12),
              Text('Đăng xuất'),
            ],
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement logout logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
