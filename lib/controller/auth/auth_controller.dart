
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../helpers/helpers.dart';
import '../../routes/routes_name.dart';
import 'package:http/http.dart' as http;
import '../../services/services.dart';
import '../../utils/utils.dart';


class AuthController extends GetxController {
  ///=============== Sign Up ================
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passTEController = TextEditingController();
  final TextEditingController confirmPassTEController = TextEditingController();
  final TextEditingController nameTEController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController heightFtController = TextEditingController();
  final TextEditingController heightInController = TextEditingController();
  final TextEditingController currentHeightController = TextEditingController();
  final TextEditingController currentWeightController = TextEditingController();
  final TextEditingController objectiveHeightController = TextEditingController();
  final TextEditingController objectiveWeightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  RxBool signUpLoading = false.obs;


  Future<void> signUpHandle(BuildContext context) async {
    if (passTEController.text.trim() != confirmPassTEController.text.trim()) {
      ToastMessageHelper.errorMessageShowToster("Passwords do not match");
      return;
    }

    signUpLoading(true);

    try {
      final headers = {'Content-Type': 'application/json'};
      final body = {
        "email": emailTEController.text.trim(),
        "password": passTEController.text.trim(),
      };

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.signUpEndPoint}');
      print("====> Sign-Up URL: $url");
      print("====> Body: $body");

      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      print("====> Status Code: ${response.statusCode}");
      print("====> Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Save token
        final accessToken = data['data']?['accessToken'] ?? '';
        if (accessToken.isNotEmpty) {
          await PrefsHelper.setString('bearerToken', accessToken);
          print("✅ Token saved: $accessToken");
        }

        ToastMessageHelper.successMessageShowToster(
          data['message'] ?? "Account created successfully!",
        );

        // Navigate to Basic Info screen (token fetched internally there)
        context.go(RouteNames.basicInformation);
      } else {
        final err = jsonDecode(response.body);
        ToastMessageHelper.errorMessageShowToster(
          err['message'] ?? "Signup failed (${response.statusCode})",
        );
      }
    } catch (e) {
      ToastMessageHelper.errorMessageShowToster("Error: $e");
    } finally {
      signUpLoading(false);
    }
  }



  RxBool verifyLoading = false.obs;

  Future<void> verifyOtp(String otp) async {
    verifyLoading(true);
    final url = Uri.parse('${ApiConstants.baseUrl}/user/verify-otp');

    // Prepare the body data
    var body = {
      'otp': otp,
    };

    String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken'
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          await PrefsHelper.setString(
              AppConstants.bearerToken, responseData['data']['token']);
          await PrefsHelper.setString(
              AppConstants.userId, responseData['data']['userId']);

          if (Get.parameters['screenType'] == 'forgot') {
            // Get.toNamed(AppRoutes.resetPassScreen, preventDuplicates: false);
          } else {
            Get.toNamed(
                RouteNames.informationOfClient, preventDuplicates: false);
          }
        }
        else {
          print("OTP verification failed: ${responseData['message']}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      verifyLoading(false);
    }
  }

  ///======================ForgotOtpVerify+++++++++++++++++++
  RxBool forVerifyLoading = false.obs;

  Future<void> forgotOtpVerify(String code) async {
    forVerifyLoading(true);
    String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
    String? userIds = await PrefsHelper.getString(AppConstants.userId);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      "otp": code
    };
    var response = await ApiClient.postData("/user/verify-forget-otp",
        jsonEncode(body),
        headers: headers
    );
    print("dataaaaaaaaaaaaaaa ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("token==================> ${response.body['data']}");
      await PrefsHelper.setString(
          AppConstants.bearerToken, response.body['data']['token']);
      await PrefsHelper.setString(
          AppConstants.userId, response.body['data']['userId'].toString());
      String type = await PrefsHelper.getString(AppConstants.type);
      if (Get.parameters['screenType'] == 'forgot') {
        Get.toNamed(RouteNames.resetPassScreen, preventDuplicates: false);
      } else {
        await PrefsHelper.setString(
            AppConstants.bearerToken, response.body['data']['token']);
        Get.toNamed(RouteNames.informationOfClient, preventDuplicates: false);
      }

      ToastMessageHelper.successMessageShowToster(
          response.body['message'].toString());
      forVerifyLoading(false);
    } else {
      ToastMessageHelper.errorMessageShowToster(
          response.body['message'].toString());
      print("token==================> ${response.body['data']}");
      forVerifyLoading(false);
    }
  }




  RxBool resendLoading = false.obs;

  ///=========================Resend OTP==============================
  resendOTP() async {
    resendLoading(true);
    String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {};
    print(body['email']);
    var response = await ApiClient.postData(
        "/user/resend",
        jsonEncode(body),
        headers: headers
    );
    print("responseeeeeeeeee ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.successMessageShowToster(response.body['message']);
      resendLoading(false);
    } else {
      resendLoading(false);
      ToastMessageHelper.errorMessageShowToster(response.body['message']);
    }
  }


  ///===================Forgot Password ======================


  RxBool forgotLogin = false.obs;

  forgotHandle(String email, screenType) async {
    forgotLogin(true);
    var body = {
      'email': email
    };

    var response = await ApiClient.postData(
        ApiConstants.forgotPassEndPoint,
        jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = response.body['data'];
      await PrefsHelper.setString(AppConstants.bearerToken, data['token']);
      ToastMessageHelper.successMessageShowToster(response.body['message']);

      Get.toNamed(RouteNames.otpVerificationScreen,
          parameters: {"screenType": "forgot", 'email': email});
      forgotLogin(false);
    } else {
      {
        ToastMessageHelper.errorMessageShowToster(response.body['message']);
        forgotLogin(false);
      }
    }
  }


  ///===============reset password ========================<>
  RxBool isResetLoading = false.obs;

  resetPassword(String firstController, String secondController) async {
    isResetLoading(true);
    String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      "password": firstController,
      "confirmPassword": secondController
    };

    var response = await ApiClient.postData(
        ApiConstants.resetPassEndPoint, jsonEncode(body),
        headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.successMessageShowToster(response.body['message']);
      Get.toNamed(RouteNames.signInScreen, preventDuplicates: false);
      isResetLoading(false);
    } else {
      isResetLoading(false);
      ToastMessageHelper.errorMessageShowToster(response.body['message']);
    }
  }

}
