import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/global widget/custom_appbar.dart';
import 'package:gym_cheloper/viwes/widgets/custom_button.dart';
import 'package:gym_cheloper/utils/app_images.dart';
import 'package:gym_cheloper/viwes/workout/choose_language/choose_language_controller/choose_language_controller.dart';


class ChooseLanguageScreen extends StatelessWidget {
  final controller = Get.put(ChooseLanguageController());

  ChooseLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Language",
        showBackButton: true,
      ),
      body: SafeArea(
        child: Obx(
              () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                Text(
                  "Change your Language",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),

                // English Option
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.us,
                        height: 24.h,
                        width: 42.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "English",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                      const Spacer(),
                      Radio<String>(
                        value: 'English',
                        groupValue: controller.selectLanguage.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeLanguage(value);
                          }
                        },
                        activeColor: Colors.red,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Spanish Option
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.spain,
                        height: 24.h,
                        width: 42.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Spanish",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                      const Spacer(),
                      Radio<String>(
                        value: 'Spanish',
                        groupValue: controller.selectLanguage.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeLanguage(value);
                          }
                        },
                        activeColor: Colors.red,
                      ),
                    ],
                  ),
                ),

                const Spacer(),


                ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: CustomNewButton(
                    title: "Select Language",
                    color: Colors.red,
                    titlecolor: Colors.white,
                    onpress: () {
                      Get.snackbar(
                        "Language Selected",
                        "You selected ${controller.selectLanguage.value}",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
