import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_plan_controller/meal_plan_controller.dart';

class AddMealScreen extends StatelessWidget {
  AddMealScreen({super.key});

  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(text: "1");
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController fatController = TextEditingController();

  final RxString selectedServing = 'large'.obs;
  final RxString selectedTimeName = 'breakfast'.obs;
  final RxString selectedFoodType = 'food'.obs;

  final List<String> servings = ['small', 'medium', 'large'];
  final List<String> timeNames = ['breakfast', 'lunch', 'dinner'];
  final List<String> foodTypes = ['food', 'recipe'];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MealTrackingController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Add New Meal',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Name
              _buildTextField(
                controller: foodNameController,
                label: 'Food Name',
                hint: 'Enter food name',
              ),
              SizedBox(height: 16.h),

              // Quantity
              _buildTextField(
                controller: quantityController,
                label: 'Quantity',
                hint: 'Enter quantity',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),

              // Serving Dropdown
              _buildDropdown(
                label: 'Serving',
                value: selectedServing,
                items: servings,
              ),
              SizedBox(height: 16.h),

              // Time Name Dropdown
              _buildDropdown(
                label: 'Meal Time',
                value: selectedTimeName,
                items: timeNames,
              ),
              SizedBox(height: 16.h),

              // Food Type Dropdown
              _buildDropdown(
                label: 'Food Type',
                value: selectedFoodType,
                items: foodTypes,
              ),
              SizedBox(height: 24.h),

              // Nutrition Values Section
              Text(
                'Nutrition Values',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),

              // Calories
              _buildTextField(
                controller: caloriesController,
                label: 'Calories',
                hint: 'Enter calories',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.h),

              // Protein
              _buildTextField(
                controller: proteinController,
                label: 'Protein (g)',
                hint: 'Enter protein',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.h),

              // Carbs
              _buildTextField(
                controller: carbsController,
                label: 'Carbs (g)',
                hint: 'Enter carbs',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.h),

              // Fat
              _buildTextField(
                controller: fatController,
                label: 'Fat (g)',
                hint: 'Enter fat',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 32.h),

              // Submit Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isAddingMeal.value
                      ? null
                      : () => _submitMeal(controller),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF93533),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: controller.isAddingMeal.value
                      ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    'Add Meal',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required RxString value,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButton<String>(
            value: value.value,
            isExpanded: true,
            underline: SizedBox(),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item[0].toUpperCase() + item.substring(1),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                value.value = newValue;
              }
            },
          ),
        )),
      ],
    );
  }

  void _submitMeal(MealTrackingController controller) {
    // Validation
    if (foodNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter food name');
      return;
    }

    if (quantityController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter quantity');
      return;
    }

    if (caloriesController.text.trim().isEmpty ||
        proteinController.text.trim().isEmpty ||
        carbsController.text.trim().isEmpty ||
        fatController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter all nutrition values');
      return;
    }

    // Parse nutrition values
    final nutritionValue = {
      "calories": double.tryParse(caloriesController.text) ?? 0,
      "protein": double.tryParse(proteinController.text) ?? 0,
      "fat": double.tryParse(fatController.text) ?? 0,
      "carbs": double.tryParse(carbsController.text) ?? 0,
    };

    // Call API
    controller.addNewMealToAPI(
      foodName: foodNameController.text.trim(),
      quantity: quantityController.text.trim(),
      serving: selectedServing.value,
      timeName: selectedTimeName.value,
      nutritionValue: nutritionValue,
      foodType: selectedFoodType.value,
    ).then((_) {
      // Success - go back
      Get.back();
    });
  }
}