import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/viwes/widgets/custom_text.dart';
import 'package:gym_cheloper/viwes/workout/exercise/dialog.dart';
import 'package:gym_cheloper/viwes/workout/exercise/exercise_controller/exercise_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExerciseHistoryScreen extends StatelessWidget {
  final String? workoutId;
  final String? trainingName;

  const ExerciseHistoryScreen({
    super.key,
    this.workoutId,
    this.trainingName,
  });

  @override
  Widget build(BuildContext context) {
    // Delete existing controller if any to ensure fresh state
    if (Get.isRegistered<ExerciseController>()) {
      Get.delete<ExerciseController>();
    }

    final controller = Get.put(ExerciseController());

    // Set workout data if provided
    if (workoutId != null && workoutId!.isNotEmpty) {
      controller.setWorkout(workoutId!, trainingName ?? 'Workout');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Nav
              Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  ),
                  SizedBox(width: 10.w),
                  CustomText(
                    text: "All Time WorkOut Log",
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              /// Exercise image
              Obx(
                    () => Container(
                  height: 160.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: controller.isMainImageLoading.value
                        ? const CircularProgressIndicator(
                      color: Color(0xffF93533),
                    )
                        : controller.currentExerciseImage.value.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: controller.currentExerciseImage.value,
                        height: 130.h,
                        fit: BoxFit.contain,
                        httpHeaders: const {
                          'x-rapidapi-key': 'fb9a00baa2msh43336df37f58631p1ceeaejsnd8eacd0ede8e',
                          'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
                          'x-app-id': '8ad96951',
                          'x-app-key': 'f04813f79bf461d565d4a33ca5a86e9a',
                        },
                        placeholder: (context, url) => const CircularProgressIndicator(
                          color: Color(0xffF93533),
                        ),
                        errorWidget: (context, url, error) {
                          print('❌ Image error: $error');
                          return Image.asset(
                            'assets/icons/chest_plank.png',
                            height: 130.h,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    )
                        : Image.asset(
                      'assets/icons/chest_plank.png',
                      height: 130.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15.h),

              /// Exercise name (e.g., Chin Up)
              Obx(
                () => CustomText(
                  text: controller.exercises.isNotEmpty
                      ? controller.exercises.first.name
                      : (controller.trainingName.value),
                  fontName: "RobotoMedium",
                  fontsize: 18.sp,
                ),
              ),

              SizedBox(height: 40.h),

              /// History text
              CustomText(
                text: "History",
                fontName: "RobotoMedium",
                fontsize: 16.sp,
              ),

              SizedBox(height: 8.h),

              /// Divider 2px height
              Container(
                height: 2,
                color: Colors.grey[300],
              ),

              SizedBox(height: 16.h),

              /// Exercise list
              Expanded(
                child: Obx(
                      () => controller.isLoading.value
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffF93533),
                    ),
                  )
                      : controller.exercises.isEmpty
                      ? Center(
                    child: CustomText(
                      text: "No exercises found",
                      color: Colors.grey,
                    ),
                  )
                      : ListView.builder(
                    itemCount: controller.exercises.length,
                    itemBuilder: (context, index) {
                      final item = controller.exercises[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                leading: Container(
                                  width: 42.w,
                                  height: 42.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF5F5F5),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icons/dumbbell.png',
                                      height: 32.h,
                                    ),
                                  ),
                                ),
                                title: CustomText(
                                  text: item.name,
                                  fontName: "RobotoMedium",
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SwapExerciseDialog(
                                              exerciseIndex: index,
                                              onSwapExercise: (exerciseIndex, newExerciseName) {
                                                controller.swapExercise(exerciseIndex, newExerciseName);
                                                Get.snackbar(
                                                  'Success',
                                                  'Exercise swapped successfully!',
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.green,
                                                  colorText: Colors.white,
                                                  duration: const Duration(seconds: 2),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Image.asset(
                                        'assets/icons/rotate.png',
                                        height: 24.h,
                                      ),
                                    ),
                                    SizedBox(width: 18.w),
                                    Obx(
                                          () => InkWell(
                                        onTap: () => controller.toggleExpand(index),
                                        child: Icon(
                                          item.isExpanded.value
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Sets list (always visible, not expanded)
                              Column(
                                children: [
                                  Divider(height: 1.h, color: Colors.grey[300]),

                                  // Header row
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            text: "Set",
                                            fontsize: 12.sp,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            text: "Reps",
                                            fontsize: 12.sp,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            text: "Weight",
                                            fontsize: 12.sp,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            text: "Date",
                                            fontsize: 12.sp,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Sets list
                                  Obx(
                                        () => ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: item.sets.length,
                                      itemBuilder: (context, setIndex) {
                                        final set = item.sets[setIndex];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                                          child: Row(
                                            children: [
                                              // Set number
                                              Expanded(
                                                child: CustomText(
                                                  text: "${setIndex + 1}",
                                                  fontsize: 14.sp,
                                                ),
                                              ),

                                              // Reps
                                              Expanded(
                                                child: CustomText(
                                                  text: set.reps.toString(),
                                                  fontsize: 14.sp,
                                                ),
                                              ),

                                              // Weight
                                              Expanded(
                                                child: CustomText(
                                                  text: set.weight.toString(),
                                                  fontsize: 14.sp,
                                                ),
                                              ),

                                              // Date
                                              Expanded(
                                                child: CustomText(
                                                  text: set.date.value,
                                                  fontsize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
