import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/helpers/prefs_helper.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:gym_cheloper/utils/app_constant.dart';
import 'package:http/http.dart' as http;

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

  // Custom plan data
  var weightToLose = 0.0.obs;
  var isWeightLoss = false.obs;
  var unit = "lbs".obs;
  var goalDate = "".obs;

  // Store the unit system for this controller instance
  String unitSystem = "Imperial";

  CalculateController({this.unitSystem = "Imperial"});

  @override
  void onInit() {
    super.onInit();
    // Load profile data based on unit system
    loadProfileData(unitSystem: unitSystem);
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
      String token = await PrefsHelper.getString(AppConstants.bearerToken);
      if (token.isEmpty) {
        profileLoading.value = false;
        return;
      }
      final bearerToken = token.startsWith("Bearer ") ? token : "Bearer $token";

      // Fetch from unit-specific endpoint
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
            if (height.containsKey('ft')) heightFt.value = height['ft'] ?? 5;
            if (height.containsKey('in')) heightIn.value = height['in'] ?? 7;
            if (height.containsKey('cm')) heightCm.value = height['cm'] ?? 175;
          }

          // Update current weight
          final currentWeight = data['currentWeight'];
          if (currentWeight != null) {
            if (currentWeight.containsKey('lbs')) currentWeightLbs.value = currentWeight['lbs'] ?? 68;
            if (currentWeight.containsKey('kg')) currentWeightKg.value = currentWeight['kg'] ?? 80;
          }

          // Update desired weight
          final desiredWeight = data['desiredWeight'];
          if (desiredWeight != null) {
            if (desiredWeight.containsKey('lbs')) desiredWeightLbs.value = desiredWeight['lbs'] ?? 70;
            if (desiredWeight.containsKey('kg')) desiredWeightKg.value = desiredWeight['kg'] ?? 75;
          }

          // Update macros
          final macros = data['macrosValue'];
          if (macros != null) {
            calories.value = macros['calories'] ?? 1641;
            protein.value = macros['protein'] ?? 49.35;
            carbs.value = macros['carbs'] ?? 37.01;
            fat.value = macros['fat'] ?? 21.59;
          }

          // Pre-fill ALL fields from API
          if (data['activityLevel'] != null && data['activityLevel'].toString().isNotEmpty) {
            selectedActivityLevel = data['activityLevel'];
          }
          if (data['goal'] != null && data['goal'].toString().isNotEmpty) {
            selectedGoal = data['goal'];
          }
          if (data['weightLossSpeed'] != null) {
            weightLossSpeed = data['weightLossSpeed'].toString();
          }
          if (data['gender'] != null && data['gender'].toString().isNotEmpty) {
            selectedGender = data['gender'];
          }
          if (data['age'] != null && data['age'].toString().isNotEmpty) {
            ageController.text = data['age'].toString();
          }

          // Pre-fill text controllers with API data
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
    // Prevent duplicate submissions
    if (basicInfoLoading.value) {
      debugPrint("=====> addBasicInfoHandle: Already processing, ignoring duplicate call");
      return;
    }
    
    basicInfoLoading(true);

    try {
      String token = await PrefsHelper.getString(AppConstants.bearerToken);
      if (token.isEmpty) {
        basicInfoLoading(false);
        showSnack(context, "Error", "Session expired. Please log in again.");
        return;
      }
      final bearerToken = token.startsWith("Bearer ") ? token : "Bearer $token";
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.basicInfo}');

      // Build height - only send relevant fields
      Map<String, dynamic> heightMap = isMetric
          ? {"cm": int.tryParse(heightController.text) ?? 175}
          : {
              "ft": int.tryParse(ftController.text) ?? 5,
              "in": int.tryParse(inchController.text) ?? 7,
            };

      // Build weights - only send relevant fields for the unit system
      Map<String, dynamic> currentWeightMap = isMetric
          ? {"kg": double.tryParse(currentWeightController.text) ?? 80}
          : {
              "lbs": double.tryParse(currentLbsController.text) ?? 170,
            };

      Map<String, dynamic> desiredWeightMap = isMetric
          ? {"kg": double.tryParse(objectiveWeightController.text) ?? 75}
          : {
              "lbs": double.tryParse(desiredLbsController.text) ?? 165,
            };

      final body = {
        "unitSystem": isMetric ? "Metric" : "Imperial",
        "height": heightMap,
        "activityLevel": selectedActivityLevel ?? "3-5 Workout per week",
        "currentWeight": currentWeightMap,
        "desiredWeight": desiredWeightMap,
        "weightLossSpeed": double.tryParse(weightLossSpeed) ?? 0.8,
        "goal": selectedGoal ?? "cutting", // Changed default to "cutting" to match API
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
          debugPrint("=====> Basic info saved successfully, fetching custom plan...");
          // Fetch custom plan data before navigation
          await fetchCustomPlan();
          debugPrint("=====> Custom plan fetched, navigating to congratulation screen...");
          // Small delay to ensure data is saved
          await Future.delayed(const Duration(milliseconds: 300));
          // Navigate to congratulation screen using GetX
          Get.offAllNamed(RouteNames.infoCongratulationScreen);
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

  /// Fetch custom plan data
  Future<void> fetchCustomPlan() async {
    profileLoading.value = true;
    try {
      String token = await PrefsHelper.getString(AppConstants.bearerToken);
      if (token.isEmpty) {
        debugPrint("=====> fetchCustomPlan: No token found");
        profileLoading.value = false;
        return;
      }
      final bearerToken = token.startsWith("Bearer ") ? token : "Bearer $token";
      final url = Uri.parse('${ApiConstants.baseUrl}/users/get-custom-plan');

      debugPrint("=====> fetchCustomPlan URL: $url");
      final response = await http.get(
        url,
        headers: {
          "Authorization": bearerToken,
          "Accept": "application/json",
        },
      );

      debugPrint("=====> fetchCustomPlan Status Code: ${response.statusCode}");
      debugPrint("=====> fetchCustomPlan Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];

          weightToLose.value = data['weightToLose']?.toDouble() ?? 0.0;
          isWeightLoss.value = data['isWeightLoss'] ?? false;
          unit.value = data['unit'] ?? "lbs";
          goalDate.value = data['goalDate'] ?? "";

          // Update macros from custom plan
          final macros = data['macrosValue'];
          if (macros != null) {
            calories.value = macros['calories'] ?? 1641;
            protein.value = macros['protein'] ?? 49.35;
            carbs.value = macros['carbs'] ?? 37.01;
            fat.value = macros['fat'] ?? 21.59;
          }
          
          debugPrint("=====> fetchCustomPlan: Data loaded successfully");
          debugPrint("=====> Weight to lose: ${weightToLose.value} ${unit.value}");
          debugPrint("=====> Goal date: ${goalDate.value}");
        } else {
          debugPrint("=====> fetchCustomPlan: Response not successful or data is null");
        }
      } else {
        debugPrint("=====> fetchCustomPlan: Failed with status ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("=====> fetchCustomPlan Error: $e");
    } finally {
      profileLoading.value = false;
    }
  }
}
