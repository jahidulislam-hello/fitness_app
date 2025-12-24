import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/widgets/custom_text.dart';
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
                    // use your existing style system here if you have one
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
                  CustomText(
                    text: "Chest Day",
                    color: Colors.red,
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
                      controller.addExercise("New Exercise");
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label:  CustomText(
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
                      () => ListView.builder(
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
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w),

                            // Left icon
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

                            // Title text only
                            title: CustomText(
                              text: item.name,
                              fontName: "RobotoMedium",
                            ),

                            // Trailing: rotate icon + spacing + expand/collapse arrow
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/rotate.png',
                                  height: 24.h,
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
                    child:  CustomText(
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
}
