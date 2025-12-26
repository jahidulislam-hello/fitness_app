import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/widgets/custom_text.dart';

// Add New Exercise Dialog
class AddNewExerciseDialog extends StatelessWidget {
  final Function(String) onAddExercise;

  const AddNewExerciseDialog({
    super.key,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final RxList<String> exercises = <String>[
      'Incline Chest',
      'Incline Chest',
      'Incline Chest',
    ].obs;
    final RxList<String> filteredExercises = <String>[
      'Incline Chest',
      'Incline Chest',
      'Incline Chest',
    ].obs;

    void filterExercises(String query) {
      if (query.isEmpty) {
        filteredExercises.value = exercises;
      } else {
        filteredExercises.value = exercises
            .where((exercise) =>
            exercise.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 12.w),
                CustomText(
                  text: "Add New Exercise",
                  fontsize: 18.sp,
                  fontName: "RobotoMedium",
                  color: Colors.black87,
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Search Field
            TextField(
              controller: searchController,
              onChanged: filterExercises,
              decoration: InputDecoration(
                hintText: "Incline Chest",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.red,
                  size: 24.sp,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              ),
            ),

            SizedBox(height: 16.h),

            // Exercise List
            Expanded(
              child: Obx(
                    () => ListView.separated(
                  shrinkWrap: true,
                  itemCount: filteredExercises.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        onAddExercise(filteredExercises[index]);
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/icons/dumbbell.png',
                                  height: 24.h,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // Text
                            Expanded(
                              child: CustomText(
                                text: filteredExercises[index],
                                fontsize: 15.sp,
                                color: Colors.black87,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Add Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                onPressed: () {
                  if (searchController.text.isNotEmpty) {
                    onAddExercise(searchController.text);
                    Get.back();
                  }
                },
                child: CustomText(
                  text: "Add New exercise",
                  color: Colors.white,
                  fontsize: 16.sp,
                  fontName: "RobotoMedium",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Swap Exercise Dialog
class SwapExerciseDialog extends StatelessWidget {
  final int exerciseIndex;
  final Function(int, String) onSwapExercise;

  const SwapExerciseDialog({
    super.key,
    required this.exerciseIndex,
    required this.onSwapExercise,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final RxList<String> exercises = <String>[
      'Incline Chest',
      'Incline Chest',
      'Incline Chest',
    ].obs;
    final RxList<String> filteredExercises = <String>[
      'Incline Chest',
      'Incline Chest',
      'Incline Chest',
    ].obs;

    void filterExercises(String query) {
      if (query.isEmpty) {
        filteredExercises.value = exercises;
      } else {
        filteredExercises.value = exercises
            .where((exercise) =>
            exercise.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 12.w),
                CustomText(
                  text: "Swap exercise",
                  fontsize: 18.sp,
                  fontName: "RobotoMedium",
                  color: Colors.black87,
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Search Field
            TextField(
              controller: searchController,
              onChanged: filterExercises,
              decoration: InputDecoration(
                hintText: "incline Chest",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.red,
                  size: 24.sp,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              ),
            ),

            SizedBox(height: 16.h),

            // Exercise List
            Expanded(
              child: Obx(
                    () => ListView.separated(
                  shrinkWrap: true,
                  itemCount: filteredExercises.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        onSwapExercise(exerciseIndex, filteredExercises[index]);
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/icons/dumbbell.png',
                                  height: 24.h,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // Text
                            Expanded(
                              child: CustomText(
                                text: filteredExercises[index],
                                fontsize: 15.sp,
                                color: Colors.black87,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Swap Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                onPressed: () {
                  if (searchController.text.isNotEmpty) {
                    onSwapExercise(exerciseIndex, searchController.text);
                    Get.back();
                  }
                },
                child: CustomText(
                  text: "Swap exercise",
                  color: Colors.white,
                  fontsize: 16.sp,
                  fontName: "RobotoMedium",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}