import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:gym_cheloper/helpers/prefs_helper.dart';
import 'package:gym_cheloper/helpers/toast_message_helper.dart';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:gym_cheloper/utils/app_constant.dart';

class SettingsProfileController extends GetxController {
  // Reactive states
  RxBool isLoading = false.obs;
  RxBool isMeasurementDropdownVisible = false.obs;

  // User Data
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString profileImage = "".obs;
  RxString measurementSystem = "Metric".obs;

  // Toggle measurement dropdown
  void toggleMeasurementDropdown() {
    isMeasurementDropdownVisible.value =
    !isMeasurementDropdownVisible.value;
  }

  // Change measurement system
  void changeMeasurementSystem(String system) async {
    measurementSystem.value = system;
    isMeasurementDropdownVisible(false);

    await PrefsHelper.setString("measurement_system", system);
    ToastMessageHelper.successMessageShowToster("Updated to $system");
  }

  Future<void> loadUserProfile() async {
    isLoading(true);

    try {
      String? token = await PrefsHelper.getString(AppConstants.bearerToken);

      if (token == null || token.isEmpty) {
        ToastMessageHelper.errorMessageShowToster("No token found");
        isLoading(false);
        return;
      }

      final url = Uri.parse("${ApiConstants.baseUrl}/profile/profile-information");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode != 200) {
        ToastMessageHelper.errorMessageShowToster("Error loading profile");
        isLoading(false);
        return;
      }

      final responseData = jsonDecode(response.body);

      final data = responseData["data"];
      if (data == null || data.length < 2) {
        ToastMessageHelper.errorMessageShowToster("Invalid data structure");
        isLoading(false);
        return;
      }

      // -----------------------------
      // ✔ Extract USER (index 0)
      // -----------------------------
      final user = data[0]["user"];
      final imageUrl = user["profile_pic"]?["url"];

      // -----------------------------
      // ✔ Extract USER INFO (index 1)
      // -----------------------------
      final userInfo = data[1]["userInfo"];
      final String fullName = userInfo["name"] ?? "";

      // OPTIONAL split full name
      final nameParts = fullName.trim().split(" ");
      firstName.value = nameParts.isNotEmpty ? nameParts[0] : "";
      lastName.value = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

      // Profile Image
      profileImage.value = imageUrl ?? "";

      // Save in cache
      await PrefsHelper.setString(AppConstants.userData, jsonEncode({
        "firstName": firstName.value,
        "lastName": lastName.value,
        "profileImage": profileImage.value,
      }));

      print("✅ PROFILE LOADED SUCCESSFULLY");

    } catch (e) {
      print("💥 PROFILE LOAD ERROR: $e");
      ToastMessageHelper.errorMessageShowToster("Failed loading profile");
    } finally {
      isLoading(false);
    }
  }



  Future<void> loadFromLocalCache() async {
    String? userJson = await PrefsHelper.getString(AppConstants.userData);

    if (userJson != null && userJson.isNotEmpty) {
      try {
        final user = jsonDecode(userJson);

        firstName.value = user['firstName'] ?? "";
        lastName.value = user['lastName'] ?? "";
        profileImage.value = user['profileImage'] ?? "";
      } catch (_) {}
    }

    measurementSystem.value =
        await PrefsHelper.getString("measurement_system") ?? "Metric";
  }

  @override
  void onInit() {
    super.onInit();
    loadFromLocalCache();
    loadUserProfile();
  }
}
