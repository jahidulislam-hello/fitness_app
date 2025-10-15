import 'package:get/get.dart';

class MealTrackingController extends GetxController {
  // Date Selection
  var selectedDate = DateTime.now().obs;
  var weekDates = <DateTime>[].obs;

  // Calories Data
  var dailyCalories = 800.obs;
  var dailyCaloriesGoal = 2000.obs;
  var weeklyCalories = 1800.obs;
  var weeklyCaloriesGoal = 3400.obs;

  // Macros Data
  var carbs = 35.obs;
  var carbsGoal = 220.obs;
  var protein = 55.obs;
  var proteinGoal = 165.obs;
  var fat = 65.obs;
  var fatGoal = 73.obs;

  // Water Intake
  var waterIntake = 2.4.obs;
  var waterGoal = 4.0.obs;

  // Meals Data
  var meals = <MealModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _generateWeekDates();
    _loadMeals();
  }

  void _generateWeekDates() {
    weekDates.clear();
    DateTime today = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      weekDates.add(today.subtract(Duration(days: i)));
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    _loadMeals();
  }

  void _loadMeals() {
    meals.value = [
      MealModel(
        name: 'Breakfast',
        calories: 680,
        carbs: 54,
        protein: 90,
        fat: 0,
        isCompleted: false,
      ),
      MealModel(
        name: 'Lunch',
        calories: 700,
        carbs: 63,
        protein: 90,
        fat: 0,
        isCompleted: true,
      ),
      MealModel(
        name: 'Dinner',
        calories: 700,
        carbs: 54,
        protein: 80,
        fat: 3,
        isCompleted: false,
      ),
    ];
  }

  void toggleMealCompletion(int index) {
    meals[index].isCompleted = !meals[index].isCompleted;
    meals.refresh();
  }

  void addNewMeal() {
    Get.toNamed('/add-meal');
  }

  /// ✅ Swipe Actions
  void pinMeal(int index) {
    final meal = meals[index];
    meal.isPinned = true;
    meals.removeAt(index);
    meals.insert(0, meal);
    meals.refresh();
  }

  void deleteMeal(int index) {
    meals.removeAt(index);
    meals.refresh();
  }

  // String Getters
  String get todayDateString {
    DateTime today = DateTime.now();
    return 'Dec-${today.day}';
  }

  String get weekDateRangeString {
    DateTime today = DateTime.now();
    DateTime sevenDaysAgo = today.subtract(Duration(days: 6));
    return 'Dec ${sevenDaysAgo.day}-${today.day}';
  }

  // Progress Calculations
  double get dailyCaloriesPercentage =>
      (dailyCalories.value / dailyCaloriesGoal.value * 100).clamp(0, 100);
  double get weeklyCaloriesPercentage =>
      (weeklyCalories.value / weeklyCaloriesGoal.value * 100).clamp(0, 100);
  double get waterPercentage =>
      (waterIntake.value / waterGoal.value * 100).clamp(0, 100);
  double get carbsPercentage =>
      (carbs.value / carbsGoal.value * 100).clamp(0, 100);
  double get proteinPercentage =>
      (protein.value / proteinGoal.value * 100).clamp(0, 100);
  double get fatPercentage =>
      (fat.value / fatGoal.value * 100).clamp(0, 100);
}


// ==================== MODEL ====================
class MealModel {
  String name;
  int calories;
  int carbs;
  int protein;
  int fat;
  bool isCompleted;
  bool isPinned; // ✅ Added

  MealModel({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.isCompleted = false,
    this.isPinned = false, // ✅ Default false
  });
}
