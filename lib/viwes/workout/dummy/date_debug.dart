// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gym_cheloper/viwes/workout/meal_plan/meal_plan_controller/meal_plan_controller.dart';
//
// /// Add this widget at the top of your MealScreen for testing
// class DateDebugWidget extends StatelessWidget {
//   final MealTrackingController controller;
//
//   const DateDebugWidget({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       margin: EdgeInsets.symmetric(vertical: 8.h),
//       decoration: BoxDecoration(
//         color: Colors.orange[50],
//         border: Border.all(color: Colors.orange),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '🐛 DEBUG MODE',
//             style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.orange[900],
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Obx(() => Text(
//             'Current Date: ${controller.selectedDate.value.toString().split(' ')[0]}',
//             style: TextStyle(fontSize: 12.sp),
//           )),
//           SizedBox(height: 8.h),
//           ElevatedButton(
//             onPressed: () {
//               // Set to the date that has data in your backend
//               final testDate = DateTime(2025, 8, 27);
//               controller.selectDate(testDate);
//               print('🎯 Manually set date to: 2025-08-27');
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange,
//               padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
//             ),
//             child: Text(
//               'Load August 27, 2025 (Test Date)',
//               style: TextStyle(fontSize: 12.sp),
//             ),
//           ),
//           SizedBox(height: 8.h),
//           ElevatedButton(
//             onPressed: () async {
//               print('🔄 Manual reload triggered');
//               await controller.loadMealsFromAPI();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
//             ),
//             child: Text(
//               'Reload Current Date',
//               style: TextStyle(fontSize: 12.sp),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// HOW TO USE:
// /// Add this at the top of your MealScreen Column (after SizedBox(height: 16.h)):
// ///
// /// DateDebugWidget(controller: controller),
// /// SizedBox(height: 16.h),