import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/workout/new_thing/create_food/create_food_controller/create_food_controller.dart';


// UI Widget
class CreateFoodPopup extends StatelessWidget {
  const CreateFoodPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateFoodController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Create Food',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            _buildInputField(
              label: 'Name',
              controller: controller.nameController,
              hintText: '',
            ),
            const SizedBox(height: 20),

            // Serving Weight Field
            _buildInputField(
              label: 'Serving weight',
              controller: controller.servingWeightController,
            ),
            const SizedBox(height: 20),

            // Calories Field
            _buildInputField(
              label: 'Calories',
              controller: controller.caloriesController,
            ),
            const SizedBox(height: 20),

            // Carbs Field
            _buildInputField(
              label: 'Carbs',
              controller: controller.carbsController,
            ),
            const SizedBox(height: 20),

            // Protein Field
            _buildInputField(
              label: 'Protein',
              controller: controller.proteinController,
            ),
            const SizedBox(height: 20),

            // Fat Field
            _buildInputField(
              label: 'Fat',
              controller: controller.fatController,
            ),

            const Spacer(),

            // Add Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.addFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add In Food',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// Usage Example:
// To show this popup, use:
// Get.to(() => const CreateFoodPopup());
// or
// Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateFoodPopup()));