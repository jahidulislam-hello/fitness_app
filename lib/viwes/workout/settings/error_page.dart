import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart'; // <-- missing import
import 'package:gym_cheloper/global%20widget/custom_appbar.dart';
import 'package:gym_cheloper/utils/app_colors.dart';
import 'package:gym_cheloper/utils/app_images.dart';
import 'package:gym_cheloper/viwes/widgets/custom_button.dart';


class ErrorPageScreen extends StatelessWidget {
  const ErrorPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "",
        showBackButton: false,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            /// Top Illustration
            SizedBox(
              height: 325.h,
              child: Center(
                child: SvgPicture.asset(
                  AppImages.error,

                  height: 345.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            /// Support Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.transparent,
              ),
              child: Column(
                children: [

                  SizedBox(height: 16.h),



                  /// Button inside contact box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: CustomNewButton(
                      title: "Re-Load",
                      titlecolor: Colors.white,
                      color: AppColors.primaryColor,
                      height: 48.h,
                       onpress: () {  },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}