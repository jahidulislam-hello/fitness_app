import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:gym_cheloper/helpers/prefs_helper.dart';
import 'package:gym_cheloper/helpers/toast_message_helper.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:gym_cheloper/utils/app_constant.dart';

class SignInController extends GetxController {
  final TextEditingController loginEmailTEController = TextEditingController();
  final TextEditingController loginPassTEController = TextEditingController();

  RxBool loadingLoading = false.obs;

  /// Login method with email & password parameters
  Future<void> loginHandle(String email, String password, BuildContext context) async {
    email = email.trim();
    password = password.trim();

    // Validate fields
    if (email.isEmpty || password.isEmpty) {
      ToastMessageHelper.errorMessageShowToster("Email and password are required");
      return;
    }

    // Email format validation
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      ToastMessageHelper.errorMessageShowToster("Invalid email format");
      return;
    }

    loadingLoading(true);

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/users/login-user');

      print("🌐 Full URL: $url");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("➡️ Response Code: ${response.statusCode}");
      print("➡️ Response Body: ${response.body}");

      // Check if response body is empty
      if (response.body.isEmpty) {
        ToastMessageHelper.errorMessageShowToster("Empty response from server");
        loadingLoading(false);
        return;
      }

      // Parse JSON
      dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        print("❌ JSON Parse Error: $e");
        print("📄 Raw Response: ${response.body}");
        ToastMessageHelper.errorMessageShowToster("Invalid response from server");
        loadingLoading(false);
        return;
      }

      // Handle success response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("📦 Response Data: $responseData");

        if (responseData is Map<String, dynamic> &&
            responseData['success'] == true &&
            responseData['data'] != null) {

          final data = responseData['data'];

          // Check data structure - should be a List with 3 objects
          if (data is! List || data.isEmpty || data.length < 3) {
            print("❌ Invalid data structure: $data");
            ToastMessageHelper.errorMessageShowToster("Invalid response structure");
            loadingLoading(false);
            return;
          }

          print("📋 Data array length: ${data.length}");

          // Extract tokens and user based on YOUR API structure
          String? accessToken;
          String? refreshToken;
          Map<String, dynamic>? user;

          // data[0] contains { "accessToken": "..." }
          if (data[0] is Map<String, dynamic> && data[0].containsKey('accessToken')) {
            accessToken = data[0]['accessToken'] as String?;
          }

          // data[1] contains { "refreshToken": "..." }
          if (data.length > 1 && data[1] is Map<String, dynamic> && data[1].containsKey('refreshToken')) {
            refreshToken = data[1]['refreshToken'] as String?;
          }

          // data[2] contains { "user": {...} }
          if (data.length > 2 && data[2] is Map<String, dynamic> && data[2].containsKey('user')) {
            user = data[2]['user'] as Map<String, dynamic>?;
          }

          print("🔐 Extracted Access Token: ${accessToken?.substring(0, 20)}...");
          print("♻️ Extracted Refresh Token: ${refreshToken?.substring(0, 20)}...");
          print("👤 Extracted User Name: ${user?['name']}");
          print("👤 Extracted User Email: ${user?['email']}");
          print("👤 Extracted User ID: ${user?['_id']}");

          if (accessToken != null && accessToken.isNotEmpty) {
            // Save tokens and user data
            await PrefsHelper.setString(AppConstants.bearerToken, accessToken);
            print("✅ Access Token saved");

            if (refreshToken != null && refreshToken.isNotEmpty) {
              await PrefsHelper.setString(AppConstants.refreshToken, refreshToken);
              print("✅ Refresh Token saved");
            }

            if (user != null) {
              await PrefsHelper.setString(AppConstants.userData, jsonEncode(user));
              print("✅ User Data saved");

              // Optionally save individual user fields for easy access
              if (user['name'] != null) {
                await PrefsHelper.setString('user_name', user['name']);
              }
              if (user['email'] != null) {
                await PrefsHelper.setString('user_email', user['email']);
              }
              if (user['_id'] != null) {
                await PrefsHelper.setString('user_id', user['_id']);
              }
            }

            print("✅ Login Successful!");

            ToastMessageHelper.successMessageShowToster("Welcome back, ${user?['name'] ?? 'User'}!");

            // Navigate to home
            if (context.mounted) {
              context.go(RouteNames.customNavBar);
            }
          } else {
            print("❌ No access token found in response");
            ToastMessageHelper.errorMessageShowToster("Authentication failed - no token received");
          }
        } else {
          final errorMessage = (responseData is Map<String, dynamic> && responseData['message'] != null)
              ? responseData['message'] as String
              : "Login failed";
          ToastMessageHelper.errorMessageShowToster(errorMessage);
        }
      } else if (response.statusCode == 400) {
        final errorMessage = (responseData is Map<String, dynamic> && responseData['message'] != null)
            ? responseData['message'] as String
            : "Bad request - Please check your credentials";
        ToastMessageHelper.errorMessageShowToster(errorMessage);
      } else if (response.statusCode == 401) {
        final errorMessage = (responseData is Map<String, dynamic> && responseData['message'] != null)
            ? responseData['message'] as String
            : "Invalid email or password";
        ToastMessageHelper.errorMessageShowToster(errorMessage);
      } else if (response.statusCode == 404) {
        ToastMessageHelper.errorMessageShowToster("User not found");
      } else if (response.statusCode == 503) {
        ToastMessageHelper.errorMessageShowToster(
            "Server temporarily unavailable. Please try again later.");
      } else {
        final errorMessage = (responseData is Map<String, dynamic> && responseData['message'] != null)
            ? responseData['message'] as String
            : "Authentication failed (${response.statusCode})";
        ToastMessageHelper.errorMessageShowToster(errorMessage);
      }
    } catch (e, stackTrace) {
      print("💥 Login Error: $e");
      print("📍 Stack Trace: $stackTrace");
      ToastMessageHelper.errorMessageShowToster("Connection error. Please check your internet.");
    } finally {
      loadingLoading(false);
    }
  }

  @override
  void onClose() {
    loginEmailTEController.dispose();
    loginPassTEController.dispose();
    super.onClose();
  }
}