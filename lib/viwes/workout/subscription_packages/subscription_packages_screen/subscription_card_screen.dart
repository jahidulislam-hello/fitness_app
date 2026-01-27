import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/global widget/custom_appbar.dart';
import 'package:gym_cheloper/global widget/custom_button.dart';
import 'package:gym_cheloper/models/subscription_model.dart';
import 'package:gym_cheloper/utils/app_images.dart';
import 'package:gym_cheloper/viwes/widgets/custom_button.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_controller/subscription_card_controller.dart';

class ChooseYourCardScreen extends StatelessWidget {
  final controller = Get.put(ChooseYourCardController());

  ChooseYourCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Choose Your Card",
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
                      Text(
                        "My Card",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      /// Card Design
                      _buildCardDesign(),

                      SizedBox(height: 24.h),

                      /// Subscription Packages Section
                      Text(
                        "Select Subscription Package",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      /// Package List
                      _buildPackageList(),

                      SizedBox(height: 24.h),

                      /// Selected Package Details
                      if (controller.selectedPackage.value != null)
                        _buildSelectedPackageDetails(),

                      SizedBox(height: 24.h),

                      /// Pay Now Button
                      _buildPayNowButton(context),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCardDesign() {
    return Container(
      width: double.infinity,
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFFF53E3E), Color(0xFF2244E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Bank Name + Refresh Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.bankName.value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              const Icon(Icons.refresh, color: Colors.white),
            ],
          ),
          const Spacer(),
          Text(
            controller.cardNumber.value.replaceAllMapped(
                RegExp(r".{4}"), (match) => "${match.group(0)} "),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Expired Date",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    controller.expiryDate.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    AppImages.masterCard,
                    height: 24.h,
                    width: 42.w,
                  ),
                  SizedBox(width: 4.w),
                  if (controller.cardType.value == "Visa")
                    Image.asset(
                      "assets/images/visa.png",
                      height: 24.h,
                      width: 24.w,
                    ),
                  if (controller.cardType.value == "American Express")
                    Image.asset(
                      "assets/images/amex.png",
                      height: 24.h,
                      width: 24.w,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackageList() {
    return Obx(() => Column(
          children: List.generate(
            controller.subscriptionPackages.length,
            (index) {
              final package = controller.subscriptionPackages[index];
              final isSelected = controller.selectedPackageIndex.value == index;

              return GestureDetector(
                onTap: () => controller.selectPackage(index),
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? const Color(0xFF3971FF) : Colors.grey,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    color: isSelected
                        ? const Color(0xFF3971FF).withOpacity(0.05)
                        : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: index,
                        groupValue: controller.selectedPackageIndex.value,
                        onChanged: (value) {
                          if (value != null) controller.selectPackage(value);
                        },
                        activeColor: const Color(0xFF3971FF),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  package.packageName,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                if (package.packageDuration.contains('3'))
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      "Save 25%",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              package.packageDuration,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "US\$ ${controller.getPricePerMonth(package)}/mo",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF3971FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget _buildSelectedPackageDetails() {
    return Obx(() {
      final package = controller.selectedPackage.value;
      if (package == null) return const SizedBox();

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Package Features",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            ...package.packageFeatures.map(
              (feature) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "US\$ ${package.packageAmount}",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3971FF),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPayNowButton(BuildContext context) {
    return Obx(() => ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: CustomNewButton(
            title: controller.isPaymentProcessing.value
                ? "Processing..."
                : "Pay now",
            color: controller.isPaymentProcessing.value
                ? Colors.grey
                : const Color(0xff3971FF),
            titlecolor: Colors.white,
            loading: controller.isPaymentProcessing.value,
            onpress: () async {
              if (controller.isPaymentProcessing.value) return;
              final result = await controller.processPayment(context);
              if (result.isSuccess) {
                // Navigate to success screen or home
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              }
            },
          ),
        ));
  }
}
