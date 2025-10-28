
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/viwes/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../global widget/global_widget.dart';
import '../../../helpers/helpers.dart';
import '../../../utils/utils.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  final bool isComplete = true;
  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;
    return  Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Center(child: CustomText(text: "Your routine",)),
            SizedBox(height: 10.h,),
            CustomTextButton(
                text: '+ Add  New Workout'.tr,
                color: Color(0xff999999),
                radius: 16.r,
                onTap: () { context.pushNamed(RouteNames.exercise);}),
            SizedBox(
              height: sizeH * 0.379, child: ListView.builder(
              itemCount:3,
              itemBuilder: (context, index) {
                return
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sizeW * 0.02),
                    child: InkWell(
                      onTap: () {


                      },
                      child: Slidable(
                        ///left icon=============================

                        startActionPane: ActionPane(motion: StretchMotion(), children: [
                          SizedBox(width: 20.w,),
                          SlidableAction(onPressed: ((context){
                            //call action method
                          }),
                            borderRadius: BorderRadius.circular(8.r),
                            backgroundColor: Colors.green,
                            icon:Icons.pin_drop_rounded,

                          ),
                          SizedBox(width: 4.w,),
                        ],
                        ),
                        ///right icon==========================

                        endActionPane: ActionPane(motion: StretchMotion(),  children: [

                          SizedBox(width: 4.w,),

                          SlidableAction(onPressed: ((context){
                            //call action method
                          //  _deleteItem(index);
                            ToastMessageHelper.errorMessageShowToster("Delete item");
                          }),

                            borderRadius: BorderRadius.circular(12.r),
                            backgroundColor: Colors.red,
                            icon:Icons.delete,
                          ),
                          SizedBox(width: 20.w,),
                        ]),

                        child: Container(
                          padding: EdgeInsets.all(sizeW * 0.03),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(sizeW * 0.03),
                            border: Border.all(color: Colors.red, width: sizeW * 0.005),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(8.r),
                              //   child: Image.asset(AppImages.workout,
                              //       width: sizeW * 0.14),
                              // ),
                              SizedBox(width: 6.w,),
                              // Column with two texts: "Workout Plan for" and `day` in red
                              HeadingThree(data: 'Chest Day'.tr),
                              SizedBox(height: 10.h,),
                              SizedBox(
                                width: sizeW * 0.30,
                                child: CustomTextButton(
                                  padding: sizeH*.01,
                                  text: isComplete ? 'Workout'.tr : 'incomplete'.tr,
                                  onTap: () {
                                    // var workoutPlan = navBarState.selectedWorkoutPlans[index];
                                    // print("Navigating with workout plan: $workoutPlan");  // Debugging line
                                    // Get.toNamed(RouteNames.exerciseScreen, arguments: {
                                    //   'dayData': workoutPlan,  // Ensure this contains valid data
                                    // }, preventDuplicates: false);
                                    // Handle button press
                                    // Get.toNamed(RouteNames.exerciseScreen,preventDuplicates: false);
                                  },
                                  color: isComplete ? AppColors.primaryColor : Colors.grey,

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                // );
              },
            ),
            ),
            Image.network(
              'https://lottiefiles.com/animations/t-plank-exercise-g5qVU6RPYY',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}
