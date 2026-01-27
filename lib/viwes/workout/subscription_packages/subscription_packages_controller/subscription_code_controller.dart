import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/models/subscription_model.dart';
import 'package:gym_cheloper/services/subscription_service.dart';

class SubscriptionCodeController extends GetxController {
  RxString code = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isValidating = false.obs;
  RxBool isCouponValid = false.obs;
  RxString errorMessage = ''.obs;
  RxString successMessage = ''.obs;

  // Coupon data
  Rx<CouponModel?> validatedCoupon = Rx<CouponModel?>(null);

  // Subscription packages for coupon
  RxList<SubscriptionPackageModel> subscriptionPackages =
      <SubscriptionPackageModel>[].obs;
  Rx<SubscriptionPackageModel?> selectedSubscription =
      Rx<SubscriptionPackageModel?>(null);

  late TextEditingController codeController;
  late TextEditingController packageDurationController;

  @override
  void onInit() {
    super.onInit();
    codeController = TextEditingController();
    packageDurationController = TextEditingController();
    fetchSubscriptionPackages();
  }

  @override
  void onClose() {
    codeController.dispose();
    packageDurationController.dispose();
    super.onClose();
  }

  /// Fetch subscription packages for dropdown
  Future<void> fetchSubscriptionPackages() async {
    isLoading.value = true;
    try {
      final response = await SubscriptionService.getSubscriptions();
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body['data'];
        if (data is List) {
          subscriptionPackages.value = data
              .map((item) => SubscriptionPackageModel.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching subscription packages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Validate coupon code
  Future<bool> validateCoupon() async {
    if (codeController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter a coupon code';
      return false;
    }

    isValidating.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      final response =
          await SubscriptionService.validateCoupon(codeController.text.trim());

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body['data'];
        if (data != null) {
          validatedCoupon.value = CouponModel.fromJson(data);
          isCouponValid.value = true;
          successMessage.value = 'Coupon applied successfully!';
          return true;
        }
      }

      errorMessage.value = response.body?['message'] ?? 'Invalid coupon code';
      isCouponValid.value = false;
      return false;
    } catch (e) {
      debugPrint('Error validating coupon: $e');
      errorMessage.value = 'Failed to validate coupon. Please try again.';
      isCouponValid.value = false;
      return false;
    } finally {
      isValidating.value = false;
    }
  }

  /// Add new coupon (for admin/testing)
  Future<bool> addCoupon({
    required String couponCode,
    required String packageDuration,
    required String subscriptionId,
    String? couponId,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      final coupon = CouponModel(
        id: couponId,
        couponCode: couponCode,
        packageDuration: packageDuration,
        subscriptions: subscriptionId,
      );

      final response = await SubscriptionService.addCoupon(coupon);

      if (response.statusCode == 200) {
        successMessage.value = couponId != null
            ? 'Coupon updated successfully!'
            : 'Coupon added successfully!';
        return true;
      }

      errorMessage.value = response.body?['message'] ?? 'Failed to add coupon';
      return false;
    } catch (e) {
      debugPrint('Error adding coupon: $e');
      errorMessage.value = 'Failed to add coupon. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Select subscription for coupon
  void selectSubscription(SubscriptionPackageModel subscription) {
    selectedSubscription.value = subscription;
  }

  /// Clear form
  void clearForm() {
    codeController.clear();
    packageDurationController.clear();
    code.value = '';
    errorMessage.value = '';
    successMessage.value = '';
    isCouponValid.value = false;
    validatedCoupon.value = null;
    selectedSubscription.value = null;
  }
}
