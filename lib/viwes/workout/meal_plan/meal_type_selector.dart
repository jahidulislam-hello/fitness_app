import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_plan_controller/meal_plan_controller.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/add_meal_popup.dart';

void showMealTypeSelector(BuildContext context, String selectedDate) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => MealTypeSelector(selectedDate: selectedDate),
  );
}

class MealTypeSelector extends StatefulWidget {
  final String selectedDate;

  const MealTypeSelector({super.key, required this.selectedDate});

  @override
  State<MealTypeSelector> createState() => _MealTypeSelectorState();
}

class _MealTypeSelectorState extends State<MealTypeSelector> {
  final List<Map<String, dynamic>> mealTypes = [
    {'name': 'Breakfast', 'icon': Icons.breakfast_dining, 'isEditable': false},
    {'name': 'Lunch', 'icon': Icons.lunch_dining, 'isEditable': false},
    {'name': 'Dinner', 'icon': Icons.dinner_dining, 'isEditable': false},
    {'name': 'Snack Number 1', 'icon': Icons.cookie, 'isEditable': true},
    {'name': 'Snack Number 2', 'icon': Icons.cookie, 'isEditable': true},
  ];

  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var meal in mealTypes) {
      _controllers.add(TextEditingController(text: meal['name']));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Title
            Text(
              'Select Meal Type',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 24.h),

            // Meal Type Boxes
            ...List.generate(mealTypes.length, (index) {
              final meal = mealTypes[index];
              final controller = _controllers[index];
              final isEditable = meal['isEditable'] as bool;

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showAddMealPopup(context, controller.text);
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: Color(0xffF93533).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            meal['icon'] as IconData,
                            color: Color(0xffF93533),
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: isEditable
                              ? TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: 'Meal name',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                )
                              : Text(
                                  meal['name'] as String,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.sp,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _showAddMealPopup(BuildContext context, String mealType) {
    showAddMealPopup(context, widget.selectedDate, mealType: mealType);
  }
}
