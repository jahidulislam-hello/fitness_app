import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BuyPackageController extends GetxController {
  // Carousel current index
  RxInt currentPage = 0.obs;

  // Package selection: 'monthly' or 'quarterly'
  RxString selectedPackage = 'monthly'.obs;

  // Loading state for the "Start 5 Day Free Trial" button
  RxBool isLoading = false.obs;

  // Page controller for carousel
  final PageController pageController = PageController();

  // On carousel page change
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  // Select package
  void selectPackage(String packageType) {
    selectedPackage.value = packageType;
  }

  // Simulate pressing the trial button
  Future<void> startFreeTrial(BuildContext context) async {
    if (isLoading.value) return;
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2)); // simulate loading

    isLoading.value = false;

    // You can navigate here if needed, for example:
    // context.push(RouteNames.subscriptionbuyScreen);
    Get.snackbar(
      "Trial Started",
      "You’ve successfully started your 5-day free trial!",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
