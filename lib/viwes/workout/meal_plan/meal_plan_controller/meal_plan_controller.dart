import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_tracking_api.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/add_meal_popup.dart';
import 'package:intl/intl.dart';

class MealTrackingController extends GetxController {
  final MealApiService _apiService = MealApiService();

  // Loading states
  var isLoading = false.obs;
  var isAddingMeal = false.obs;

  // Date Selection
  var selectedDate = DateTime.now().obs;
  var weekDates = <DateTime>[].obs;

  // Calories Data
  var dailyCalories = 0.0.obs;
  var dailyCaloriesGoal = 2000.0.obs;
  var weeklyCalories = 0.0.obs;
  var weeklyCaloriesGoal = 3400.0.obs;

  // Macros Data
  var carbs = 0.0.obs;
  var carbsGoal = 220.0.obs;
  var protein = 0.0.obs;
  var proteinGoal = 165.0.obs;
  var fat = 0.0.obs;
  var fatGoal = 73.0.obs;

  // Water Intake
  var waterIntake = 0.0.obs;
  var waterGoal = 4.0.obs;

  // Meals Data
  var meals = <MealModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _generateWeekDates();
    loadMealsFromAPI();
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
    loadMealsFromAPI();
  }

  // Format date for API (YYYY-MM-DD)
  String _formatDateForAPI(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// ✅ Load Meals from API
  Future<void> loadMealsFromAPI() async {
    try {
      isLoading.value = true;

      final dateString = _formatDateForAPI(selectedDate.value);
      print('📅 Selected Date Object: ${selectedDate.value}');
      print('📅 Formatted Date String: $dateString');
      print('📅 Loading meals for date: $dateString');

      final response = await _apiService.getAllMeals(
        foodType: "",
        date: dateString,
      );

      print('🔍 API Response Success: ${response['success']}');
      print('📋 Response Message: ${response['message']}');
      print('📦 Data length: ${response['data']?.length ?? 0}');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List;
        print('✅ Data received, parsing...');
        _parseMealsData(data);
      } else {
        print('⚠️ No data or unsuccessful response');
        _clearMealData();
      }
    } catch (e) {
      print('❌ Error in loadMealsFromAPI: $e');
      Get.snackbar(
        'Error',
        'Failed to load meals: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
      print('🏁 Loading complete. Total meals: ${meals.length}');
    }
  }

  /// ✅ Parse API Response - FIXED to handle multiple dates in response
  void _parseMealsData(List<dynamic> data) {
    meals.clear();
    if (data.isEmpty) return;
    final selectedDateString = _formatDateForAPI(selectedDate.value);
    print('🔍 Looking for meal plan with date: $selectedDateString');
    Map<String, dynamic>? matchingMealPlan;
    for (var item in data) {
      if (item is Map && item.containsKey('date')) {
        final itemDate = item['date'] as String;
        final itemDateOnly = itemDate.split('T')[0];
        print('📅 Checking meal plan date: $itemDateOnly');
        if (itemDateOnly == selectedDateString) {
          matchingMealPlan = Map<String, dynamic>.from(item);
          print('✅ Found matching meal plan!');
          break;
        }
      }
    }

    // If no matching date found, clear and return
    if (matchingMealPlan == null) {
      print('⚠️ No meal plan found for $selectedDateString');
      _clearMealData();

      // Get weekly calories (always last item in array)
      if (data.isNotEmpty && data.last is Map && data.last.containsKey('totalLast7DaysCalories')) {
        weeklyCalories.value = _toDouble(data.last['totalLast7DaysCalories']);
        print('📊 Weekly Calories: ${weeklyCalories.value}');
      }

      return;
    }

    // Parse the matching meal plan
    final macrosData = matchingMealPlan['macrosValue'];
    if (macrosData != null) {
      dailyCalories.value = _toDouble(macrosData['calories']);
      carbs.value = _toDouble(macrosData['carbs']);
      protein.value = _toDouble(macrosData['protein']);
      fat.value = _toDouble(macrosData['fat']);
      waterIntake.value = _toDouble(macrosData['waterIntake']);
    }

    // Get weekly calories (last item in array)
    if (data.isNotEmpty && data.last is Map && data.last.containsKey('totalLast7DaysCalories')) {
      weeklyCalories.value = _toDouble(data.last['totalLast7DaysCalories']);
    }

    // Parse meals array
    final mealsData = matchingMealPlan['meals'] as List<dynamic>?;
    if (mealsData != null && mealsData.isNotEmpty) {
      for (var mealData in mealsData) {
        final timeName = mealData['timeName'] ?? '';
        final foodsList = mealData['foods'] as List<dynamic>?;

        if (foodsList != null && foodsList.isNotEmpty) {
          // Calculate total nutrition for this meal time
          double totalCalories = 0.0;
          double totalCarbs = 0.0;
          double totalProtein = 0.0;
          double totalFat = 0.0;

          for (var food in foodsList) {
            final nutrition = food['nutritionValue'];
            if (nutrition != null) {
              totalCalories += _toDouble(nutrition['calories']);
              totalCarbs += _toDouble(nutrition['carbs']);
              totalProtein += _toDouble(nutrition['protein']);
              totalFat += _toDouble(nutrition['fat']);
            }
          }

          // Only add if there's actual data
          if (totalCalories > 0 || totalCarbs > 0 || totalProtein > 0 || totalFat > 0) {
            meals.add(MealModel(
              name: _capitalizeTimeName(timeName),
              calories: totalCalories,
              carbs: totalCarbs,
              protein: totalProtein,
              fat: totalFat,
              isCompleted: false,
              isPinned: false,
              mealId: mealData['_id'],
              foods: foodsList,
            ));
          }
        }
      }
    }

    // Debug print to check if meals were parsed
    print('📊 Parsed ${meals.length} meals');
    print('🔢 Daily Calories: ${dailyCalories.value}');
    print('🥗 Carbs: ${carbs.value}, Protein: ${protein.value}, Fat: ${fat.value}');

    meals.refresh();
  }

  // Helper methods for type conversion
  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper to clear all meal data
  void _clearMealData() {
    meals.clear();
    dailyCalories.value = 0.0;
    carbs.value = 0.0;
    protein.value = 0.0;
    fat.value = 0.0;
    waterIntake.value = 0.0;
    meals.refresh();
    print('🧹 Cleared all meal data');
  }

  String _formatDateForDisplay(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _capitalizeTimeName(String timeName) {
    if (timeName.isEmpty) return timeName;
    return timeName[0].toUpperCase() + timeName.substring(1);
  }

  /// ✅ Add New Meal via API
  Future<void> addNewMealToAPI({
    required String foodName,
    required String quantity,
    required String serving,
    required String timeName,
    required Map<String, dynamic> nutritionValue,
    String foodType = "food",
  }) async {
    try {
      isAddingMeal.value = true;

      final dateString = _formatDateForAPI(selectedDate.value);

      final response = await _apiService.addFood(
        foodName: foodName,
        quantity: quantity,
        serving: serving,
        timeName: timeName.toLowerCase(),
        date: dateString,
        foodType: foodType,
        nutritionValue: nutritionValue,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Meal added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Reload meals to show updated data
        await loadMealsFromAPI();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add meal: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isAddingMeal.value = false;
    }
  }

  void toggleMealCompletion(int index) {
    meals[index].isCompleted = !meals[index].isCompleted;
    meals.refresh();
  }

  void addNewMeal(BuildContext context) {
    final dateString = _formatDateForAPI(selectedDate.value);
    showDialog(
      context: context,
      builder: (context) => AddMealPopup(selectedDate: dateString),
      barrierDismissible: true,
    );
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
    // TODO: Implement delete API call if available
    meals.removeAt(index);
    meals.refresh();

    Get.snackbar(
      'Deleted',
      'Meal removed',
      snackPosition: SnackPosition.BOTTOM,
    );
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
  double calories;
  double carbs;
  double protein;
  double fat;
  bool isCompleted;
  bool isPinned;
  String? mealId;
  List<dynamic>? foods;

  MealModel({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.isCompleted = false,
    this.isPinned = false,
    this.mealId,
    this.foods,
  });
}