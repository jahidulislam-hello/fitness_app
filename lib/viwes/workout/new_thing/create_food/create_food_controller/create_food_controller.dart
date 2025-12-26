// Controller Class
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateFoodController extends GetxController {
  final nameController = TextEditingController();
  final servingWeightController = TextEditingController(text: '150g');
  final caloriesController = TextEditingController(text: '350 kCal');
  final carbsController = TextEditingController(text: '350 Cal');
  final proteinController = TextEditingController(text: '350 Cal');
  final fatController = TextEditingController(text: '350 Cal');

  @override
  void onClose() {
    nameController.dispose();
    servingWeightController.dispose();
    caloriesController.dispose();
    carbsController.dispose();
    proteinController.dispose();
    fatController.dispose();
    super.onClose();
  }

  void addFood() {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a food name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Handle food creation logic here
    print('Food Name: ${nameController.text}');
    print('Serving Weight: ${servingWeightController.text}');
    print('Calories: ${caloriesController.text}');
    print('Carbs: ${carbsController.text}');
    print('Protein: ${proteinController.text}');
    print('Fat: ${fatController.text}');

    Get.back(); // Close the popup
    Get.snackbar(
      'Success',
      'Food added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}