
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/controller/auth/auth_controller.dart';
import 'package:gym_cheloper/global%20widget/app_logo.dart';
import 'package:gym_cheloper/global%20widget/custom_button.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/utils/app_colors.dart';
import 'package:gym_cheloper/utils/app_constant.dart';
import 'package:gym_cheloper/utils/custom_text_style.dart';
import 'package:gym_cheloper/viwes/widgets/custom_button_common.dart';
import 'package:gym_cheloper/viwes/widgets/custom_text_field.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {

    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
        appBar: AppBar(
          title: HeadingTwo(data: 'Change Password'.tr),
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
                                return 'Enter Old Password'.tr;
                              }else if(value.length < 8 || !AppConstants.validatePassword(value)){
                                return "Password: 8 characters min, letters & digits \nrequired".tr;
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
                                return 'Enter New Password'.tr;
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
                                return 'Re-enter New Password'.tr;
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
                            title: 'Confirm'.tr,
                            onpress: () {
                              context.pushNamed(RouteNames.basicInformation);
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
