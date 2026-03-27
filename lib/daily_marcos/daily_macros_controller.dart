// import 'package:get/get.dart';
//
// class DailyMacroController extends GetxController {
//
//   /// Base Calories
//   final calories = 2200.obs;
//
//   /// Macro grams
//   final carbsGram = 350.0.obs;
//   final proteinGram = 350.0.obs;
//   final fatGram = 350.0.obs;
//
//   /// Percentages
//   final carbsPercent = 35.0.obs;
//   final proteinPercent = 35.0.obs;
//   final fatPercent = 35.0.obs;
//
//   void calculateMacros() {
//     // Example macro calculation logic
//     carbsPercent.value =
//         ((carbsGram.value * 4) / calories.value * 100).clamp(0, 100);
//     proteinPercent.value =
//         ((proteinGram.value * 4) / calories.value * 100).clamp(0, 100);
//     fatPercent.value =
//         ((fatGram.value * 9) / calories.value * 100).clamp(0, 100);
//   }
//
//   void done() {
//     Get.back();
//   }
// }