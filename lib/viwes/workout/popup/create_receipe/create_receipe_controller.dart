import 'package:flutter/material.dart';

class FoodItem {
  final String id;
  String name;
  String quantity;
  String unit;

  FoodItem({
    required this.id,
    this.name = '',
    this.quantity = '',
    this.unit = '',
  });
}

class CreateRecipeController extends ChangeNotifier {
  final TextEditingController recipeNameController = TextEditingController();
  final List<FoodItem> foodItems = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String get recipeName => recipeNameController.text.trim();

  bool get isValid =>
      recipeName.isNotEmpty && foodItems.isNotEmpty;

  void addFoodItem() {
    foodItems.add(
      FoodItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );
    notifyListeners();
  }

  void removeFoodItem(String id) {
    foodItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateFoodItemName(String id, String name) {
    final item = foodItems.firstWhere((f) => f.id == id);
    item.name = name;
    notifyListeners();
  }

  void updateFoodItemQuantity(String id, String quantity) {
    final item = foodItems.firstWhere((f) => f.id == id);
    item.quantity = quantity;
    notifyListeners();
  }

  void updateFoodItemUnit(String id, String unit) {
    final item = foodItems.firstWhere((f) => f.id == id);
    item.unit = unit;
    notifyListeners();
  }

  Future<void> saveRecipe({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    if (!isValid) {
      onError('Please enter a recipe name and add at least one food item.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Replace with actual save logic
      debugPrint('Recipe saved: $recipeName');
      debugPrint('Food items: ${foodItems.map((f) => f.name).toList()}');

      onSuccess();
    } catch (e) {
      onError('Failed to save recipe. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    recipeNameController.clear();
    foodItems.clear();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    recipeNameController.dispose();
    super.dispose();
  }
}