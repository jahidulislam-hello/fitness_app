import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/utils/app_colors.dart';
import 'package:gym_cheloper/utils/app_images.dart';
import 'package:gym_cheloper/viwes/workout/settings/edit_profile/edit_profile_screen/edit_profile_screen.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_screen/Profile_subscription_packages_screen.dart';
import '../settings_controller/settings_profile_controller.dart';



class SettingsProfileScreen extends StatelessWidget {
  final controller = Get.put(SettingsProfileController());

  SettingsProfileScreen({super.key});

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
          return SingleChildScrollView( // Wrap the column with SingleChildScrollView for scrolling
            child: Column(
              children: [
                CircleAvatar(
                  radius:50.r,
                  backgroundImage: controller.profileImage.value.isNotEmpty
                      ? NetworkImage(controller.profileImage.value)
                      : null,
                  child: controller.profileImage.value.isEmpty
                      ? Text(
                    _getInitials("${controller.firstName.value} ${controller.lastName.value}"),
                    style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                  )
                      : null,
                ),

                SizedBox(height: 20.h),

                Text(
                  "${controller.firstName.value} ${controller.lastName.value}",
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.Profile,
                          width: 24,
                          height: 24,
                        ),
                        title: "Profile Information",
                        trailingIcon: SvgPicture.asset(
                          AppImages.chevronRight,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          context.pushNamed(RouteNames.profileInfoScreen);
                        },
                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.Notification,
                          width: 24,
                          height: 24,
                        ),
                        title: "Notifications",
                        trailingIcon: SvgPicture.asset(
                          AppImages.chevronRight,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          // Get.to(() => AdminSupportScreen());
                        },
                      ),
                      const SizedBox(height: 24),
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: controller.toggleMeasurementDropdown,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppImages.Measure, width: 24, height: 24),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        "Measurements System",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.iconColor,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          controller.measurementSystem.value,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.arrow_back_ios, color: Colors.red, size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ✅ Show dropdown only when toggled
                            if (controller.isMeasurementDropdownVisible.value)
                              Container(
                                margin: const EdgeInsets.only(left: 56, right: 16, bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.red, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: const Text("Metric", style: TextStyle(color: Colors.red)),
                                      onTap: () => controller.changeMeasurementSystem("Metric"),
                                    ),
                                    const Divider(color: Colors.red, height: 1),
                                    ListTile(
                                      title:
                                      const Text("Imperial", style: TextStyle(color: Colors.red)),
                                      onTap: () => controller.changeMeasurementSystem("Imperial"),
                                    ),
                                  ],
                                ),
                              ),

                            const Divider(color: Colors.red, height: 1),
                          ],
                        );
                      }),


                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.Subcription,
                          width: 24,
                          height: 24,
                        ),
                        title: "Subscription",
                        trailingIcon: SvgPicture.asset(
                          AppImages.chevronRight,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          // Get.to(() => SubscriptionPackagesScreen());
                          // context.pushNamed(RouteNames.buypackScreen);
                        },
                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.Feed,
                          width: 24,
                          height: 24,
                        ),
                        title: "Feedback",
                        trailingIcon: SvgPicture.asset(
                          AppImages.chevronRight,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          // Get.to(() => AboutUs());
                        },
                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.Settings,
                          width: 24,
                          height: 24,
                        ),
                        title: "Settings",
                        trailingIcon: SvgPicture.asset(
                          AppImages.chevronRight,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          context.pushNamed(RouteNames.settings);
                        },
                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.Logout,
                          width: 24,
                          height: 24,
                        ),
                        title: "Log Out",
                        trailingIcon: SvgPicture.asset(
                          AppImages.chevronRight,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) => const LogoutPopup(),
                          );
                        }, showDivider: false,
                      ),
                      const SizedBox(height: 24),

                    ],
                  ),
                ),
                const SizedBox(height: 24),


                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                //   child: CustomButton(
                //     text: "Delete Account",
                //     backgroundColor: Colors.red,
                //     onPressed: () {
                //       showDialog(
                //         context: context,
                //         barrierDismissible: true,
                //         builder: (_) => const DeleteAccountPopUp(),
                //       );
                //     },
                //   ),
                // ),
                const SizedBox(height: 50), // Optional: Adding some spacing at the bottom
              ],
            ),
          );
        }),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final Widget? iconWidget;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailingIcon;
  final bool showDivider;

  const SettingTile({
    super.key,
    this.iconWidget,
    required this.title,
    this.onTap,
    this.trailingIcon,
    this.showDivider = true, // default: true
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      color: AppColors.iconColor,
                    ),
                  ),
                ),
                trailingIcon ?? const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            color: Colors.red, // your red color
            height: 1,
            thickness: 1,
          ),
      ],
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
              "Are you sure you want to ?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Logout",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                Expanded(
                  child: ElevatedButton(
                    // onPressed: () async {
                    //   await SharedPreferencesHelper.clearAllData();
                    //   Get.back();
                    //   Get.offAll(() => LoginScreen());
                    // },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100), // pill shape
                      ),
                    ),
                    onPressed: () {  },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class DeleteAccountPopUp extends StatelessWidget {
  const DeleteAccountPopUp({super.key});

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
              "Are you sure want to delete your Account?",
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
                Expanded(
                  child: ElevatedButton(
                    // onPressed: () async {
                    //   await SharedPreferencesHelper.clearAllData();
                    //   Get.back();
                    //   Get.offAll(() => LoginScreen());
                    // },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100), // pill shape
                      ),
                    ),
                    onPressed: () {  },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Yes, Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}