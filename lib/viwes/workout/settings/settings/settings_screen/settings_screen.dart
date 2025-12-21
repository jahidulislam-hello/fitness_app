
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/global%20widget/custom_appbar.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/utils/app_images.dart';
import 'package:gym_cheloper/viwes/widgets/custom_button.dart';
import 'package:gym_cheloper/viwes/workout/choose_language/choose_laguage_screen/choose_language_screen.dart';
import 'package:gym_cheloper/viwes/workout/settings/change_password/change_password.dart';
import 'package:gym_cheloper/viwes/workout/settings/settings/settings_controller/settings_controller.dart';






class SettingsScreen extends StatelessWidget {
  final controller = Get.put(SettingsController());

  SettingsScreen({super.key});

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              CustomAppBar(title: "Settings"  , showBackButton: true,),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    SettingTile(

                      // Left icon as SVG
                      iconWidget: SvgPicture.asset(
                        AppImages.lock,
                        width: 16,
                        height: 16,
                      ),
                      title: "Change Password",
                      // Right icon as SVG
                      trailingIcon: SvgPicture.asset(
                        AppImages.chevronRight,
                        width: 16,
                        height: 16,
                      ),

                      onTap: () {
                        Get.to (()=> ChangePasswordScreen());
                      },
                    ),

                    const SizedBox(height: 24),
                    SettingTile(
                      iconWidget: SvgPicture.asset(
                        AppImages.translate,
                        width: 16,
                        height: 16,
                      ),
                      title: "Change Language",
                      trailingIcon: SvgPicture.asset(
                        AppImages.chevronRight,
                        width: 16,
                        height: 16,
                      ),
                      onTap: () {
                        Get.to (()=> ChooseLanguageScreen());
                      },
                    ),

                    const SizedBox(height: 24),
                    SettingTile(
                      iconWidget: SvgPicture.asset(
                        AppImages.privacy,
                        width: 16,
                        height: 16,
                      ),
                      title: "Privacy policy",
                      trailingIcon: SvgPicture.asset(
                        AppImages.chevronRight,
                        width: 16,
                        height: 16,
                      ),

                      onTap: () {
                        // Get.to(() => TermsScreen());
                      },
                    ),
                    const SizedBox(height: 24),
                    SettingTile(
                      iconWidget: SvgPicture.asset(
                        AppImages.terms,
                        width: 16,
                        height: 16,
                      ),
                      title: "Terms of Services",
                      trailingIcon: SvgPicture.asset(
                        AppImages.chevronRight,
                        width: 16,
                        height: 16,
                      ),
                      onTap: () {
                        // Get.to(() => AboutUs());
                      },
                    ),
                    const SizedBox(height: 24),
                    SettingTile(
                      iconWidget: SvgPicture .asset(
                        AppImages.about,
                        width: 16,
                        height: 16,
                      ),
                      title: "About Us",
                      trailingIcon: SvgPicture.asset(
                        AppImages.chevronRight,
                        width: 16,
                        height: 16,
                      ),
                      onTap: () {
                        // Get.to(() => PaymentOptionsScreen());
                      },
                    ),
                    const SizedBox(height: 24),
                    SettingTile(
                      iconWidget: SvgPicture .asset(
                        AppImages.delete,
                        width: 16,
                        height: 16,
                      ),
                      title: "Delete Account",
                      trailingIcon: SvgPicture.asset(
                        AppImages.chevronRight,
                        width: 16,
                        height: 16,
                      ),
                      onTap: () {
                        // Get.to(() => PaymentOptionsScreen());
                      },
                    ),
                  ],
                ),
              ),

              // const Spacer(),
              //
              //
              // // Logout Button
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              //   child: CustomNewButton(
              //     title: "Logout",
              //     color: Colors.red,
              //     onpress: () {
              //       showDialog(
              //         context: context,
              //         barrierDismissible: true,
              //         builder: (_) => const LogoutPopup(),
              //       );
              //     },
              //   ),
              // )
              //

            ],
          );
        }),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final Widget? iconWidget; // changed from String iconPath
  final String title;
  final VoidCallback? onTap;
  final Widget? trailingIcon;

  const SettingTile({
    super.key,
    this.iconWidget,
    required this.title,
    this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Color(0xFFEBEBEB)),
        ),
        child: Row(
          children: [
            iconWidget ?? const SizedBox.shrink(),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailingIcon ?? const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}




class LogoutPopup extends StatelessWidget {
  const LogoutPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Ready to log out?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100), // pill shape
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Expanded(
                //   child: ElevatedButton(
                //     // onPressed: () async {
                //     //   await SharedPreferencesHelper.clearAllData();
                //     //   Get.back();
                //     //   Get.offAll(() => LoginScreen());
                //     // },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.red,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(100), // pill shape
                //       ),
                //     ),
                //     // onPressed: () {
                //     //   SharedPreferencesHelper.clearAllData();
                //     //   Get.offAll(() => SignUpScreen());
                //     // },
                //     child: const Padding(
                //       padding: EdgeInsets.symmetric(vertical: 12),
                //       child: Text(
                //         "Logout",
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}