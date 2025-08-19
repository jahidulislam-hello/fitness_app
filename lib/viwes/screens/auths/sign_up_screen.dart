


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:go_router/go_router.dart';
import '../../../controller/controllers.dart';
import '../../../global widget/global_widget.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {

    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
        appBar: AppBar(
          title: HeadingTwo(data: 'signUpAppBar'.tr),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(sizeH * .016),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: sizeH*.06,),
                const AppLogo(),
                SizedBox(height: sizeH*.04,),
                Padding(
                  padding: EdgeInsets.all(sizeH * .016),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        ///Email
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: CustomTextField(
                            controller: authController.emailTEController,
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
                        ///password
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: CustomTextField(
                            controller:authController.passTEController,
                            isPassword: true,
                            hintText:  'globalPass'.tr,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 12.w),
                              child: Icon(Icons.key, color: AppColors.primaryColor,),
                            ),
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please enter your Password'.tr;
                              }else if(value.length < 8 || !AppConstants.validatePassword(value)){
                                return "Password: 8 characters min, letters & digits \nrequired".tr;
                              }
                              return null;

                            },
                          ),
                        ),

                        ///Con password
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: CustomTextField(
                            controller: authController.confirmPassTEController,
                            isPassword: true,
                            hintText: 'Confirm Password'.tr,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 12.w),
                              child: Icon(Icons.key,color: AppColors.primaryColor,),
                            ),
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please enter your Confirm Password'.tr;
                              }else if(value.length < 8 || !AppConstants.validatePassword(value)){
                                return "Password Not Match".tr;
                              }
                              return null;

                            },
                          ),
                        ),

                        //==========================>Register Button<============================
                        // Obx(()=>
                            CustomButtonCommon(
                                loading: authController.signUpLoading.value == true,
                                title: 'signUp'.tr,
                                onpress: () {
                                  context.pushNamed(RouteNames.basicInfo);
                                  // Get.toNamed(
                                  //     RouteNames.otpVerificationScreen,preventDuplicates: false
                                  // );
                                  // if(_formKey.currentState!.validate()){
                                  //   authController.signUpHandle();
                                  // }

                                }),
                        // ),

                        SizedBox(
                          height: sizeH * .016,
                        ),
                        //==========================>Already Have Account<============================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HeadingThree(
                              data: 'alreadyAccount'.tr,
                            ),
                            StyleTextButton(
                                text: 'signIn'.tr,
                                onTap: () {
                                  context.pushNamed(RouteNames.signInScreen);
                                })
                          ],
                        )
                      ],
                    ),
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
    authController.emailTEController.dispose();
    authController.nameTEController.dispose();
    authController.confirmPassTEController.dispose();
    authController.passTEController.dispose();
  }
}
