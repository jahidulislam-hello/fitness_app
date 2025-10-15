import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/workout/custom_plan/custom_plan_controller/custom_plan_controller.dart';


class CustomPlanScreen extends StatelessWidget {
  final controller = Get.put(CustomPlanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black87),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              /// ✅ Success Icon and Text
              Icon(Icons.check_circle, color: Colors.green, size: 36.sp),
              SizedBox(height: 12.h),
              Text(
                "Congratulations",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "your custom plan is ready",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 22.h),

              /// ✅ Weight loss info box
              Obx(() => Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Text(
                  "${controller.weightLoss.value} by ${controller.targetDate.value}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
              SizedBox(height: 22.h),

              /// ✅ Sources Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Plan based on the following sources, among other peer-reviewed medical studies:",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              _buildBullet("Basal metabolic rate"),
              _buildBullet("Calorie counting - Harvard"),
              _buildBullet("International Society of Sports Nutrition"),
              _buildBullet("National Institutes of Health"),
              SizedBox(height: 30.h),

              /// ✅ Macros Grid
              Obx(() => Wrap(
                spacing: 30.w,
                runSpacing: 30.h,
                alignment: WrapAlignment.center,
                children: [
                  _macroItem("Calories", controller.calories.value),
                  _macroItem("Protein", controller.protein.value),
                  _macroItem("Carbs", controller.carbs.value),
                  _macroItem("Fat", controller.fat.value),
                ],
              )),
              const Spacer(),

              /// ✅ Footer text
              Text(
                "You can always fully customize your macros",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.h),

              /// ✅ Done Button
              Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Center(
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• ",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              height: 1.4,
            )),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _macroItem(String label, int value) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 75.w,
              height: 75.w,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            CircularProgressIndicator(
              value: 0.8,
              strokeWidth: 6.w,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
            ),
            Text(
              "$value",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
