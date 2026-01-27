import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/models/subscription_model.dart';
import 'package:gym_cheloper/services/subscription_service.dart';
import 'package:gym_cheloper/viwes/workout/stripe_payment/stripe/stripe_config.dart';
import 'package:gym_cheloper/viwes/workout/stripe_payment/stripe/stripe_helper.dart';
import 'package:gym_cheloper/viwes/workout/stripe_payment/stripe/payment_result.dart';

class ChooseYourCardController extends GetxController {
  RxString cardNumber = ''.obs;
  RxString cardType = ''.obs;
  RxString bankName = ''.obs;
  RxString expiryDate = ''.obs;

  // Subscription packages
  RxList<SubscriptionPackageModel> subscriptionPackages =
      <SubscriptionPackageModel>[].obs;
  Rx<SubscriptionPackageModel?> selectedPackage =
      Rx<SubscriptionPackageModel?>(null);
  RxInt selectedPackageIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isPaymentProcessing = false.obs;

  // Stripe payment helper
  late StripePaymentHelper _stripeHelper;

  @override
  void onInit() {
    super.onInit();
    // Example default data
    cardNumber.value = "8763273698730329";
    expiryDate.value = "10/28";
    detectCardType(cardNumber.value);

    // Initialize Stripe helper
    _initStripeHelper();

    // Fetch subscription packages
    fetchSubscriptionPackages();
  }

  void _initStripeHelper() {
    const stripeConfig = StripeConfig(
      secretKey:
          'sk_test_your_stripe_secret_key', // Replace with your actual Stripe secret key
      merchantDisplayName: 'Scorpion Fitness',
    );

    _stripeHelper = StripePaymentHelper(
      config: stripeConfig,
      onPaymentSuccess: (result) {
        debugPrint('Payment successful: ${result.message}');
      },
      onPaymentFailure: (result) {
        debugPrint('Payment failed: ${result.message}');
      },
      onLog: (message) {
        debugPrint(message);
      },
    );
  }

  /// Detect card type based on number pattern
  void detectCardType(String number) {
    if (number.isEmpty) {
      cardType.value = "";
      bankName.value = "";
      return;
    }

    if (number.startsWith('4')) {
      cardType.value = "Visa";
      bankName.value = "VBank";
    } else if (number.startsWith('5')) {
      cardType.value = "MasterCard";
      bankName.value = "AYCBank";
    } else if (number.startsWith('3')) {
      cardType.value = "American Express";
      bankName.value = "AmexBank";
    } else if (number.startsWith('6')) {
      cardType.value = "Discover";
      bankName.value = "DiscoverBank";
    } else {
      cardType.value = "Debit Card";
      bankName.value = "My Bank";
    }
  }

  /// Fetch subscription packages from API
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
          if (subscriptionPackages.isNotEmpty) {
            selectedPackage.value = subscriptionPackages.first;
            selectedPackageIndex.value = 0;
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching subscription packages: $e');
      // Load default packages if API fails
      _loadDefaultPackages();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDefaultPackages() {
    subscriptionPackages.value = [
      SubscriptionPackageModel(
        id: '1',
        packageName: 'Monthly',
        packageAmount: '12.99',
        packageDuration: '1 month',
        packageFeatures: [
          'Access to all workouts',
          'Custom meal plans',
          'Progress tracking',
        ],
      ),
      SubscriptionPackageModel(
        id: '2',
        packageName: '3 Month',
        packageAmount: '29.23',
        packageDuration: '3 months',
        packageFeatures: [
          'Access to all workouts',
          'Custom meal plans',
          'Progress tracking',
          'Priority support',
          'Save 25%',
        ],
      ),
    ];
    if (subscriptionPackages.isNotEmpty) {
      selectedPackage.value = subscriptionPackages.first;
      selectedPackageIndex.value = 0;
    }
  }

  /// Select a subscription package
  void selectPackage(int index) {
    if (index >= 0 && index < subscriptionPackages.length) {
      selectedPackageIndex.value = index;
      selectedPackage.value = subscriptionPackages[index];
    }
  }

  /// Process payment with Stripe
  Future<PaymentResult> processPayment(BuildContext context) async {
    if (selectedPackage.value == null) {
      Get.snackbar(
        'Error',
        'Please select a subscription package',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return PaymentResult.failure(message: 'No package selected');
    }

    isPaymentProcessing.value = true;

    try {
      final amount = double.tryParse(selectedPackage.value!.packageAmount) ?? 0;

      final result = await _stripeHelper.processPayment(
        context: context,
        amount: amount,
        currency: 'USD',
        description:
            'Subscription: ${selectedPackage.value!.packageName} - ${selectedPackage.value!.packageDuration}',
        metadata: {
          'package_id': selectedPackage.value!.id ?? '',
          'package_name': selectedPackage.value!.packageName,
          'package_duration': selectedPackage.value!.packageDuration,
        },
      );

      if (result.isSuccess) {
        // Save subscription to backend
        await _saveSubscriptionToBackend();

        Get.snackbar(
          'Success',
          'Payment completed successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      return result;
    } catch (e) {
      debugPrint('Payment error: $e');
      Get.snackbar(
        'Error',
        'Payment failed: ${e.toString()}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return PaymentResult.failure(message: e.toString());
    } finally {
      isPaymentProcessing.value = false;
    }
  }

  /// Save subscription to backend after successful payment
  Future<void> _saveSubscriptionToBackend() async {
    if (selectedPackage.value == null) return;

    try {
      final response =
          await SubscriptionService.addSubscription(selectedPackage.value!);
      if (response.statusCode == 200) {
        debugPrint('Subscription saved successfully');
      } else {
        debugPrint('Failed to save subscription: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error saving subscription: $e');
    }
  }

  /// Get price per month for display
  String getPricePerMonth(SubscriptionPackageModel package) {
    final amount = double.tryParse(package.packageAmount) ?? 0;
    if (package.packageDuration.contains('3')) {
      return (amount / 3).toStringAsFixed(2);
    }
    return amount.toStringAsFixed(2);
  }
}
