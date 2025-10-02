

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../global widget/global_widget.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  void initState(){
   // authController.loginEmailTEController.text = Get.parameters['email'] ?? '';
    super.initState();
  }
TextEditingController emailController = TextEditingController();
 // AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
        appBar: AppBar(
          title: HeadingTwo(data: 'forgetPass'.tr),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(sizeH * .016),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: sizeH*.10,),
                const AppLogo(),
                SizedBox(height: sizeH*.10,),
                Padding(
                  padding: EdgeInsets.all(sizeH * .016),
                  child: Column(
                    children: [
                      //==========================>Text Field<============================

                      ///Email
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: CustomTextField(
                         // controller: authController.loginEmailTEController,
                          controller: emailController,
                          hintText:'globalEmail'.tr,
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 12.w),
                              child: Icon(Icons.email_outlined,color: AppColors.primaryColor,)
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please enter your email'.tr;
                            }else if(!AppConstants.emailValidate.hasMatch(value)){
                              return "Invalid email".tr;
                            }
                            return null;

                          },
                        ),
                      ),
                      SizedBox(
                        height: sizeH * .03,
                      ),

                      //==========================>Otp Button<============================

                      CustomTextButton(
                          text: 'forgetPassButton'.tr,
                          onTap: () {
                            context.pushNamed(RouteNames.otpVerificationScreen);
                            // if(authController.loginEmailTEController.text.isEmpty){
                            //   ToastMessageHelper.errorMessageShowToster("Enter Your Email");
                            // }else{
                            //   authController.forgotHandle(authController.loginEmailTEController.text, "forgot");
                            // }

                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
   // authController.loginEmailTEController.dispose();
  }
}
