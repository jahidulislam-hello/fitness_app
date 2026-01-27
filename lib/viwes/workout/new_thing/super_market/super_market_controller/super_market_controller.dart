
// Model Class
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodItem {
  final String id;
  final String name;
  final String weight;
  bool isChecked;

  FoodItem({
    required this.id,
    required this.name,
    required this.weight,
    this.isChecked = true,
  });
}

// Controller Class
class SupermarketListController extends GetxController {
  final RxList<FoodItem> foodItems = <FoodItem>[
    FoodItem(id: '1', name: 'Beef', weight: '150g'),
    FoodItem(id: '2', name: 'Beef', weight: '150g'),
    FoodItem(id: '3', name: 'Beef', weight: '150g'),
    FoodItem(id: '4', name: 'Beef', weight: '150g'),
  ].obs;

  void toggleCheckbox(int index) {
    foodItems[index].isChecked = !foodItems[index].isChecked;
    foodItems.refresh();
  }

  void deleteItem(int index) {
    foodItems.removeAt(index);
  }

  void addNewFood() {
    // Navigate to Create Food screen
    Get.snackbar(
      'Add New Food',
      'Navigate to Create Food screen',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
    // Get.to(() => const CreateFoodPopup());
  }

  void searchInLibrary() {
    Get.snackbar(
      'Search',
      'Opening food library...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}