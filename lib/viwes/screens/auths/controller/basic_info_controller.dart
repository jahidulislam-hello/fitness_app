import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/helpers/prefs_helper.dart';
import 'package:gym_cheloper/helpers/toast_message_helper.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:http/http.dart' as http;

class BasicInfoController extends GetxController {
  final TextEditingController nameTEController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedGender;
  RxBool basicInfoLoading = false.obs;

  Future<void> basicInfo(BuildContext context) async {
    basicInfoLoading(true);

    // Validation
    if (nameTEController.text.trim().isEmpty) {
      ToastMessageHelper.errorMessageShowToster("Please enter your name");
      basicInfoLoading(false);
      return;
    }
    if (ageController.text.trim().isEmpty || int.tryParse(ageController.text.trim()) == null) {
      ToastMessageHelper.errorMessageShowToster("Please enter a valid age");
      basicInfoLoading(false);
      return;
    }
    if (selectedGender == null || selectedGender!.isEmpty) {
      ToastMessageHelper.errorMessageShowToster("Please select a gender");
      basicInfoLoading(false);
      return;
    }

    try {
      final token = await PrefsHelper.getString('bearerToken');
      if (token == null || token.isEmpty) {
        ToastMessageHelper.errorMessageShowToster("Token missing. Please log in again.");
        basicInfoLoading(false);
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {
        "name": nameTEController.text.trim(),
        "age": int.tryParse(ageController.text.trim()) ?? 0,
        "gender": selectedGender!,
      };

      final url = Uri.parse('${ApiConstants.baseUrl}/users/add-age-gender-name');
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessageHelper.successMessageShowToster(
          data['message'] ?? "Information updated successfully!",
        );
        context.go(RouteNames.calculateMacros);
      } else {
        ToastMessageHelper.errorMessageShowToster(
          data['message'] ?? "Failed: ${response.statusCode}",
        );
      }
    } catch (e) {
      ToastMessageHelper.errorMessageShowToster("Error: $e");
    } finally {
      basicInfoLoading(false);
    }
  }

}
