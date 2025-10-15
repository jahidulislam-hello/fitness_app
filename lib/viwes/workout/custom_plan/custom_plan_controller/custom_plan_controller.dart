import 'package:get/get.dart';

class CustomPlanController extends GetxController {
  // Example data (you can set dynamically)
  var weightLoss = "6 kg".obs;
  var targetDate = "September 12".obs;

  // Macro values (can be fetched/calculated from backend)
  var calories = 800.obs;
  var protein = 800.obs;
  var carbs = 800.obs;
  var fat = 800.obs;
}
