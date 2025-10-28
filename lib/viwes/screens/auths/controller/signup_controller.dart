//
// class SignUpController extends GetxController {
//   final TextEditingController loginEmailTEController = TextEditingController();
//   final TextEditingController loginPassTEController = TextEditingController();
//
//   RxBool loadingLoading = false.obs;
//
//
// Future<void> signUpHandle() async {
//   signUpLoading(true);
//   try {
//     var headers = {'Content-Type': 'application/json'};
//     var body = {
//       "name": nameTEController.text,
//       "email": emailTEController.text,
//       "password": passTEController.text,
//       "confirmPassword": confirmPassTEController.text,
//     };
//
//     var response = await ApiClient.postData(
//       ApiConstants.signUpEndPoint,
//       jsonEncode(body),
//       headers: headers,
//     );
//     print("Signup Response: ${response.body}");
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//
//       // ✅ Save token if available
//       if (data['data'] != null && data['data']['token'] != null) {
//         await PrefsHelper.setString(
//           AppConstants.bearerToken,
//           data['data']['token'],
//         );
//       }
//
//       ToastMessageHelper.successMessageShowToster(
//         "Account created successfully!",
//       );
//
//       // ✅ Go directly to basic info screen
//       Get.toNamed(RouteNames.basicInformation);
//     } else {
//       final err = jsonDecode(response.body);
//       ToastMessageHelper.errorMessageShowToster(
//         err['message'] ?? "Signup failed",
//       );
//     }
//   } catch (e) {
//     ToastMessageHelper.errorMessageShowToster("Error: $e");
//   } finally {
//     signUpLoading(false);
//   }
// }
