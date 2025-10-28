
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  RxBool signUpLoading = false.obs;

  Future<void> signUpHandle() async {
    signUpLoading(true);
    try {
      var headers = {'Content-Type': 'application/json'};

      // Backend expects only name, email, password
      var body = {
        "name": nameTEController.text.trim(),
        "email": emailTEController.text.trim(),
        "password": passTEController.text.trim(),
      };

      var response = await ApiClient.postData(
        ApiConstants.signUpEndPoint,
        jsonEncode(body),
        headers: headers,
      );

      print("Signup Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // ✅ Save access token
        if (data['data'] != null && data['data']['accessToken'] != null) {
          await PrefsHelper.setString(
            AppConstants.bearerToken,
            data['data']['accessToken'],
          );
        }

        ToastMessageHelper.successMessageShowToster(
          "Account created successfully!",
        );

        // ✅ Move to Basic Info screen
        Get.toNamed(RouteNames.basicInformation);
      } else {
        final err = jsonDecode(response.body);
        ToastMessageHelper.errorMessageShowToster(
          err['message'] ?? "Signup failed",
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

  //
  // ///=========== Login ===========<>
  // final TextEditingController loginEmailTEController = TextEditingController();
  // final TextEditingController loginPassTEController = TextEditingController();
  //
  // RxBool loadingLoading = false.obs;
  //
  // Future<void> loginHandle(String email, String password) async {
  //   loadingLoading(true);
  //
  //   try {
  //     if (email.isEmpty || password.isEmpty) {
  //       print("⚠️ Please enter both email and password.");
  //       ToastMessageHelper.errorMessageShowToster("Email and password are required");
  //       return;
  //     }
  //
  //     var headers = {'Content-Type': 'application/json'};
  //     var body = {'email': email.trim(), 'password': password.trim()};
  //
  //     var response = await ApiClient.postData(
  //       ApiConstants.baseUrl + ApiConstants.signInEndPoint,
  //       jsonEncode(body), // Make sure body is JSON-encoded
  //       headers: headers,
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = response.body; // Already decoded in ApiClient.handleResponse
  //
  //       if (data['success'] == true) {
  //         // Extract tokens and user safely
  //         final accessToken = data['data'][0]['accessToken'] as String;
  //         final refreshToken = data['data'][1]['refreshToken'] as String;
  //         final user = data['data'][2]['user'] as Map<String, dynamic>;
  //
  //         // Save tokens
  //         await PrefsHelper.setString(AppConstants.bearerToken, accessToken);
  //
  //
  //         print("✅ Login Successful!");
  //         print("🔐 Access Token: $accessToken");
  //         print("♻️ Refresh Token: $refreshToken");
  //         print("👤 User: $user");
  //
  //         // Navigate to home screen
  //         Get.offAllNamed(RouteNames.customNavBar);
  //       } else {
  //         print("❌ Login failed: ${data['message']}");
  //         ToastMessageHelper.errorMessageShowToster(data['message'] ?? "Login failed");
  //       }
  //     } else {
  //       print("❌ HTTP Error: ${response.statusCode}");
  //       ToastMessageHelper.errorMessageShowToster("HTTP Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("💥 Error during login: $e");
  //     ToastMessageHelper.errorMessageShowToster("Error: $e");
  //   } finally {
  //     loadingLoading(false);
  //   }
  // }







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


  ///----------basic info-----------------
  String? selectedGender;
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? selectedCmFtmLevel;
  String? selectedActivityLevel;
  String? selectedGoal;
  final TextEditingController _currentHeightController = TextEditingController();

  ///-------------basic info-----------------


  ///----------workout-----------------
  String? selectedTrainingLevel;
  String? selectedTrainingLocation;
  String? selectedTrainingDuration;
  String? selectedMuscleGroup;
  String? selectedInjuries;
  String? selectedDays;

  // final Set<int> selectedDays = {};

  ///-------------Meal info-----------------

  String? selectedObjective;
  final Set<int> selectedMeal = {};
  final List<String> meals = [
    'Breakfast'.tr,
    'Snack'.tr,
    'Lunch'.tr,
    'Evening meal'.tr,
    'Dinner'.tr,
  ];

  List<String> get selectedMealsList {
    return selectedMeal.map((index) => meals[index]).toList();
  }

  TextEditingController currentHeightController = TextEditingController();
  TextEditingController objectiveHeightController = TextEditingController();
  String? selectedLbsKgLevel;
  String? objectiveLbsKgLevel;

  ///-------PRotein---------------------
  final List<Map<String, dynamic>> proteinItems = [
    {'icon': AppImages.chicken, 'label': 'Chicken'},
    {'icon': AppImages.beef, 'label': 'Meat'},
    {'icon': AppImages.porkIcon, 'label': 'Pork'},
    {'icon': AppImages.fish, 'label': 'Fish'},
    // Replace with a custom fish icon if needed
    {'icon': AppImages.egg, 'label': 'Egg'},
    // Replace with a custom egg icon if needed
    {'icon': AppImages.soyIcon, 'label': 'Soy'},
  ];
  final Set<int> selectProtien = {};

  List<String> get selectedPortenList {
    return selectProtien
        .map((index) => proteinItems[index]['label'] as String)
        .toList();
  }


  ///-------Vegetables---------------------
  final List<Map<String, dynamic>> vegetablesItems = [
    {'icon': AppImages.brocolli, 'label': 'Vegetables'},
    {'icon': AppImages.lettuce, 'label': 'Lettuce'},
    {'icon': AppImages.Tomato, 'label': 'Tomato'},
    {'icon': AppImages.onion, 'label': 'Onion'},
    // Replace with a custom fish icon if needed
    {'icon': AppImages.carrots, 'label': 'Carrot'},
    // Replace with a custom egg icon if needed
    {'icon': AppImages.Spinach, 'label': 'Spinach'},
  ];
  final Set<int> selectVegetables = {};

  List<String> get selectedVegetablesList {
    return selectVegetables.map((
        index) => vegetablesItems[index]['label'] as String).toList();
  }

  ///-------Carbs---------------------
  final List<Map<String, dynamic>> carbsItems = [
    {'icon': AppImages.rice, 'label': 'Rice'},
    {'icon': AppImages.pasta, 'label': 'Pasta'},
    {'icon': AppImages.Oats, 'label': 'Oats'},
    {'icon': AppImages.ricecookies, 'label': 'Rice cookies'},
    {'icon': AppImages.sweetpotato, 'label': 'Sweet Potato'},
    {'icon': AppImages.potato, 'label': 'Potato'},
  ];
  final Set<int> selectCarbs = {};

  List<String> get selectedCarbsList {
    return selectCarbs
        .map((index) => carbsItems[index]['label'] as String)
        .toList();
  }


  ///-------Fats---------------------
  final List<Map<String, dynamic>> fatsItems = [
    {'icon': AppImages.brocolli, 'label': 'Avocado'},
    {'icon': AppImages.lettuce, 'label': 'Olive Oils'},
    {'icon': AppImages.Tomato, 'label': 'Peanut Butter'},
  ];
  final Set<int> selectFats = {};

  List<String> get selectedFatsList {
    return selectFats
        .map((index) => fatsItems[index]['label'] as String)
        .toList();
  }


  ///-------Dairy---------------------
  final List<Map<String, dynamic>> dairyItems = [
    {'icon': AppImages.milkIcon, 'label': 'Milk'},
    {'icon': AppImages.crudIcon, 'label': 'Yogurd'},
    {'icon': AppImages.cheeseIcon, 'label': 'Cheese'},
  ];
  final Set<int> selectDairy = {};

  List<String> get selectedDairyList {
    return selectDairy
        .map((index) => dairyItems[index]['label'] as String)
        .toList();
  }

  ///-------------Meal info-----------------

  RxBool addMealLoading = false.obs;
  // Future<void> addMealPlanHandle() async {
  //   addMealLoading(true);
  //   String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
  //   String? userIds = await PrefsHelper.getString(AppConstants.userId);
  //   final url = Uri.parse(
  //       '${ApiConstants.baseUrl}${ApiConstants.basicInfo}');
  //   var body = {
  //     "gender": selectedGender,
  //     "age": ageController.text,
  //     "height": {
  //       "value": int.tryParse(heightController.text), // Parse height to integer
  //       "unit": selectedCmFtmLevel,
  //     },
  //     "activityLevel": selectedActivityLevel,
  //     "workoutInformation": {
  //       "fitnessLevel": selectedTrainingLevel,
  //       "trainingLocation": selectedTrainingLocation,
  //       "trainingDuration": selectedTrainingDuration,
  //       "interestMuscleGrow": selectedMuscleGroup,
  //       "injuries": selectedInjuries,
  //       "trainingDay": selectedDays,
  //     },
  //     "mealInformation": {
  //       "objective": selectedObjective,
  //       "dailyMeals": selectedMealsList,
  //       "currentWeight": {
  //         "value": int.tryParse(currentHeightController.text),
  //         "unit": selectedLbsKgLevel
  //       },
  //       "objectiveWeight": {
  //         "value": int.tryParse(objectiveHeightController.text),
  //         "unit": objectiveLbsKgLevel
  //       },
  //       "likeFood": {
  //         "protein": selectedPortenList,
  //         "vegetables": selectedVegetablesList,
  //         "carbs": selectedCarbsList,
  //         "fat": selectedFatsList,
  //         "dairy": selectedDairyList
  //       }
  //     }
  //   };
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $bearerToken'
  //       },
  //       body: json.encode(body),
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final responseData = json.decode(response.body);
  //
  //       if (responseData['success'] == true) {
  //         Get.toNamed(RouteNames.bodyFatScreen, preventDuplicates: false);
  //       }
  //       else {
  //         print("OTP verification failed: ${responseData['message']}");
  //       }
  //     } else {
  //       print("HTTP Error: ${response.statusCode}");
  //       print("Response Body: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("Exception: $e");
  //   } finally {
  //     addMealLoading(false);
  //   }
  // }



  final TextEditingController heightFtController = TextEditingController();
  final TextEditingController heightInController = TextEditingController();


  Future<void> addMealPlanHandle() async {
    addMealLoading(true);
    String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
    String? userIds = await PrefsHelper.getString(AppConstants.userId);
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.basicInfo}');

    // Check if Metric or Imperial
    String unitSystem = selectedCmFtmLevel == "cm" ? "Metric" : "Imperial";

    var body = {
      "unitSystem": unitSystem,
      "gender": selectedGender,
      "age": ageController.text,
      "height": unitSystem == "Metric"
          ? {
        "ft": null,
        "in": null,
        "cm": int.tryParse(heightController.text),
      }
          : {
        "ft": int.tryParse(heightFtController.text),
        "in": int.tryParse(heightInController.text),
        "cm": null,
      },
      "activityLevel": selectedActivityLevel,
      "goal": selectedGoal,
      "currentWeight": unitSystem == "Metric"
          ? {
        "lbs": null,
        "kg": int.tryParse(currentHeightController.text),
      }
          : {
        "lbs": int.tryParse(currentHeightController.text),
        "kg": null,
      },
      "desiredWeight": unitSystem == "Metric"
          ? {
        "lbs": null,
        "kg": int.tryParse(objectiveHeightController.text),
      }
          : {
        "lbs": int.tryParse(objectiveHeightController.text),
        "kg": null,
      },
      "weightLossSpeed": 0.8, // Example: bind your selected speed variable
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          Get.toNamed(RouteNames.bodyFatScreen, preventDuplicates: false);
        } else {
          print("API failed: ${responseData['message']}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      addMealLoading(false);
    }
  }


  ///=============== Basic Info ================
  RxBool basicInfoLoading = false.obs;

  Future<void> addBasicInfoHandle({required bool isMetric}) async {
    basicInfoLoading(true);
    try {
      final token = await PrefsHelper.getString(AppConstants.bearerToken);

      // ✅ Common data
      final body = {
        "unitSystem": isMetric ? "Metric" : "Imperial",
        "activityLevel": selectedActivityLevel,
        "goal": selectedGoal,
        "gender": selectedGender,
        "age": ageController.text.trim(),
        "weightLossSpeed": selectedGoal == "cutting"
            ? 0.8
            : selectedGoal == "bulking"
            ? 1.5
            : 0.5, // Example: can be chosen dynamically
        "height": isMetric
            ? {
          "ft": null,
          "in": null,
          "cm": int.tryParse(heightController.text.trim()),
        }
            : {
          "ft": int.tryParse(heightFtController.text.trim()),
          "in": int.tryParse(heightInController.text.trim()),
          "cm": null,
        },
        "currentWeight": isMetric
            ? {
          "lbs": null,
          "kg": int.tryParse(currentHeightController.text.trim()),
        }
            : {
          "lbs": int.tryParse(currentHeightController.text.trim()),
          "kg": null,
        },
        "desiredWeight": isMetric
            ? {
          "lbs": null,
          "kg": int.tryParse(objectiveHeightController.text.trim()),
        }
            : {
          "lbs": int.tryParse(objectiveHeightController.text.trim()),
          "kg": null,
        },
      };

      print("🟦 Basic Info Request: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.basicInfo}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print("🟩 Response: ${response.statusCode} => ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          ToastMessageHelper.successMessageShowToster(
              "User information added successfully!");
          Get.toNamed(RouteNames.bodyFatScreen);
        } else {
          ToastMessageHelper.errorMessageShowToster(
              data['message'] ?? "Failed to add info");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception: $e");
      ToastMessageHelper.errorMessageShowToster("Error: $e");
    } finally {
      basicInfoLoading(false);
    }
  }


}