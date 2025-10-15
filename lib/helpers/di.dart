import 'dart:convert'; // ✅ ADD THIS
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/controllers.dart';
import '../models/language_model.dart';
import '../utils/utils.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  // Repository
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};

  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');

    // ✅ Use jsonDecode() from dart:convert
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);

    // ✅ Properly initialize json before using
    Map<String, String> jsonMap = {};
    mappedJson.forEach((key, value) {
      jsonMap[key] = value.toString();
    });

    // ✅ Assign to languages map
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        jsonMap;
  }

  return languages;
}
// import 'package:flutter/services.dart';

























// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../controller/controllers.dart';
// import '../models/language_model.dart';
// import '../utils/utils.dart';
// import 'dart:convert';
//
// Future<Map<String, Map<String, String>>> init() async {
//   // Core
//   final sharedPreferences = await SharedPreferences.getInstance();
//   Get.lazyPut(() => sharedPreferences);
//
//   // Repository
//
//   Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
//
//   //Retrieving localized data
//   Map<String, Map<String, String>> languages = {};
//   for (LanguageModel languageModel in AppConstants.languages) {
//     String jsonStringValues = await rootBundle
//         .loadString('assets/language/${languageModel.languageCode}.json');
//     Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
//     Map<String, String> json = {};
//     mappedJson.forEach((key, value) {
//       json[key] = value.toString();
//     });
//     languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
//         json;
//   }
//   return languages;
// }
