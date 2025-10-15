// ==================== BOTTOM SHEET ====================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'weight_tracking_controller/weight_tracking_controller.dart';

class WeightInputBottomSheet extends StatelessWidget {
  final WeightTrackingController controller;

  const WeightInputBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            SizedBox(height: 20.h),

            // Title
            Text(
              'Weight In',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 24.h),

            // Weight and Date Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'Weight (kg)',
                    controller: controller.weightController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildDateField(context),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Body Fat and Waist Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'Body Fat',
                    controller: controller.bodyFatController,
                    suffix: '%',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildInputField(
                    label: 'Waist',
                    controller: controller.waistController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Arm and Calves Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'Arm',
                    controller: controller.armController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildInputField(
                    label: 'Calves',
                    controller: controller.calvesController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Thigh and Neck Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'Thigh',
                    controller: controller.thighController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildInputField(
                    label: 'Neck',
                    controller: controller.neckController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Submit Button
            GestureDetector(
              onTap: () => controller.submitWeight(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: Color(0xffFF0000),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    'Submit weight',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? suffix,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 14.sp),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              suffixText: suffix,
              suffixStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() => GestureDetector(
          onTap: () => controller.selectDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.selectedDate.value.month}/${controller.selectedDate.value.day}/${controller.selectedDate.value.year.toString().substring(2)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 16.sp,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}