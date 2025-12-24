import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/viwes/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gym_cheloper/viwes/screens/workout/workout_controller.dart';

import '../../../global widget/global_widget.dart';
import '../../../helpers/helpers.dart';
import '../../../utils/utils.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkoutController controller = Get.put(WorkoutController());
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Center(
              child: CustomText(text: "Your routine"),
            ),
            SizedBox(height: 10.h),

            /// Add Workout Button
            CustomTextButton(
              text: '+ Add New Workout'.tr,
              color: const Color(0xff999999),
              radius: 16.r,
              onTap: () {
                context.pushNamed(RouteNames.exercise);
              },
            ),

            SizedBox(height: 16.h),

            /// Workout List
            Obx(() {
              /// Loading State
              if (controller.isLoading.value) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffF93533),
                    ),
                  ),
                );
                
              }

              /// Empty State
              if (controller.workouts.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No workouts found',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              /// Workout List
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.workouts.length,
                  itemBuilder: (context, index) {
                    final workout = controller.workouts[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: sizeW * 0.02),
                      child: Slidable(
                        startActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SizedBox(width: 12.w),
                            SlidableAction(
                              onPressed: (context) {
                                controller.pinWorkout(index);
                              },
                              borderRadius: BorderRadius.circular(8.r),
                              backgroundColor: Colors.green,
                              icon: Icons.push_pin,
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                controller.deleteWorkout(index);
                              },
                              borderRadius: BorderRadius.circular(12.r),
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                            ),
                            SizedBox(width: 12.w),
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.all(sizeW * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: HeadingThree(
                                  data: workout.trainingName.tr,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              SizedBox(
                                width: sizeW * 0.32,
                                child: CustomTextButton(
                                  padding: sizeH * 0.01,
                                  text: workout.completed
                                      ? 'Completed'.tr
                                      : 'Workout'.tr,
                                  onTap: () {},
                                  color: workout.completed
                                      ? Colors.grey
                                      : AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
