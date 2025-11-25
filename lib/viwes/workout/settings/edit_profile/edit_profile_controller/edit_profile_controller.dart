import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:gym_cheloper/helpers/prefs_helper.dart';
import 'package:gym_cheloper/helpers/toast_message_helper.dart';
import 'package:gym_cheloper/services/api_constants.dart';

class ProfileInfoController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isEditMode = false.obs;

  RxString profileImage = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;
  RxString gender = ''.obs;
  RxString age = ''.obs;
  RxString height = ''.obs;
  RxString weight = ''.obs;

  // TextControllers
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    genderController = TextEditingController();
    ageController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();

    fetchUserProfile();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    genderController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;

    try {
      final token = await PrefsHelper.getString("bearerToken");
      if (token == null || token.isEmpty) {
        ToastMessageHelper.errorMessageShowToster("No token found");
        isLoading.value = false;
        return;
      }

      final url = Uri.parse("${ApiConstants.baseUrl}/profile/profile-information");
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        if (data != null && data.length >= 2) {
          final user = data[0]['user'];
          final userInfo = data[1]['userInfo'];

          profileImage.value = user['profile_pic']?['url'] ?? '';
          firstName.value = userInfo['name'] ?? '';
          lastName.value = ''; // API has only one name
          email.value = user['email'] ?? '';
          gender.value = userInfo['gender'] ?? '';
          age.value = userInfo['age'] ?? '';
          height.value =
          "${userInfo['height']?['ft'] ?? 0}ft ${userInfo['height']?['in'] ?? 0}in";
          weight.value = "${userInfo['currentWeight']?['lbs'] ?? 0} lbs";

          // Fill TextControllers
          fullNameController.text = '${firstName.value} ${lastName.value}';
          emailController.text = email.value;
          genderController.text = gender.value;
          ageController.text = age.value;
          heightController.text = height.value;
          weightController.text = weight.value;

          print("✅ PROFILE LOADED SUCCESSFULLY");
        } else {
          ToastMessageHelper.errorMessageShowToster("Invalid profile data");
        }
      } else {
        ToastMessageHelper.errorMessageShowToster(
            "Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("💥 PROFILE LOAD ERROR: $e");
      ToastMessageHelper.errorMessageShowToster("Connection error");
    } finally {
      isLoading.value = false;
    }
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = image.path;
    }
  }

  void updateProfile() {
    final fullName = fullNameController.text.trim();
    final parts = fullName.split(' ');
    firstName.value = parts.first;
    lastName.value = parts.length > 1 ? parts.last : '';

    email.value = emailController.text.trim();
    gender.value = genderController.text.trim();
    age.value = ageController.text.trim();
    height.value = heightController.text.trim();
    weight.value = weightController.text.trim();

    ToastMessageHelper.successMessageShowToster("Profile updated locally");
  }
}
