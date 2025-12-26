import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/widgets/custom_text.dart';
import 'package:gym_cheloper/viwes/workout/exercise/dialog.dart';
import 'package:gym_cheloper/viwes/workout/exercise/exercise_controller/exercise_controller.dart';
import 'package:gym_cheloper/viwes/workout/exercise/timer_popup.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExerciseController());

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
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  ),
                  SizedBox(width: 10.w),
                  CustomText(
                    text: "Your Routines",
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

              /// Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => CustomText(
                      text: controller.trainingName.value,
                      color: Colors.red,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return RestTimerPopup();
                        },
                      );
                    },
                    child: const Icon(Icons.alarm, color: Colors.black87),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              /// Add Exercise button
              Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff999999),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AddNewExerciseDialog(
                            onAddExercise: (exerciseName) {
                              controller.addExercise(exerciseName);
                              Get.snackbar(
                                'Success',
                                'Exercise added successfully!',
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
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: CustomText(
                      text: "Add Exercise",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15.h),

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
                        child: Dismissible(
                          key: Key(item.name + index.toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return false; // Don't auto-dismiss
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20.w),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
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

                                // Expanded content
                                Obx(
                                      () => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: item.isExpanded.value ? null : 0,
                                    child: item.isExpanded.value
                                        ? Column(
                                      children: [
                                        Divider(height: 1.h, color: Colors.grey[300]),

                                        // Header row
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 40.w),
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
                                              SizedBox(width: 30.w),
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
                                                child: Dismissible(
                                                  key: Key('${item.name}_set_$setIndex'),
                                                  direction: DismissDirection.endToStart,
                                                  confirmDismiss: (direction) async {
                                                    controller.removeWorkoutSet(index, setIndex);
                                                    return false;
                                                  },
                                                  background: Container(
                                                    alignment: Alignment.centerRight,
                                                    padding: EdgeInsets.only(right: 20.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius: BorderRadius.circular(8.r),
                                                    ),
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      // Checkbox
                                                      SizedBox(
                                                        width: 24.w,
                                                        height: 24.w,
                                                        child: Checkbox(
                                                          value: set.isCompleted.value,
                                                          onChanged: (val) {
                                                            controller.toggleSetCompletion(index, setIndex);
                                                          },
                                                          activeColor: Colors.red,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(4.r),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 16.w),

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

                                                      // Extra spacing instead of delete icon
                                                      SizedBox(width: 30.w),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        // Add workout log button
                                        Padding(
                                          padding: EdgeInsets.all(16.w),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.r),
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                              ),
                                              onPressed: () {
                                                _showWorkoutLogDialog(context, item, index);
                                              },
                                              child: CustomText(
                                                text: "Add workout log",
                                                color: Colors.white,
                                                fontsize: 14.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              /// Finish Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                    onPressed: () {},
                    child: CustomText(
                      text: "Finish today's exercise",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWorkoutLogDialog(BuildContext context, dynamic exerciseItem, int exerciseIndex) {
    final controller = Get.find<ExerciseController>();
    final repsController = TextEditingController();
    final weightController = TextEditingController();
    final RxString selectedSets = "Select".obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Title
                CustomText(
                  text: "Track your best reps",
                  fontsize: 18.sp,
                  fontName: "RobotoMedium",
                ),

                SizedBox(height: 8.h),

                // Subtitle
                CustomText(
                  text: "Track your best reps below. If you used bodyweight\njust don't enter weight.",
                  fontsize: 12.sp,
                  color: Colors.grey[600],
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Sets dropdown
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: "Sets",
                    fontsize: 14.sp,
                    fontName: "RobotoMedium",
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Obx(
                        () => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedSets.value,
                        icon: Icon(Icons.keyboard_arrow_down, color: Colors.red),
                        items: ["Select","W", "1", "2", "3", "4", "5"]
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: CustomText(text: value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            selectedSets.value = newValue;
                          }
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Reps input
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: "Reps",
                    fontsize: 14.sp,
                    fontName: "RobotoMedium",
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "14",
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                ),

                SizedBox(height: 16.h),

                // Weight input
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: "Weight (kg)",
                    fontsize: 14.sp,
                    fontName: "RobotoMedium",
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                ),

                SizedBox(height: 24.h),

                // Track Reps button
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
                      // Validate inputs
                      final reps = int.tryParse(repsController.text) ?? 0;
                      final weight = int.tryParse(weightController.text) ?? 0;

                      if (reps > 0) {
                        // Add workout set using controller
                        controller.addWorkoutSet(
                          exerciseIndex: exerciseIndex,
                          reps: reps,
                          weight: weight,
                        );

                        Get.back();

                        // Show success message
                        Get.snackbar(
                          'Success',
                          'Workout set added!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please enter valid reps',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: CustomText(
                      text: "Track Reps",
                      color: Colors.white,
                      fontsize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}