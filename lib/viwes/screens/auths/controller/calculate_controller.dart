import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/helpers/prefs_helper.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class CalculateController extends GetxController {
  // Metric inputs
  final heightController = TextEditingController();
  final currentWeightController = TextEditingController();
  final objectiveWeightController = TextEditingController();

  // Imperial inputs
  final ftController = TextEditingController();
  final inchController = TextEditingController();
  final currentLbsController = TextEditingController();
  final desiredLbsController = TextEditingController();

  String? selectedActivityLevel;
  String? selectedGoal;
  String weightLossSpeed = "0.8"; // default as string
  final ageController = TextEditingController();
  String? selectedGender;

  var basicInfoLoading = false.obs;
  var profileLoading = false.obs;

  // Profile data
  var heightFt = 5.obs;
  var heightIn = 7.obs;
  var heightCm = 175.obs;
  var currentWeightLbs = 68.obs;
  var currentWeightKg = 80.obs;
  var desiredWeightLbs = 70.obs;
  var desiredWeightKg = 75.obs;
  var calories = 1641.obs;
  var protein = 49.35.obs;
  var carbs = 37.01.obs;
  var fat = 21.59.obs;

  @override
  void onInit() {
    super.onInit();
    // Load profile data based on unit system
    loadProfileData();
  }

  @override
  void onClose() {
    heightController.dispose();
    currentWeightController.dispose();
    objectiveWeightController.dispose();
    ftController.dispose();
    inchController.dispose();
    currentLbsController.dispose();
    desiredLbsController.dispose();
    ageController.dispose();
    super.onClose();
  }

  /// Load profile data based on unit system
  Future<void> loadProfileData({String unitSystem = "Imperial"}) async {
    profileLoading.value = true;
    try {
      String token = await PrefsHelper.getString('bearerToken');
      if (token.isEmpty) {
        profileLoading.value = false;
        return;
      }
      final bearerToken = token.startsWith("Bearer ") ? token : "Bearer $token";

      // First get profile information to get userId
      final profileUrl = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getProfileInfo}');
      final profileResponse = await http.get(
        profileUrl,
        headers: {
          "Authorization": bearerToken,
          "Accept": "application/json",
        },
      );

      if (profileResponse.statusCode == 200) {
        final profileData = jsonDecode(profileResponse.body);
        if (profileData['success'] == true && profileData['data'] != null) {
          final data = profileData['data'] as List;
          
          // Find userInfo in the response
          Map<String, dynamic>? userInfo;
          for (var item in data) {
            if (item is Map && item.containsKey('userInfo')) {
              userInfo = item['userInfo'];
              break;
            }
          }

          if (userInfo != null) {
            // Parse height
            final height = userInfo['height'];
            if (height != null) {
              heightFt.value = height['ft'] ?? 5;
              heightIn.value = height['in'] ?? 7;
              heightCm.value = height['cm'] ?? 175;
            }

            // Parse weights
            final currentWeight = userInfo['currentWeight'];
            if (currentWeight != null) {
              currentWeightLbs.value = currentWeight['lbs'] ?? 68;
              currentWeightKg.value = currentWeight['kg'] ?? 80;
            }

            final desiredWeight = userInfo['desiredWeight'];
            if (desiredWeight != null) {
              desiredWeightLbs.value = desiredWeight['lbs'] ?? 70;
              desiredWeightKg.value = desiredWeight['kg'] ?? 75;
            }

            // Parse macros
            final macros = userInfo['macrosValue'];
            if (macros != null) {
              calories.value = macros['calories'] ?? 1641;
              protein.value = macros['protein'] ?? 49.35;
              carbs.value = macros['carbs'] ?? 37.01;
              fat.value = macros['fat'] ?? 21.59;
            }

            // Pre-fill controllers based on unit system
            if (unitSystem == "Imperial") {
              ftController.text = heightFt.value.toString();
              inchController.text = heightIn.value.toString();
              currentLbsController.text = currentWeightLbs.value.toString();
              desiredLbsController.text = desiredWeightLbs.value.toString();
            } else {
              heightController.text = heightCm.value.toString();
              currentWeightController.text = currentWeightKg.value.toString();
              objectiveWeightController.text = desiredWeightKg.value.toString();
            }
          }
        }
      }

      // Also fetch from unit-specific endpoint
      final url = Uri.parse(
        '${ApiConstants.baseUrl}/users/get-user-info-by-unit?unitSystem=$unitSystem'
      );
      final response = await http.get(
        url,
        headers: {
          "Authorization": bearerToken,
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          
          // Update height
          final height = data['height'];
          if (height != null) {
            if (height.containsKey('ft')) heightFt.value = height['ft'];
            if (height.containsKey('in')) heightIn.value = height['in'];
            if (height.containsKey('cm')) heightCm.value = height['cm'];
          }

          // Update current weight
          final currentWeight = data['currentWeight'];
          if (currentWeight != null) {
            if (currentWeight.containsKey('lbs')) currentWeightLbs.value = currentWeight['lbs'];
            if (currentWeight.containsKey('kg')) currentWeightKg.value = currentWeight['kg'];
          }

          // Update desired weight
          final desiredWeight = data['desiredWeight'];
          if (desiredWeight != null) {
            if (desiredWeight.containsKey('lbs')) desiredWeightLbs.value = desiredWeight['lbs'];
            if (desiredWeight.containsKey('kg')) desiredWeightKg.value = desiredWeight['kg'];
          }

          // Update macros
          final macros = data['macrosValue'];
          if (macros != null) {
            calories.value = macros['calories'] ?? 1641;
            protein.value = macros['protein'] ?? 49.35;
            carbs.value = macros['carbs'] ?? 37.01;
            fat.value = macros['fat'] ?? 21.59;
          }

          // Pre-fill controllers
          if (unitSystem == "Imperial") {
            ftController.text = heightFt.value.toString();
            inchController.text = heightIn.value.toString();
            currentLbsController.text = currentWeightLbs.value.toString();
            desiredLbsController.text = desiredWeightLbs.value.toString();
          } else {
            heightController.text = heightCm.value.toString();
            currentWeightController.text = currentWeightKg.value.toString();
            objectiveWeightController.text = desiredWeightKg.value.toString();
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading profile data: $e");
    } finally {
      profileLoading.value = false;
    }
  }

  void showSnack(BuildContext context, String title, String message) {
    if (Get.overlayContext != null) {
      Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$title: $message")),
      );
    }
  }

  Future<void> addBasicInfoHandle({
    required bool isMetric,
    required BuildContext context,
  }) async {
    basicInfoLoading(true);

    try {
      String token = await PrefsHelper.getString('bearerToken');
      if (token.isEmpty) {
        basicInfoLoading(false);
        showSnack(context, "Error", "Session expired. Please log in again.");
        return;
      }
      final bearerToken = token.startsWith("Bearer ") ? token : "Bearer $token";
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.basicInfo}');

      // Build height
      Map<String, dynamic> heightMap = isMetric
          ? {"cm": int.tryParse(heightController.text) ?? 0}
          : {
        "ft": int.tryParse(ftController.text) ?? 0,
        "in": int.tryParse(inchController.text) ?? 0,
        "cm": 0 // optional: can calculate cm if needed
      };

      // Build weights
      Map<String, dynamic> currentWeightMap = isMetric
          ? {"kg": double.tryParse(currentWeightController.text) ?? 0, "lbs": 0}
          : {
        "lbs": double.tryParse(currentLbsController.text) ?? 0,
        "kg": 0 // optional: can calculate kg if needed
      };

      Map<String, dynamic> desiredWeightMap = isMetric
          ? {"kg": double.tryParse(objectiveWeightController.text) ?? 0, "lbs": 0}
          : {
        "lbs": double.tryParse(desiredLbsController.text) ?? 0,
        "kg": 0
      };

      final body = {
        "unitSystem": isMetric ? "Metric" : "Imperial",
        "height": heightMap,
        "activityLevel": selectedActivityLevel ?? "3-5 Workout per week",
        "currentWeight": currentWeightMap,
        "desiredWeight": desiredWeightMap,
        "weightLossSpeed": weightLossSpeed, // <-- send as string!
        "goal": selectedGoal ?? "maintenance",
        "gender": selectedGender ?? "male",
        "age": int.tryParse(ageController.text) ?? 25
      };

      debugPrint("=====> Bearer Token: $bearerToken");
      debugPrint("=====> URL: $url");
      debugPrint("=====> Body: $body");
      debugPrint("=====> Headers: {Content-Type: application/json, Authorization: $bearerToken}");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": bearerToken,
        },
        body: jsonEncode(body),
      );

      debugPrint("=====> Status Code: ${response.statusCode}");
      debugPrint("=====> Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        if (res["success"] == true) {
          // Navigate to congratulation screen
          context.go(RouteNames.infoCongratulationScreen);
        } else {
          showSnack(context, "Error", res["message"] ?? "Something went wrong");
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        showSnack(context, "Unauthorized", "Please log in again.");
      } else {
        showSnack(context, "Error",
            "Failed (${response.statusCode}): ${response.reasonPhrase ?? 'Unknown error'}");
      }
    } catch (e) {
      showSnack(context, "Error", "Unexpected error: $e");
    } finally {
      basicInfoLoading(false);
      debugPrint("=====> addBasicInfoHandle finished");
    }
  }
}
