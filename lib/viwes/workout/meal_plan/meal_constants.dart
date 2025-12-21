import 'package:gym_cheloper/viwes/workout/meal_plan/meal_plan_controller/meal_plan_controller.dart';

/// Default meal types - Only show Breakfast, Lunch, Dinner as dummy data
/// Other meals (Snack 1, Snack 2, etc.) will only show when added via API
class MealConstants {
  static List<MealModel> getDefaultMeals() {
    return [
      MealModel(
        name: 'Breakfast',
        calories: 680,
        carbs: 54,
        protein: 90,
        fat: 13,
        isCompleted: false,
      ),
      MealModel(
        name: 'Lunch',
        calories: 300,
        carbs: 63,
        protein: 90,
        fat: 10,
        isCompleted: false,
      ),
      MealModel(
        name: 'Dinner',
        calories: 400,
        carbs: 54,
        protein: 80,
        fat: 3,
        isCompleted: false,
      ),
    ];
  }

  /// Meal type names
  static const String breakfast = 'Breakfast';
  static const String lunch = 'Lunch';
  static const String dinner = 'Dinner';

  /// Default meal type names (only these show by default)
  static const List<String> defaultMealTypes = [
    breakfast,
    lunch,
    dinner,
  ];
}
