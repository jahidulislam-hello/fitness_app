// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_controller/subscription_card_controller.dart';
//
//
// class ChooseYourCardScreen extends StatelessWidget {
//   final controller = Get.put(CardDetectionController());
//
//   ChooseYourCardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text("choose Your card",
//             style: TextStyle(color: Colors.black, fontSize: 16)),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("My Card",
//                 style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black)),
//
//             SizedBox(height: 16.h),
//
//             /// Card Preview
//             Obx(() => _buildCardView()),
//
//             SizedBox(height: 24.h),
//
//             Text("Enter your card number",
//                 style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87)),
//
//             SizedBox(height: 10.h),
//
//             /// Card Number Input
//             TextField(
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: "XXXX XXXX XXXX XXXX",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 contentPadding:
//                 EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//               ),
//               onChanged: controller.detectCardType,
//             ),
//
//             const Spacer(),
//
//             /// Pay Now Button
//             SizedBox(
//               width: double.infinity,
//               height: 52.h,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2979FF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//                 child: Text(
//                   "Pay now",
//                   style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// 💳 Card Preview Widget
//   Widget _buildCardView() {
//     final cardType = controller.cardType.value;
//     final cardNumber = controller.cardNumber.value;
//     final bankName = controller.bankName.value;
//
//     Color startColor;
//     Color endColor;
//
//     switch (cardType) {
//       case 'Visa':
//         startColor = Colors.blueAccent;
//         endColor = Colors.lightBlueAccent;
//         break;
//       case 'MasterCard':
//         startColor = const Color(0xFFFF5252);
//         endColor = const Color(0xFF1976D2);
//         break;
//       case 'American Express':
//         startColor = const Color(0xFF0077A6);
//         endColor = const Color(0xFF00B0FF);
//         break;
//       case 'Discover':
//         startColor = const Color(0xFFFF9800);
//         endColor = const Color(0xFFFF5722);
//         break;
//       default:
//         startColor = Colors.grey;
//         endColor = Colors.black26;
//     }
//
//     return Container(
//       width: double.infinity,
//       height: 180.h,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [startColor, endColor],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           )
//         ],
//       ),
//       padding: EdgeInsets.all(20.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(bankName,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600)),
//
//           /// Card number
//           Text(
//             cardNumber.isEmpty ? 'XXXX XXXX XXXX XXXX' : _formatCardNumber(cardNumber),
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20.sp,
//               letterSpacing: 2,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Expired Date',
//                         style: TextStyle(
//                             fontSize: 10.sp,
//                             color: Colors.white.withOpacity(0.8))),
//                     Text('10/28',
//                         style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white)),
//                   ]),
//               _cardLogo(cardType),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Card Logo Widget
//   Widget _cardLogo(String type) {
//     switch (type) {
//       case 'Visa':
//         return Image.asset('assets/images/visa.png', height: 28.h, width: 40.w);
//       case 'MasterCard':
//         return Image.asset('assets/images/mastercard.png', height: 28.h, width: 40.w);
//       case 'American Express':
//         return Image.asset('assets/images/amex.png', height: 28.h, width: 40.w);
//       case 'Discover':
//         return Image.asset('assets/images/discover.png', height: 28.h, width: 40.w);
//       default:
//         return Image.asset('assets/images/generic_card.png', height: 28.h, width: 40.w);
//     }
//   }
//
//   /// Card number formatter
//   String _formatCardNumber(String number) {
//     number = number.replaceAll(' ', '');
//     final buffer = StringBuffer();
//     for (int i = 0; i < number.length; i++) {
//       buffer.write(number[i]);
//       if ((i + 1) % 4 == 0 && i != number.length - 1) {
//         buffer.write(' ');
//       }
//     }
//     return buffer.toString();
//   }
// }
// // import 'package:flutter/material.dart';
//
//
//
//
//
//
//
//




















































