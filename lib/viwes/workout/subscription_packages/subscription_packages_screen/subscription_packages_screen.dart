// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gym_cheloper/global%20widget/custom_appbar.dart';
// import 'package:gym_cheloper/routes/routes_name.dart';
// import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_controller/subscription_packages_controller.dart';
// import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_screen/subscription_buy_screen.dart';
//
//
// class SubscriptionPackagesScreen extends StatelessWidget {
//   const SubscriptionPackagesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SubscriptionController());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(title: "Subscription Packages"),
//         body: SafeArea(
//           child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 20.h),
//
//               // Title
//               Text(
//                 "We want to try\nScorpion Fitness for FREE",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                   height: 1.4,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//
//               // SVG Illustration
//               SvgPicture.asset(
//                 'assets/svg/subscription_preview.svg',
//                 height: 250.h,
//                 width: double.infinity,
//                 fit: BoxFit.contain,
//               ),
//               SizedBox(height: 16.h),
//
//               // Dots Indicator (mocked)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildDot(isActive: true),
//                   SizedBox(width: 6.w),
//                   _buildDot(isActive: false),
//                   SizedBox(width: 6.w),
//                   _buildDot(isActive: false),
//                 ],
//               ),
//               SizedBox(height: 28.h),
//
//               // Subscription Options
//               Obx(() => Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildPlanBox(
//                     index: 0,
//                     controller: controller,
//                     title: "Monthly",
//                     price: "US\$ 12,99/mo",
//                     isHighlighted: false,
//                   ),
//                   SizedBox(width: 16.w),
//                   Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       _buildPlanBox(
//                         index: 1,
//                         controller: controller,
//                         title: "3 month",
//                         price: "US\$ 9,74/mo",
//                         isHighlighted: true,
//                       ),
//                       Positioned(
//                         right: 10.w,
//                         top: -12.h,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 8.w, vertical: 2.h),
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             borderRadius: BorderRadius.circular(10.r),
//                           ),
//                           child: Text(
//                             "Save 25%",
//                             style: TextStyle(
//                               fontSize: 10.sp,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               )),
//               SizedBox(height: 24.h),
//
//               // Best Price Text
//               Text(
//                 "Best Price value offer in the market",
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   color: Colors.black54,
//                 ),
//               ),
//               SizedBox(height: 16.h),
//
//           GestureDetector(
//             child: Container(
//               width: double.infinity,
//               height: 52.h,
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.circular(30.r),
//               ),
//               child: Center(
//                 child: Text(
//                   "START 5 DAY FREE TRIAL",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 0.8,
//                   ),
//                 ),
//               ),
//             ),
//             onTap: () {
//               context.push(RouteNames.subscriptionbuyScreen);
//
//             },
//           ),
//
//
//
//
//           SizedBox(height: 16.h),
//
//               // Sub text
//               Text(
//                 "5 days free, then US\$ 29,23 per 3 months\n(US\$ 9,74/mo)",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 11.sp,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//
//               Text(
//                 "You won’t be charged now. Your selected subscription will start after your free trial ends. Cancel anytime in AppStore.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 10.sp,
//                   color: Colors.black54,
//                   height: 1.4,
//                 ),
//               ),
//               SizedBox(height: 24.h),
//
//               // Restore and Redeem links
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Restore Purchases",
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                   SizedBox(width: 24.w),
//                   GestureDetector(
//                     onTap: () {
//                       context.go(RouteNames.subscriptioncodeScreen);
//                     },
//                     child: Text(
//                       "Redeem Code",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w500,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 28.h),
//
//               Text(
//                 "Any Questions?",
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 "Contact Us at escorpionfitness@gmail.com",
//                 style: TextStyle(
//                   fontSize: 11.sp,
//                   color: Colors.black54,
//                 ),
//               ),
//               SizedBox(height: 24.h),
//             ],
//           ),
//         ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDot({required bool isActive}) {
//     return Container(
//       width: isActive ? 8.w : 6.w,
//       height: isActive ? 8.w : 6.w,
//       decoration: BoxDecoration(
//         color: isActive ? Colors.black : Colors.grey[400],
//         shape: BoxShape.circle,
//       ),
//     );
//   }
//
//   Widget _buildPlanBox({
//     required int index,
//     required SubscriptionController controller,
//     required String title,
//     required String price,
//     required bool isHighlighted,
//   }) {
//     final isSelected = controller.selectedIndex.value == index;
//     return GestureDetector(
//       onTap: () => controller.selectPlan(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: 150.w,
//         padding: EdgeInsets.symmetric(vertical: 14.h),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.black : Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(
//             color: isHighlighted ? Colors.red : Colors.grey[300]!,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Column(
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? Colors.white : Colors.black,
//               ),
//             ),
//             SizedBox(height: 6.h),
//             Text(
//               price,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 fontWeight: FontWeight.w500,
//                 color: isSelected ? Colors.white : Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
