import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/global widget/custom_appbar.dart';
import 'package:gym_cheloper/viwes/widgets/custom_button.dart';
import 'package:gym_cheloper/global widget/custom_button.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_controller/subscription_code_controller.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_screen/subscription_buy_screen.dart' show SubscriptionBuyScreen;

class SubscriptionCodeScreen extends StatelessWidget {
  final SubscriptionCodeController controller =
  Get.put(SubscriptionCodeController());

  SubscriptionCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "",
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),

              /// Title
              Text(
                "Enter Subscription Code",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),

              /// Input field
              TextField(
                controller: controller.codeController,
                decoration: InputDecoration(
                  hintText: "Enter your subscription code",
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Color(0xFF222222),
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Colors.black38,
                      width: 1.4,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 40.h),

              /// Confirm Button
              ClipRRect(
                borderRadius: BorderRadius.circular(100.r),

                child:  CustomNewButton(
                  title: "Confirm",
                  color:  Colors.black,   // button background color
                  titlecolor: Colors.white,
                  onpress: () {
                    // Navigate to Subscription Success Screen
                    Navigator.pushNamed(context, '/subscription-buy');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
