import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/services/terms_privacy_about_service.dart';

class TermsPrivacyAboutController extends GetxController {
  final TermsPrivacyAboutService _apiService = TermsPrivacyAboutService();

  // Loading state
  var isLoading = false.obs;

  // Content data
  var termsTitle = ''.obs;
  var termsContent = ''.obs;

  var privacyTitle = ''.obs;
  var privacyContent = ''.obs;

  var aboutTitle = ''.obs;
  var aboutContent = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadContent();
  }

  /// Load Terms, Privacy, and About Us content from API
  Future<void> loadContent() async {
    try {
      isLoading.value = true;

      final response = await _apiService.getContent();

      print('🔍 API Response Success: ${response['success']}');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        // Parse Terms of Service
        if (data['termsOfService'] != null) {
          termsTitle.value = data['termsOfService']['title'] ?? 'Terms of Service';
          termsContent.value = data['termsOfService']['content'] ?? '';
          print('✅ Terms loaded: ${termsTitle.value}');
        }

        // Parse Privacy Policy
        if (data['privacyPolicy'] != null) {
          privacyTitle.value = data['privacyPolicy']['title'] ?? 'Privacy Policy';
          privacyContent.value = data['privacyPolicy']['content'] ?? '';
          print('✅ Privacy loaded: ${privacyTitle.value}');
        }

        // Parse About Us
        if (data['aboutUs'] != null) {
          aboutTitle.value = data['aboutUs']['title'] ?? 'About Us';
          aboutContent.value = data['aboutUs']['content'] ?? '';
          print('✅ About Us loaded: ${aboutTitle.value}');
        }
      } else {
        print('⚠️ No data or unsuccessful response');
        _setDefaultContent();
      }
    } catch (e) {
      print('❌ Error in loadContent: $e');
      Get.snackbar(
        'Error',
        'Failed to load content. Showing default content.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: Duration(seconds: 2),
      );
      _setDefaultContent();
    } finally {
      isLoading.value = false;
    }
  }

  /// Set default content when API fails
  void _setDefaultContent() {
    termsTitle.value = 'Our Terms of Services';
    termsContent.value = 'Loading...';

    privacyTitle.value = 'Our Policy';
    privacyContent.value = 'Loading...';

    aboutTitle.value = 'Our Introduction';
    aboutContent.value = 'Loading...';
  }

  /// Refresh content
  Future<void> refreshContent() async {
    await loadContent();
  }
}
