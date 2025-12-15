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
      // Get token from SharedPreferences (key: "token")
      final token = await PrefsHelper.getString("token");

      print("🔐 Token Retrieved: ${token != null ? 'Yes' : 'No'}");

      if (token == null || token.isEmpty) {
        print("❌ No token found");
        ToastMessageHelper.errorMessageShowToster("No token found");
        isLoading.value = false;
        return;
      }

      final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.getProfileInfo}");
      print("🌐 Fetching profile from: $url");

      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      print("📡 Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check if response is successful
        if (responseData['success'] != true) {
          print("❌ API returned success: false");
          ToastMessageHelper.errorMessageShowToster(
              responseData['message'] ?? "Failed to load profile");
          isLoading.value = false;
          return;
        }

        final data = responseData['data'];

        if (data != null && data is List && data.length >= 2) {
          // Extract user data (index 0)
          final userWrapper = data[0];
          final user = userWrapper['user'];

          // Extract user info (index 1)
          final userInfoWrapper = data[1];
          final userInfo = userInfoWrapper['userInfo'];

          print("👤 User Email: ${user['email']}");
          print("👤 User Name: ${userInfo['name']}");
          print("👤 Gender: ${userInfo['gender']}");
          print("👤 Age: ${userInfo['age']}");

          // Set profile data
          profileImage.value = user['profile_pic']?['url'] ?? '';
          firstName.value = userInfo['name'] ?? '';
          lastName.value = ''; // API has only one name field
          email.value = user['email'] ?? '';
          gender.value = userInfo['gender'] ?? '';
          age.value = userInfo['age']?.toString() ?? '';

          // Format height - handle both object and number formats
          final heightData = userInfo['height'];
          if (heightData is Map) {
            // Format: {"ft": 5, "in": 7, "cm": 170}
            final heightFt = heightData['ft'] ?? 0;
            final heightIn = heightData['in'] ?? 0;
            height.value = "${heightFt}ft ${heightIn}in";
            print("📏 Height (from object): ${height.value}");
          } else if (heightData is num) {
            // Format: 170 (cm)
            // Convert cm to feet and inches
            final totalInches = (heightData / 2.54); // cm to inches
            final ft = (totalInches / 12).floor();
            final inches = (totalInches % 12).round();
            height.value = "${ft}ft ${inches}in";
            print("📏 Height (from cm): $heightData cm → ${height.value}");
          } else {
            height.value = "0ft 0in";
            print("⚠️ Unknown height format: $heightData");
          }

          // Format weight - handle both object and number formats
          final weightData = userInfo['currentWeight'];
          if (weightData is Map) {
            // Format: {"lbs": 170, "kg": 77}
            final weightLbs = weightData['lbs'] ?? 0;
            weight.value = "$weightLbs lbs";
            print("⚖️ Weight (from object): ${weight.value}");
          } else if (weightData is num) {
            // Format: 77 (kg)
            // Convert kg to lbs
            final lbs = (weightData / 0.453592).round();
            weight.value = "$lbs lbs";
            print("⚖️ Weight (from kg): $weightData kg → ${weight.value}");
          } else {
            weight.value = "0 lbs";
            print("⚠️ Unknown weight format: $weightData");
          }

          // Fill TextControllers
          fullNameController.text = firstName.value.trim();
          emailController.text = email.value;
          genderController.text = gender.value;
          ageController.text = age.value;
          heightController.text = height.value;
          weightController.text = weight.value;

          print("✅ PROFILE LOADED SUCCESSFULLY");
          print("📊 Name: ${firstName.value}");
          print("📊 Email: ${email.value}");
          print("📊 Gender: ${gender.value}");
          print("📊 Age: ${age.value}");
          print("📊 Height: ${height.value}");
          print("📊 Weight: ${weight.value}");
        } else {
          print("❌ Invalid data structure. Data length: ${data?.length ?? 0}");
          ToastMessageHelper.errorMessageShowToster("Invalid profile data");
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        ToastMessageHelper.errorMessageShowToster(
            "Error ${response.statusCode}: Failed to load profile");
      }
    } catch (e, stackTrace) {
      print("💥 PROFILE LOAD ERROR: $e");
      print("📚 Stack Trace: $stackTrace");
      ToastMessageHelper.errorMessageShowToster("Connection error: $e");
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

  Future<void> updateProfile() async {
    // Validate inputs
    if (fullNameController.text.trim().isEmpty) {
      ToastMessageHelper.errorMessageShowToster("Name is required");
      return;
    }

    if (genderController.text.trim().isEmpty) {
      ToastMessageHelper.errorMessageShowToster("Gender is required");
      return;
    }

    if (ageController.text.trim().isEmpty) {
      ToastMessageHelper.errorMessageShowToster("Age is required");
      return;
    }

    isLoading.value = true;

    try {
      // Get token
      final token = await PrefsHelper.getString("token");

      if (token == null || token.isEmpty) {
        print("❌ No token found for update");
        ToastMessageHelper.errorMessageShowToster("No token found");
        isLoading.value = false;
        return;
      }

      // Parse form data
      final name = fullNameController.text.trim();
      final genderInput = genderController.text.trim();
      final ageInput = ageController.text.trim();
      final heightInput = heightController.text.trim();
      final weightInput = weightController.text.trim();

      print("📝 Update Form Data:");
      print("  Name: $name");
      print("  Gender: $genderInput");
      print("  Age: $ageInput");
      print("  Height: $heightInput");
      print("  Weight: $weightInput");

      // Parse age
      int? parsedAge = int.tryParse(ageInput);
      if (parsedAge == null) {
        ToastMessageHelper.errorMessageShowToster("Invalid age format");
        isLoading.value = false;
        return;
      }

      // Parse height (from "5ft 7in" format to cm)
      double heightInCm = _parseHeightToCm(heightInput);
      if (heightInCm == 0) {
        ToastMessageHelper.errorMessageShowToster("Invalid height format");
        isLoading.value = false;
        return;
      }

      // Parse weight (from "170 lbs" format to kg)
      double weightInKg = _parseWeightToKg(weightInput);
      if (weightInKg == 0) {
        ToastMessageHelper.errorMessageShowToster("Invalid weight format");
        isLoading.value = false;
        return;
      }

      print("🔄 Converted Values:");
      print("  Height: $heightInCm cm");
      print("  Weight: $weightInKg kg");

      // Prepare request body
      final requestBody = {
        "name": name,
        "gender": genderInput,
        "age": parsedAge,
        "height": heightInCm.round(),
        "heightUnit": "cm",
        "mass": weightInKg.round(),
        "massUnit": "kg",
      };

      print("📤 Request Body: ${jsonEncode(requestBody)}");

      final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.updateProfile}");
      print("🌐 Updating profile at: $url");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("📡 Update Response Status: ${response.statusCode}");
      print("📦 Update Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          print("✅ PROFILE UPDATED SUCCESSFULLY");

          // Update local values
          firstName.value = name;
          email.value = emailController.text.trim();
          gender.value = genderInput;
          age.value = ageInput;
          height.value = heightInput;
          weight.value = weightInput;

          // Refresh profile data from server
          await fetchUserProfile();

          ToastMessageHelper.successMessageShowToster(
              responseData['message'] ?? "Profile updated successfully");

          // Exit edit mode
          isEditMode.value = false;
        } else {
          print("❌ Update failed: ${responseData['message']}");
          ToastMessageHelper.errorMessageShowToster(
              responseData['message'] ?? "Failed to update profile");
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        ToastMessageHelper.errorMessageShowToster(
            "Error ${response.statusCode}: Failed to update profile");
      }
    } catch (e, stackTrace) {
      print("💥 UPDATE ERROR: $e");
      print("📚 Stack Trace: $stackTrace");
      ToastMessageHelper.errorMessageShowToster("Connection error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Parse height from "5ft 7in" to cm
  double _parseHeightToCm(String heightStr) {
    try {
      // Remove extra spaces and convert to lowercase
      final cleaned = heightStr.trim().toLowerCase();

      // Check if already in cm
      if (cleaned.endsWith('cm')) {
        final cmStr = cleaned.replaceAll('cm', '').trim();
        return double.tryParse(cmStr) ?? 0;
      }

      // Parse "5ft 7in" format
      final ftMatch = RegExp(r'(\d+)\s*ft').firstMatch(cleaned);
      final inMatch = RegExp(r'(\d+)\s*in').firstMatch(cleaned);

      if (ftMatch != null) {
        final ft = int.tryParse(ftMatch.group(1) ?? '0') ?? 0;
        final inches = int.tryParse(inMatch?.group(1) ?? '0') ?? 0;

        // Convert to cm: 1 ft = 30.48 cm, 1 in = 2.54 cm
        final totalCm = (ft * 30.48) + (inches * 2.54);
        print("  Height Conversion: ${ft}ft ${inches}in = $totalCm cm");
        return totalCm;
      }

      return 0;
    } catch (e) {
      print("⚠️ Height parsing error: $e");
      return 0;
    }
  }

  /// Parse weight from "170 lbs" to kg
  double _parseWeightToKg(String weightStr) {
    try {
      // Remove extra spaces and convert to lowercase
      final cleaned = weightStr.trim().toLowerCase();

      // Check if already in kg
      if (cleaned.endsWith('kg')) {
        final kgStr = cleaned.replaceAll('kg', '').trim();
        return double.tryParse(kgStr) ?? 0;
      }

      // Parse "170 lbs" format
      final lbsMatch = RegExp(r'(\d+\.?\d*)\s*lbs?').firstMatch(cleaned);

      if (lbsMatch != null) {
        final lbs = double.tryParse(lbsMatch.group(1) ?? '0') ?? 0;

        // Convert to kg: 1 lbs = 0.453592 kg
        final kg = lbs * 0.453592;
        print("  Weight Conversion: ${lbs} lbs = $kg kg");
        return kg;
      }

      // Try parsing just a number (assume lbs)
      final numMatch = RegExp(r'(\d+\.?\d*)').firstMatch(cleaned);
      if (numMatch != null) {
        final lbs = double.tryParse(numMatch.group(1) ?? '0') ?? 0;
        final kg = lbs * 0.453592;
        print("  Weight Conversion (assumed lbs): ${lbs} lbs = $kg kg");
        return kg;
      }

      return 0;
    } catch (e) {
      print("⚠️ Weight parsing error: $e");
      return 0;
    }
  }
}
