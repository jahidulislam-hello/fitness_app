import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/global widget/custom_appbar.dart';
import 'package:gym_cheloper/global widget/custom_button.dart';
import 'package:gym_cheloper/viwes/widgets/custom_button.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_controller/subscription_code_controller.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_screen/subscription_card_screen.dart';

class SubscriptionCodeScreen extends StatelessWidget {
  final SubscriptionCodeController controller =
      Get.put(SubscriptionCodeController());

  SubscriptionCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Redeem Code",
        showBackButton: true,
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      /// Title
                      Text(
                        "Enter Subscription Code",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      Text(
                        "Have a coupon code? Enter it below to redeem your subscription.",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      /// Coupon Code Input
                      Text(
                        "Coupon Code",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      TextField(
                        controller: controller.codeController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: "Enter your coupon code (e.g., KJHFR2025)",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.confirmation_number_outlined,
                            color: Colors.grey,
                          ),
                          suffixIcon: controller.isCouponValid.value
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : null,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: controller.isCouponValid.value
                                  ? Colors.green
                                  : const Color(0xFF222222),
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: controller.isCouponValid.value
                                  ? Colors.green
                                  : const Color(0xFF3971FF),
                              width: 1.4,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                        onChanged: (value) {
                          // Reset validation state when user types
                          if (controller.isCouponValid.value) {
                            controller.isCouponValid.value = false;
                            controller.errorMessage.value = '';
                            controller.successMessage.value = '';
                          }
                        },
                      ),

                      SizedBox(height: 8.h),

                      /// Error Message
                      if (controller.errorMessage.value.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red, size: 16.sp),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                controller.errorMessage.value,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),

                      /// Success Message
                      if (controller.successMessage.value.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green, size: 16.sp),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                controller.successMessage.value,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 24.h),

                      /// Validated Coupon Details
                      if (controller.isCouponValid.value &&
                          controller.validatedCoupon.value != null)
                        _buildCouponDetails(),

                      SizedBox(height: 32.h),

                      /// Validate Button
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: CustomNewButton(
                          title: controller.isValidating.value
                              ? "Validating..."
                              : controller.isCouponValid.value
                                  ? "Apply & Continue"
                                  : "Validate Code",
                          color: controller.isValidating.value
                              ? Colors.grey
                              : controller.isCouponValid.value
                                  ? Colors.green
                                  : Colors.black,
                          titlecolor: Colors.white,
                          loading: controller.isValidating.value,
                          onpress: () async {
                            if (controller.isValidating.value) return;
                            if (controller.isCouponValid.value) {
                              // Navigate to card screen with coupon applied
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChooseYourCardScreen(),
                                ),
                              );
                            } else {
                              // Validate the coupon
                              await controller.validateCoupon();
                            }
                          },
                        ),
                      ),

                      SizedBox(height: 16.h),

                      /// Skip Button
                      if (!controller.isCouponValid.value)
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChooseYourCardScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Skip - Continue without code",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 40.h),

                      /// Info Section
                      _buildInfoSection(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCouponDetails() {
    final coupon = controller.validatedCoupon.value!;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, color: Colors.green, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                "Coupon Applied!",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildDetailRow("Code", coupon.couponCode),
          _buildDetailRow("Duration", coupon.packageDuration),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                "About Coupon Codes",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildInfoItem("Coupon codes are case-insensitive"),
          _buildInfoItem("Each code can only be used once per account"),
          _buildInfoItem("Some codes may have expiration dates"),
          _buildInfoItem("Contact support if you have issues with your code"),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "  \u2022  ",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
