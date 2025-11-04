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
          context.go(RouteNames.customNavBar);
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
