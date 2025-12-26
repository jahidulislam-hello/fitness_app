import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodPopup extends StatefulWidget {
  final String foodName;
  final double baseCalories;
  final double baseProtein;
  final double baseCarbs;
  final double baseFat;
  final String initialServing;
  final String initialQuantity;
  final Function({
    required String foodName,
    required String quantity,
    required String serving,
    required String timeName,
    required Map<String, dynamic> nutritionValue,
  }) onAddFood;

  const FoodPopup({
    super.key,
    required this.foodName,
    required this.baseCalories,
    required this.baseProtein,
    required this.baseCarbs,
    required this.baseFat,
    required this.initialServing,
    required this.initialQuantity,
    required this.onAddFood,
  });

  @override
  State<FoodPopup> createState() => _FoodPopupState();
}

class _FoodPopupState extends State<FoodPopup> {
  late TextEditingController quantityController;
  late TextEditingController servingController;
  String selectedMealTime = 'breakfast';
  final mealTimes = ['breakfast', 'lunch', 'dinner', 'snack'];
  bool isFavorite = false;

  // Calculated nutrition values
  double calculatedCalories = 0;
  double calculatedProtein = 0;
  double calculatedCarbs = 0;
  double calculatedFat = 0;

  @override
  void initState() {
    super.initState();
    print('🍔 FoodPopup initState - Food: ${widget.foodName}');
    quantityController = TextEditingController(text: widget.initialQuantity);
    servingController = TextEditingController(text: widget.initialServing);

    // Initial calculation
    _recalculateNutrition();

    // Listen to changes
    quantityController.addListener(_recalculateNutrition);
  }

  @override
  void dispose() {
    quantityController.dispose();
    servingController.dispose();
    super.dispose();
  }

  void _recalculateNutrition() {
    setState(() {
      final quantity = double.tryParse(quantityController.text) ?? 1.0;
      calculatedCalories = widget.baseCalories * quantity;
      calculatedProtein = widget.baseProtein * quantity;
      calculatedCarbs = widget.baseCarbs * quantity;
      calculatedFat = widget.baseFat * quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.foodName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Favorite Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isFavorite
                          ? const Color(0xFFFF0000)
                          : const Color(0xFFFFE5E5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: isFavorite ? Colors.white : const Color(0xFFFF0000),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Close Button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF666666),
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Nutrition Cards Grid
            Row(
              children: [
                _buildNutritionCard(calculatedCalories.toStringAsFixed(0), 'kCal'),
                const SizedBox(width: 12),
                _buildNutritionCard('${calculatedProtein.toStringAsFixed(1)} g', 'Protein'),
                const SizedBox(width: 12),
                _buildNutritionCard('${calculatedCarbs.toStringAsFixed(1)} g', 'Carbs'),
                const SizedBox(width: 12),
                _buildNutritionCard('${calculatedFat.toStringAsFixed(1)} g', 'Fat'),
              ],
            ),
            const SizedBox(height: 32),

            // Input Fields
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(quantityController, TextInputType.numberWithOptions(decimal: true)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Serving',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(servingController, TextInputType.text),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Meal Time Selection
            const Text(
              'Meal Time',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedMealTime,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFF0000)),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                  ),
                  items: mealTimes.map((String time) {
                    return DropdownMenuItem<String>(
                      value: time,
                      child: Text(time[0].toUpperCase() + time.substring(1)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedMealTime = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Add Food Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  final quantity = quantityController.text.isEmpty ? '1' : quantityController.text;
                  final serving = servingController.text.isEmpty ? 'serving' : servingController.text;

                  widget.onAddFood(
                    foodName: widget.foodName,
                    quantity: quantity,
                    serving: serving,
                    timeName: selectedMealTime,
                    nutritionValue: {
                      'calories': calculatedCalories,
                      'protein': calculatedProtein,
                      'carbs': calculatedCarbs,
                      'fat': calculatedFat,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF0000),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Add Food',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, TextInputType keyboardType) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 2,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
