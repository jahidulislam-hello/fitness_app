import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/global widget/custom_appbar.dart';
import 'package:gym_cheloper/global widget/custom_button.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/viwes/widgets/custom_button.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_controller/subscription_buy_controller.dart';

class SubscriptionBuyScreen extends StatelessWidget {
  final SubscriptionBuyController controller =
  Get.put(SubscriptionBuyController());

  SubscriptionBuyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Subscription Buy",
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Package Name"),
              _buildInput(controller.packageNameController,
                  hint: "Enter your package name"),
              SizedBox(height: 20.h),

              _buildLabel("Card Holder Name"),
              _buildInput(controller.cardHolderController,
                  hint: "Enter your card holder name"),
              SizedBox(height: 20.h),

              _buildLabel("Card Number"),
              _buildInput(controller.cardNumberController,
                  hint: "Enter your card number", keyboardType: TextInputType.number),
              SizedBox(height: 20.h),

              _buildLabel("Expire Date"),
              _buildInput(
                controller.expireDateController,
                hint: "MM/YY",
                readOnly: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.black54),
                  onPressed: () => controller.pickExpireDate(context),
                ),
              ),
              SizedBox(height: 20.h),

              _buildLabel("CVV"),
              _buildInput(controller.cvvController,
                  hint: "Enter your CVV", keyboardType: TextInputType.number),
              SizedBox(height: 40.h),

              ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: CustomNewButton(
                  title: "Confirm",
                  color: const Color(0xff3971FF),   // button background color
                  titlecolor: Colors.white,         // text color
                  onpress: () {
                    if (controller.packageNameController.text.trim().isEmpty ||
                        controller.cardHolderController.text.trim().isEmpty ||
                        controller.cardNumberController.text.trim().isEmpty ||
                        controller.expireDateController.text.trim().isEmpty ||
                        controller.cvvController.text.trim().isEmpty) {
                      context.push(RouteNames.choosecardScreen);
                      return;
                    }

                    Get.snackbar(
                      "Success",
                      "Subscription purchase completed",
                      backgroundColor: const Color(0xffF93533),
                      colorText: Colors.white,
                    );
                  },
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  /// 📍 Helper Widgets
  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
  );

  Widget _buildInput(
      TextEditingController controller, {
        required String hint,
        bool readOnly = false,
        Widget? suffixIcon,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
        contentPadding:
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r),
          borderSide: const BorderSide(
            color: Color(0xFF222222),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Color(0xffF93533),
            width: 1.4,
          ),
        ),
      ),
      style: TextStyle(fontSize: 14.sp, color: Colors.black),
    );
  }
}
