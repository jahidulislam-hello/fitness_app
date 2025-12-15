import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_plan_controller/meal_plan_controller.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MealTrackingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          // ✅ Show loading indicator while fetching data
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xffF93533),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadMealsFromAPI(),
            color: Color(0xffF93533),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // Date Selector
                    _buildDateSelector(controller),

                    SizedBox(height: 24.h),

                    // Calories Circle Row
                    _buildCaloriesRow(controller),

                    SizedBox(height: 24.h),

                    // Water Intake
                    _buildWaterIntake(controller),

                    SizedBox(height: 24.h),

                    // Today Label
                    Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Meals List
                    Obx(() => controller.meals.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.meals.length,
                      itemBuilder: (context, index) {
                        return _buildMealCard(controller, index);
                      },
                    )),

                    SizedBox(height: 16.h),

                    // Add New Meal Button
                    _buildAddMealButton(controller),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No meals added yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your first meal to start tracking',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(MealTrackingController controller) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 16.sp, color: Colors.black87),
            SizedBox(width: 6.w),
            Text(
              'Today, ${_formatDate(controller.selectedDate.value)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),

        // Week Date Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final date = controller.weekDates[index];
            final isSelected =
            _isSameDay(date, controller.selectedDate.value);
            final dayName = _getDayNameShort(date.weekday);
            final dayNumber = date.day;

            // Base colors
            Color borderColor = const Color(0xFFD1D1D1);
            Color fillColor = Colors.white;
            Color textColor = Colors.black87;

            // Apply color indicators
            if (index == 0) borderColor = const Color(0xFFE57373);
            if (index == 1) borderColor = const Color(0xFFFFD54F);
            if (index == 2) borderColor = const Color(0xFF4CAF50);

            // Selected state
            if (isSelected) {
              fillColor = const Color(0xFF4CAF50);
              borderColor = const Color(0xFF4CAF50);
              textColor = Colors.white;
            }

            return GestureDetector(
              onTap: () => controller.selectDate(date),
              child: Column(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: fillColor,
                      border: Border.all(
                        color: borderColor,
                        width: 5.w,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    ));
  }

  Widget _buildCaloriesRow(MealTrackingController controller) {
    return Obx(() => Row(
      children: [
        // Daily Calories
        Expanded(
          child: Column(
            children: [
              Text(
                controller.todayDateString,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72.w,
                    height: 72.w,
                    child: CircularProgressIndicator(
                      value: controller.dailyCaloriesPercentage / 100,
                      strokeWidth: 9.w,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFF5252)),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${controller.dailyCalories.value.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFF5252),
                        ),
                      ),
                      Text(
                        '/${controller.dailyCaloriesGoal.value.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Daily\nCalories',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),

        // Macros Column
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMacroBar('Carbs', controller.carbs.value, controller.carbsGoal.value,
                  controller.carbsPercentage, Color(0xffFFB74D)),
              SizedBox(height: 12.h),
              _buildMacroBar('Protein', controller.protein.value, controller.proteinGoal.value,
                  controller.proteinPercentage, Color(0xff64B5F6)),
              SizedBox(height: 12.h),
              _buildMacroBar('Fat', controller.fat.value, controller.fatGoal.value,
                  controller.fatPercentage, Color(0xff81C784)),
            ],
          ),
        ),

        // Weekly Calories
        Expanded(
          child: Column(
            children: [
              Text(
                controller.weekDateRangeString,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72.w,
                    height: 72.w,
                    child: CircularProgressIndicator(
                      value: controller.weeklyCaloriesPercentage / 100,
                      strokeWidth: 9.w,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4CAF50)),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${controller.weeklyCalories.value.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4CAF50),
                        ),
                      ),
                      Text(
                        '/${controller.weeklyCaloriesGoal.value.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Weekly\nCalories',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildMacroBar(String label, double value, double goal, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)}/${goal.toStringAsFixed(0)} g',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8.h,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterIntake(MealTrackingController controller) {
    return Obx(() => Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Water Intake',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0.0L',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.black54,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${controller.waterIntake.value}L',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${controller.waterGoal.value}L',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Row(
            children: [
              SizedBox(width: 8.w),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: controller.waterPercentage / 100,
                    minHeight: 12.h,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2196F3)),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildMealCard(MealTrackingController controller, int index) {
    final meal = controller.meals[index];

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Slidable(
        key: ValueKey(meal.name + index.toString()),

        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) => controller.pinMeal(index),
              backgroundColor: const Color(0xFFE3F2FD),
              foregroundColor: Colors.blueAccent,
              icon: Icons.push_pin,
              label: 'Pin',
              borderRadius: BorderRadius.circular(12.r),
            ),
          ],
        ),

        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) => controller.deleteMeal(index),
              backgroundColor: const Color(0xFFFFEBEE),
              foregroundColor: Colors.redAccent,
              icon: Icons.delete_outline,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12.r),
            ),
          ],
        ),

        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (meal.isPinned)
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: Icon(Icons.push_pin,
                                size: 14.sp, color: Colors.blueAccent),
                          ),
                        Text(
                          meal.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: [
                        _buildMealMacroChip('${meal.calories.toStringAsFixed(0)} kcal'),
                        _buildMealMacroChip('Carbs ${meal.carbs.toStringAsFixed(1)}g'),
                        _buildMealMacroChip('Protein ${meal.protein.toStringAsFixed(1)}g'),
                        _buildMealMacroChip('Fat ${meal.fat.toStringAsFixed(1)}g'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () => controller.toggleMealCompletion(index),
                child: Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: meal.isCompleted
                        ? const Color(0xffF93533)
                        : const Color(0xff8C8C8C),
                    border: Border.all(
                      color: meal.isCompleted
                          ? const Color(0xffF93533)
                          : const Color(0xFF8C8C8C),
                      width: 2,
                    ),
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 20.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealMacroChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xffF93533),
          width: 1.2,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildAddMealButton(MealTrackingController controller) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => controller.addNewMeal(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Color(0xff9E9E9E),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Add New Meal',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _getDayNameShort(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}