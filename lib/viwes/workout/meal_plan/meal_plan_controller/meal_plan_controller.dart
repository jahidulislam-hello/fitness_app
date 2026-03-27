import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_tracking_api.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/add_meal_popup.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_constants.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_type_selector.dart';
import 'package:gym_cheloper/viwes/workout/calender_Strek/calender_strek.dart';
import 'package:gym_cheloper/viwes/workout/calender_Strek/calorieStrekCounter.dart';
import 'package:intl/intl.dart';

class MealTrackingController extends GetxController {
  final MealApiService _apiService = MealApiService();

  // Calendar and Streak Controllers
  late CalendarStreakController calendarStreakController;
  late CalorieStreakController calorieStreakController;

  // Loading states
  var isLoading = false.obs;
  var isAddingMeal = false.obs;

  // Date Selection
  var selectedDate = DateTime.now().obs;
  var weekDates = <DateTime>[].obs;

  // Track dates that have meal data
  var datesWithMealData = <String>[].obs;

  // Calories Data
  var dailyCalories = 0.0.obs;
  var dailyCaloriesGoal = 2200.0.obs;
  var weeklyCalories = 0.0.obs;
  var weeklyCaloriesGoal = 15400.0.obs;

  // Streak Status
  var streakStatusColor = 'red'.obs;

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
    // Initialize calendar and streak controllers
    calendarStreakController = CalendarStreakController();
    calorieStreakController = CalorieStreakController();
    _generateWeekDates();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadWeekMealDataStatus();
    await loadMacrosWaterIntake();
    await loadMealsFromAPI();
  }

  @override
  void onClose() {
    calendarStreakController.dispose();
    calorieStreakController.dispose();
    super.onClose();
  }

  void _generateWeekDates({DateTime? centerDate}) {
    weekDates.clear();
    DateTime center = centerDate ?? DateTime.now();

    // Generate dates: 3 days before center, center, 3 days after center
    for (int i = -3; i <= 3; i++) {
      weekDates.add(center.add(Duration(days: i)));
    }
  }

  /// Load meal data status for all dates from API
  Future<void> loadWeekMealDataStatus() async {
    try {
      // Load ALL meals without date filter to get all dates with meal data
      final response = await _apiService.getAllMeals(
        foodType: "",
        // No date parameter - get all meals
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List;

        // Clear and rebuild the list
        List<String> newDates = [];

        for (var item in data) {
          if (item is Map && item.containsKey('date')) {
            final itemDate = item['date'] as String;
            // Handle both ISO format (with T) and YYYY-MM-DD format
            final itemDateOnly = itemDate.contains('T') ? itemDate.split('T')[0] : itemDate;

            // Add date if it has a meal plan entry with non-empty foods array or calories > 0
            bool hasValidMeal = false;
            
            // Check if this item has meals with foods
            final mealsList = item['meals'] as List<dynamic>?;
            if (mealsList != null && mealsList.isNotEmpty) {
              for (var meal in mealsList) {
                final foods = meal['foods'] as List<dynamic>?;
                if (foods != null && foods.isNotEmpty) {
                  hasValidMeal = true;
                  break;
                }
              }
            }
            
            // Also check if macros have calories
            final macrosData = item['macrosValue'];
            if (macrosData != null) {
              final calories = _toDouble(macrosData['calories']);
              if (calories > 0) {
                hasValidMeal = true;
              }
            }

            // Add date if it has valid meal data
            if (hasValidMeal && !newDates.contains(itemDateOnly)) {
              newDates.add(itemDateOnly);
              print('✅ Added date with meal data: $itemDateOnly');
            }
          }
        }

        // Update the reactive list
        datesWithMealData.value = newDates;
        datesWithMealData.refresh(); // Force UI refresh

        print('📅 All dates with meal data: ${datesWithMealData.toList()}');
        print('📆 Current week dates: ${weekDates.map((d) => _formatDateForAPI(d)).toList()}');

        // Check which week dates have meal data
        for (var date in weekDates) {
          final dateStr = _formatDateForAPI(date);
          final hasMeal = datesWithMealData.contains(dateStr);
          print('📍 Date $dateStr has meal data: $hasMeal');
        }
      }
    } catch (e) {
      print('❌ Error loading week meal status: $e');
    }
  }

  /// Check if a date has meal data
  bool dateHasMealData(DateTime date) {
    final dateString = _formatDateForAPI(date);
    final result = datesWithMealData.contains(dateString);
    print('🔍 Checking date $dateString has meal: $result');
    return result;
  }

  /// ✅ Load Macros and Water Intake from API
  Future<void> loadMacrosWaterIntake() async {
    try {
      final dateString = _formatDateForAPI(selectedDate.value);
      print('💧 Loading macros & water intake for date: $dateString');

      final response = await _apiService.getMacrosWaterIntake(date: dateString);

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List;
        if (data.isNotEmpty) {
          final macrosData = data[0]['macrosValue'];
          if (macrosData != null) {
            waterIntake.value = _toDouble(macrosData['waterIntake']);
            print('✅ Water intake loaded: ${waterIntake.value}L');
          }
        }
      }
    } catch (e) {
      print('❌ Error loading macros & water intake: $e');
      // Don't show error - water intake will default to 0
    }
  }

  Future<void> selectDate(DateTime date) async {
    selectedDate.value = date;

    // Check if selected date is in current week view
    bool isInCurrentWeek = weekDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);

    // If not in current week, regenerate week dates centered on selected date
    if (!isInCurrentWeek) {
      _generateWeekDates(centerDate: date);
      // Reload meal data status for the new week
      await loadWeekMealDataStatus();
    }

    // Reload water intake for the selected date
    await loadMacrosWaterIntake();
    // Reload meals for the selected date (this also updates weekly calories)
    await loadMealsFromAPI();
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

    // Reset macros to 0
    dailyCalories.value = 0.0;
    carbs.value = 0.0;
    protein.value = 0.0;
    fat.value = 0.0;
    waterIntake.value = 0.0;
    weeklyCalories.value = 0.0;

    if (data.isEmpty) {
      _showDefaultMealsWithZeroValues();
      return;
    }

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

    // Get weekly calories and streak status (always last item in array)
    if (data.isNotEmpty && data.last is Map && data.last.containsKey('totalLast7DaysCalories')) {
      weeklyCalories.value = _toDouble(data.last['totalLast7DaysCalories']);
      streakStatusColor.value = data.last['streakStatusColor'] ?? 'red';
      print('📊 Weekly Calories: ${weeklyCalories.value}');
      print('🔥 Streak Status Color: ${streakStatusColor.value}');
    }

    // If no matching date found, show default meals with 0 values
    if (matchingMealPlan == null) {
      print('⚠️ No meal plan found for $selectedDateString');
      _showDefaultMealsWithZeroValues();
      return;
    }

    // Parse the matching meal plan macros
    final macrosData = matchingMealPlan['macrosValue'];
    if (macrosData != null) {
      dailyCalories.value = _toDouble(macrosData['calories']);
      carbs.value = _toDouble(macrosData['carbs']);
      protein.value = _toDouble(macrosData['protein']);
      fat.value = _toDouble(macrosData['fat']);
      waterIntake.value = _toDouble(macrosData['waterIntake']);

      print('📊 Macros - Cal: ${dailyCalories.value}, Carbs: ${carbs.value}, Protein: ${protein.value}, Fat: ${fat.value}');
    }

    // Track which default meal types have data
    Set<String> mealsWithData = {};

    // Parse meals array
    final mealsData = matchingMealPlan['meals'] as List<dynamic>?;
    if (mealsData != null && mealsData.isNotEmpty) {
      for (var mealData in mealsData) {
        final timeName = mealData['timeName'] ?? '';
        final capitalizedTimeName = _capitalizeTimeName(timeName);
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

          // Add meal with data
          meals.add(MealModel(
            name: capitalizedTimeName,
            calories: totalCalories,
            carbs: totalCarbs,
            protein: totalProtein,
            fat: totalFat,
            isCompleted: false,
            isPinned: false,
            mealId: mealData['_id'],
            foods: foodsList,
            isDefaultMealType: _isDefaultMealType(capitalizedTimeName),
          ));

          mealsWithData.add(capitalizedTimeName);
        }
      }
    }

    // Add default meal types that don't have data yet (Breakfast, Lunch, Dinner with 0 values)
    for (var defaultMealName in MealConstants.defaultMealTypes) {
      if (!mealsWithData.contains(defaultMealName)) {
        meals.add(MealModel(
          name: defaultMealName,
          calories: 0.0,
          carbs: 0.0,
          protein: 0.0,
          fat: 0.0,
          isCompleted: false,
          isPinned: false,
          isDefaultMealType: true,
        ));
      }
    }

    // Sort meals: pinned first, then Breakfast, Lunch, Dinner, then others
    meals.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;

      final orderA = _getMealTypeOrder(a.name);
      final orderB = _getMealTypeOrder(b.name);

      return orderA.compareTo(orderB);
    });

    print('📊 Parsed ${meals.length} meals');
    print('🔢 Daily Calories: ${dailyCalories.value}');
    print('🥗 Carbs: ${carbs.value}, Protein: ${protein.value}, Fat: ${fat.value}');

    meals.refresh();
  }

  /// Helper to check if a meal name is a default meal type
  bool _isDefaultMealType(String mealName) {
    return MealConstants.defaultMealTypes.contains(mealName);
  }

  /// Helper to get meal type order for sorting
  int _getMealTypeOrder(String mealName) {
    switch (mealName) {
      case 'Breakfast':
        return 1;
      case 'Lunch':
        return 2;
      case 'Dinner':
        return 3;
      default:
        return 4; // Other meals come after default ones
    }
  }

  /// Show default meals (Breakfast, Lunch, Dinner) with 0 values
  void _showDefaultMealsWithZeroValues() {
    meals.clear();
    for (var defaultMealName in MealConstants.defaultMealTypes) {
      meals.add(MealModel(
        name: defaultMealName,
        calories: 0.0,
        carbs: 0.0,
        protein: 0.0,
        fat: 0.0,
        isCompleted: false,
        isPinned: false,
        isDefaultMealType: true,
      ));
    }
    meals.refresh();
    print('📋 Showing default meals with 0 values');
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

  // Helper to load default meals when no API data
  void _clearMealData() {
    // Show default meals with 0 values
    _showDefaultMealsWithZeroValues();
    print('🧹 No API data - showing default meals with 0 values');
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
        // Refresh meal data status for week dates
        await loadWeekMealDataStatus();
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
    showMealTypeSelector(context, dateString);
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
    final meal = meals[index];

    // ✅ Prevent deletion of default meal types (Breakfast, Lunch, Dinner)
    if (meal.isDefaultMealType) {
      Get.snackbar(
        'Cannot Delete',
        '${meal.name} is a default meal type and cannot be deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[900],
        duration: Duration(seconds: 2),
      );
      return;
    }

    // TODO: Implement delete API call if available
    meals.removeAt(index);
    meals.refresh();

    Get.snackbar(
      'Deleted',
      'Meal removed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// ✅ Water Intake Methods
  /// Increment water intake by 1L
  Future<void> incrementWaterIntake() async {
    try {
      // Optimistically update UI
      waterIntake.value += 1.0;

      // Call API to save with full macrosValue object
      final dateString = _formatDateForAPI(selectedDate.value);
      final macrosValue = {
        "calories": dailyCalories.value,
        "carbs": carbs.value,
        "protein": protein.value,
        "fat": fat.value,
        "waterIntake": waterIntake.value,
      };

      final response = await _apiService.addWaterIntake(
        date: dateString,
        macrosValue: macrosValue,
      );

      if (response['success'] == true) {
        // Update from API response to ensure consistency
        final responseData = response['data']?['macrosValue'];
        if (responseData != null) {
          waterIntake.value = _toDouble(responseData['waterIntake']);
        }

        print('✅ Water intake incremented: ${waterIntake.value}L');
      }
    } catch (e) {
      // Revert on error
      waterIntake.value -= 1.0;
      print('❌ Error incrementing water intake: $e');
      Get.snackbar(
        'Error',
        'Failed to update water intake',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: Duration(seconds: 2),
      );
    }
  }

  /// Decrement water intake by 1L
  Future<void> decrementWaterIntake() async {
    // Don't allow negative values
    if (waterIntake.value <= 0) {
      return;
    }

    try {
      // Optimistically update UI
      waterIntake.value -= 1.0;

      // Call API to save with full macrosValue object
      final dateString = _formatDateForAPI(selectedDate.value);
      final macrosValue = {
        "calories": dailyCalories.value,
        "carbs": carbs.value,
        "protein": protein.value,
        "fat": fat.value,
        "waterIntake": waterIntake.value,
      };

      final response = await _apiService.addWaterIntake(
        date: dateString,
        macrosValue: macrosValue,
      );

      if (response['success'] == true) {
        // Update from API response to ensure consistency
        final responseData = response['data']?['macrosValue'];
        if (responseData != null) {
          waterIntake.value = _toDouble(responseData['waterIntake']);
        }

        print('✅ Water intake decremented: ${waterIntake.value}L');
      }
    } catch (e) {
      // Revert on error
      waterIntake.value += 1.0;
      print('❌ Error decrementing water intake: $e');
      Get.snackbar(
        'Error',
        'Failed to update water intake',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: Duration(seconds: 2),
      );
    }
  }

  // String Getters - use selected date
  String get todayDateString {
    final date = selectedDate.value;
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]}-${date.day}';
  }

  String get weekDateRangeString {
    final date = selectedDate.value;
    final sevenDaysAgo = date.subtract(Duration(days: 6));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    // If same month
    if (date.month == sevenDaysAgo.month) {
      return '${months[date.month - 1]} ${sevenDaysAgo.day}-${date.day}';
    } else {
      // Different months
      return '${months[sevenDaysAgo.month - 1]} ${sevenDaysAgo.day}-${months[date.month - 1]} ${date.day}';
    }
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
  bool isDefaultMealType;
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
    this.isDefaultMealType = false,
    this.mealId,
    this.foods,
  });
}