//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_controller/subscription_card_controller.dart';
//
//
// class ChooseYourCardScreen extends StatelessWidget {
//   final ChooseYourCardController controller = Get.put(ChooseYourCardController());
//
//   ChooseYourCardScreen({super.key});
//
//   Widget _cardLogo(String type) {
//     switch (type) {
//       case 'Visa':
//         return Image.asset('assets/images/visa.png', height: 28.h, width: 40.w);
//       case 'MasterCard':
//         return Image.asset('assets/images/mastercard.png', height: 28.h, width: 40.w);
//       case 'American Express':
//         return Image.asset('assets/images/amex.png', height: 28.h, width: 40.w);
//       case 'Discover':
//         return Image.asset('assets/images/discover.png', height: 28.h, width: 40.w);
//       default:
//         return Image.asset('assets/images/generic_card.png', height: 28.h, width: 40.w);
//     }
//   }
//
//   LinearGradient _gradientForType(String type) {
//     switch (type) {
//       case 'Visa':
//         return const LinearGradient(colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)]);
//       case 'MasterCard':
//         return const LinearGradient(colors: [Color(0xFFF44336), Color(0xFF4CAF50)]);
//       case 'American Express':
//         return const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]);
//       case 'Discover':
//         return const LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFFFD54F)]);
//       default:
//         return const LinearGradient(colors: [Color(0xFFC2185B), Color(0xFF5E35B1)]);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('choose Your card'),
//         leading: BackButton(color: Colors.black),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: false,
//         foregroundColor: Colors.black,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
//           child: Obx(() {
//             final type = controller.cardType.value;
//             final bank = controller.bankName.value;
//             final formatted = controller.formattedNumber.value;
//             final expiry = controller.expiry.value;
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('My Card', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
//                 SizedBox(height: 12.h),
//
//                 // Card design (updates based on cardType)
//                 Container(
//                   width: double.infinity,
//                   height: 160.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16.r),
//                     gradient: _gradientForType(type),
//                     boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Bank name + refresh
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(bank.isNotEmpty ? bank : 'Your Bank',
//                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
//                           const Icon(Icons.refresh, color: Colors.white),
//                         ],
//                       ),
//                       const Spacer(),
//                       // Card number
//                       Text(
//                         formatted,
//                         style: TextStyle(color: Colors.white, fontSize: 20.sp, letterSpacing: 1.5, fontWeight: FontWeight.w600),
//                       ),
//                       const Spacer(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Expired Date', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
//                               Text(expiry, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
//                             ],
//                           ),
//                           _cardLogo(type),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 24.h),
//
//                 Text('Change your card', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
//                 SizedBox(height: 12.h),
//
//                 // Input where user types card number, detection happens live
//                 TextField(
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: 'Enter card number',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//                     suffixIcon: type.isEmpty ? null : Padding(
//                       padding: EdgeInsets.only(right: 12.w),
//                       child: _cardLogo(type),
//                     ),
//                   ),
//                   onChanged: (v) => controller.setNumber(v),
//                 ),
//
//                 SizedBox(height: 18.h),
//
//                 Container(
//                   decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
//                   child: Row(
//                     children: [
//                       // small logo
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12.h),
//                         child: _cardLogo(type),
//                       ),
//                       SizedBox(width: 8.w),
//                       Expanded(child: Text(type.isEmpty ? 'Unknown Card' : type, style: TextStyle(fontSize: 15.sp))),
//                       Radio<bool>(
//                         value: true,
//                         groupValue: true,
//                         onChanged: (_) {},
//                         activeColor: Colors.blue,
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 40.h),
//                 // Pay now button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 48.h,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (controller.rawNumber.value.length < 12) {
//                         Get.snackbar('Error', 'Please enter a valid card number', backgroundColor: Colors.redAccent, colorText: Colors.white);
//                         return;
//                       }
//                       Get.snackbar('Success', 'Payment processed', backgroundColor: Colors.green, colorText: Colors.white);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF4C8BFF),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
//                     ),
//                     child: Text('Pay now', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
// // import 'package:flutter/material.dart';
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/global widget/custom_appbar.dart';
import 'package:gym_cheloper/global widget/custom_button.dart';
import 'package:gym_cheloper/utils/app_images.dart';
import 'package:gym_cheloper/viwes/widgets/custom_button.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_controller/subscription_card_controller.dart';


class ChooseYourCardScreen extends StatelessWidget {
  final controller = Get.put(ChooseYourCardController());

  ChooseYourCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Choose Your Card",
        showBackButton: true,
      ),
      body: SafeArea(
        child: Obx(
              () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Card",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),

                /// 💳 Card Design
                Container(
                  width: double.infinity,
                  height: 160.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF53E3E), Color(0xFF2244E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Bank Name + Refresh Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.bankName.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          const Icon(Icons.refresh, color: Colors.white),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        controller.cardNumber.value.replaceAllMapped(
                            RegExp(r".{4}"), (match) => "${match.group(0)} "),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Expired Date",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(
                                controller.expiryDate.value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppImages.masterCard,
                                height: 24.h,
                                width: 42.w,
                              ),
                              SizedBox(width: 4.w),
                              if (controller.cardType.value == "Visa")
                                Image.asset(
                                  "assets/images/visa.png",
                                  height: 24.h,
                                  width: 24.w,
                                ),
                              if (controller.cardType.value == "American Express")
                                Image.asset(
                                  "assets/images/amex.png",
                                  height: 24.h,
                                  width: 24.w,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                Text(
                  "Change your card",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),

                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.masterCard,
                        height: 24.h,
                        width: 42.w,
                      ),
                      SizedBox(width: 8.w),
                      Text("Credit Card",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                          )
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          controller.cardType.value,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      Radio(
                        value: true,
                        groupValue: true,
                        onChanged: (_) {},
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const Spacer(),



                ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),

                  child:  CustomNewButton(
                    title: "Pay now",
                  color: const Color(0xff3971FF),   // button background color
                  titlecolor: Colors.white,
                  onpress: () {
                    Get.snackbar(
                      "Success",
                      "Payment completed successfully!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
