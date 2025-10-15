import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/workout/calculate_marcos/calculate_marcos_controller/calculate_macros_calculator.dart';


class CalculateMacrosScreen extends StatelessWidget {
  final controller = Get.put(CalculateMacrosController());

   CalculateMacrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Calculate Macros",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),

              /// Toggle Buttons
              Obx(() => Container(
                height: 38.h,
                width: 220.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: Colors.grey[300],
                ),
                child: Row(
                  children: [
                    _buildToggleButton("Imperial", !controller.isMetric.value, () {
                      controller.toggleUnit(false);
                    }),
                    _buildToggleButton("Metric", controller.isMetric.value, () {
                      controller.toggleUnit(true);
                    }),
                  ],
                ),
              )),
              SizedBox(height: 30.h),

              /// Height Fields
              Obx(() {
                if (controller.isMetric.value) {
                  return _buildTextField("Select your Height", "cm");
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildSmallTextField("5", "ft")),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildSmallTextField("5", "in")),
                    ],
                  );
                }
              }),
              SizedBox(height: 24.h),

              _buildDropdown("Select your activity level .", "Sedentary (0 active days/week)"),
              SizedBox(height: 20.h),

              _buildDropdown("Goal", "Lean"),
              SizedBox(height: 20.h),

              /// Weight Fields
              Obx(() {
                final unit = controller.isMetric.value ? "kg" : "lbs";
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField("What is your current Weight?", unit),
                    SizedBox(height: 16.h),
                    _buildTextField("What is your desired Weight?", unit),
                  ],
                );
              }),
              SizedBox(height: 20.h),

              /// Speed Selector
              _buildSpeedSelector(),
              SizedBox(height: 32.h),

              /// Done Button
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: active ? Colors.white : Colors.black87,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 6.h),
        Container(
          height: 42.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "5",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                      ),
                    )),
                Text(suffix,
                    style:
                    TextStyle(fontSize: 13.sp, color: Colors.black54)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallTextField(String hint, String suffix) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                  ),
                )),
            Text(suffix, style: TextStyle(fontSize: 13.sp, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 6.h),
        Container(
          height: 42.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(25.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(hint,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp)),
              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.redAccent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Speed of weight loss per week",
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _speedChip("0.1 kg"),
            _speedChip("0.8 kg"),
            _speedChip("1.5 kg"),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          height: 5.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(height: 6.h),
        Center(
          child: Text("Balanced",
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600)),
        ),
      ],
    );
  }

  Widget _speedChip(String text) {
    return Container(
      width: 60.w,
      height: 22.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(6.r),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 11.sp, color: Colors.black87),
      ),
    );
  }
}
