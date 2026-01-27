import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/global widget/custom_appbar.dart';
import 'package:gym_cheloper/models/subscription_model.dart';
import 'package:gym_cheloper/viwes/widgets/custom_button.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_controller/subscription_code_controller.dart';

class AddCouponScreen extends StatefulWidget {
  final CouponModel? existingCoupon; // Pass existing coupon for update

  const AddCouponScreen({super.key, this.existingCoupon});

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final SubscriptionCodeController controller =
      Get.put(SubscriptionCodeController());

  final TextEditingController couponCodeController = TextEditingController();
  final TextEditingController packageDurationController =
      TextEditingController();

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingCoupon != null) {
      isUpdate = true;
      couponCodeController.text = widget.existingCoupon!.couponCode;
      packageDurationController.text = widget.existingCoupon!.packageDuration;
      // Find and select the subscription
      _selectExistingSubscription();
    }
  }

  void _selectExistingSubscription() {
    if (widget.existingCoupon != null) {
      final existingSub = controller.subscriptionPackages.firstWhereOrNull(
        (sub) => sub.id == widget.existingCoupon!.subscriptions,
      );
      if (existingSub != null) {
        controller.selectSubscription(existingSub);
      }
    }
  }

  @override
  void dispose() {
    couponCodeController.dispose();
    packageDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: isUpdate ? "Update Coupon" : "Add Coupon",
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
                      /// Coupon Code
                      _buildLabel("Coupon Code"),
                      _buildTextField(
                        controller: couponCodeController,
                        hint: "Enter coupon code (e.g., KJHFR2025)",
                        textCapitalization: TextCapitalization.characters,
                      ),
                      SizedBox(height: 20.h),

                      /// Package Duration
                      _buildLabel("Package Duration"),
                      _buildTextField(
                        controller: packageDurationController,
                        hint: "Enter duration (e.g., 1 month)",
                      ),
                      SizedBox(height: 20.h),

                      /// Select Subscription Package
                      _buildLabel("Select Subscription Package"),
                      SizedBox(height: 8.h),
                      _buildSubscriptionDropdown(),
                      SizedBox(height: 24.h),

                      /// Error Message
                      if (controller.errorMessage.value.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red, size: 18.sp),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  controller.errorMessage.value,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      /// Success Message
                      if (controller.successMessage.value.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 18.sp),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  controller.successMessage.value,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 32.h),

                      /// Submit Button
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: CustomNewButton(
                          title: controller.isLoading.value
                              ? "Submitting..."
                              : isUpdate
                                  ? "Update Coupon"
                                  : "Add Coupon",
                          color: controller.isLoading.value
                              ? Colors.grey
                              : const Color(0xff3971FF),
                          titlecolor: Colors.white,
                          loading: controller.isLoading.value,
                          onpress: () {
                            if (controller.isLoading.value) return;
                            _submitCoupon();
                          },
                        ),
                      ),

                      SizedBox(height: 16.h),

                      /// Clear Button
                      Center(
                        child: TextButton(
                          onPressed: () {
                            couponCodeController.clear();
                            packageDurationController.clear();
                            controller.clearForm();
                          },
                          child: Text(
                            "Clear Form",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      /// API Info Section
                      _buildApiInfoSection(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
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
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF222222), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF3971FF), width: 1.4),
        ),
      ),
      style: TextStyle(fontSize: 14.sp, color: Colors.black),
    );
  }

  Widget _buildSubscriptionDropdown() {
    return Obx(() {
      final packages = controller.subscriptionPackages;
      final selected = controller.selectedSubscription.value;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF222222), width: 1.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<SubscriptionPackageModel>(
            isExpanded: true,
            value: selected,
            hint: Text(
              "Select a subscription package",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            items: packages.map((package) {
              return DropdownMenuItem<SubscriptionPackageModel>(
                value: package,
                child: Text(
                  "${package.packageName} - \$${package.packageAmount} (${package.packageDuration})",
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectSubscription(value);
              }
            },
          ),
        ),
      );
    });
  }

  Future<void> _submitCoupon() async {
    // Validate inputs
    if (couponCodeController.text.trim().isEmpty) {
      controller.errorMessage.value = 'Please enter a coupon code';
      return;
    }
    if (packageDurationController.text.trim().isEmpty) {
      controller.errorMessage.value = 'Please enter package duration';
      return;
    }
    if (controller.selectedSubscription.value == null) {
      controller.errorMessage.value = 'Please select a subscription package';
      return;
    }

    final success = await controller.addCoupon(
      couponCode: couponCodeController.text.trim(),
      packageDuration: packageDurationController.text.trim(),
      subscriptionId: controller.selectedSubscription.value!.id ?? '',
      couponId: isUpdate ? widget.existingCoupon?.id : null,
    );

    if (success) {
      // Show success and optionally navigate back
      Get.snackbar(
        'Success',
        isUpdate ? 'Coupon updated successfully!' : 'Coupon added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildApiInfoSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, color: Colors.blue, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                "API Reference",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            "POST /subscription/add-coupon",
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'monospace',
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '''{
  "couponCode": "${couponCodeController.text.isEmpty ? "KJHFR2025" : couponCodeController.text}",
  "packageDuration": "${packageDurationController.text.isEmpty ? "1 month" : packageDurationController.text}",
  "subscriptions": "${controller.selectedSubscription.value?.id ?? "subscription_id"}",
  "_id": "${isUpdate ? widget.existingCoupon?.id ?? "coupon_id" : "// Remove for new coupon"}"
}''',
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'monospace',
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
