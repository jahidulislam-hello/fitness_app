

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:go_router/go_router.dart';
import '../../../global widget/global_widget.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';



class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}



class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController otpTEController = TextEditingController();
 // AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(

          title: CustomText(text: 'otpVerifyEmail'.tr ,fontsize: 18.sp, )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizeH * .016),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(sizeH * .016),
                child: Column(
                  children: [
                    SizedBox(height: sizeH*.10,),
                    const AppLogo(),
                    SizedBox(height: sizeH*.10,),
                    //==========================>Otp Field<============================
                    _buildPinCodeTextField(context,otpTEController),
                    SizedBox(height: sizeH * .016),
                    //==========================>Resend Button<============================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeadingThree(data: 'otpDidNtGetCode'.tr),
                        StyleTextButton(text: 'otpResend'.tr, onTap: () {
                          //authController.resendOTP();
                        }),
                      ],
                    ),
                    SizedBox(height: sizeH * .02),
                    //==========================>Otp Button<============================
                    // Obx(()=>
                        CustomButtonCommon(
                         // loading: authController.verifyLoading.value == true,
                          title: 'otpVerifyButton'.tr,
                          onpress: () {
                            context.pushNamed(RouteNames.resetPassScreen);
                            // Check if the widget is mounted before navigating
                            // if (mounted) {
                            //   Get.toNamed(RouteNames.resetPassScreen,preventDuplicates: false);
                            // }
                            // if(Get.parameters['screenType'] == 'forgot'){
                            //
                            //   authController.forgotOtpVerify(otpTEController.text);
                            // }else{
                            //   authController.verifyOtp(otpTEController.text);
                            // }

                          },
                        ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // pin code field
  PinCodeTextField _buildPinCodeTextField(BuildContext context, TextEditingController otpTEController) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;
    return PinCodeTextField(
      textStyle: const TextStyle(color: Colors.black), // Text color
      length: 6, // Number of pin code characters
      obscureText: false,
      animationType: AnimationType.fade, // Animation style
      keyboardType: TextInputType.number, // Numeric input
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.circle, // Circular pin fields
          fieldHeight: sizeH * 0.07, // Adjust height based on screen size
          fieldWidth: sizeW * 0.13, // Adjust width based on screen size
          activeFillColor:AppColors.grayColor,// Active field background color
          selectedFillColor: AppColors.textColor, // Selected field background color
          selectedColor: AppColors.buttonColor, // Border color when selected
          inactiveFillColor: AppColors.grayColor, // Inactive field background color
          inactiveColor: AppColors.buttonColor, // Border color when inactive
          errorBorderColor: AppColors.buttonColor
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent, // Transparent background
      enableActiveFill: true, // Enable filling of active field
      controller: otpTEController, // Controller to manage OTP input
      appContext: context, // Current app context
    );
  }

  @override
  void dispose() {
    // Dispose the TextEditingController before calling super.dispose()
    otpTEController.dispose();
    super.dispose();
  }
}

