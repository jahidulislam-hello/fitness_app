import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:gym_cheloper/viwes/screens/auths/controller/signin_controller.dart';
import '../../../global widget/global_widget.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formInKey = GlobalKey<FormState>();
  final SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizeH * .016),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: sizeH * .14),
              const AppLogo(),
              SizedBox(height: sizeH * .10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sizeW * .04),
                child: Form(
                  key: _formInKey,
                  child: Column(
                    children: [
                      /// Email
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: CustomTextField(
                          controller:
                          signInController.loginEmailTEController,
                          hintText: 'globalEmail'.tr,
                          prefixIcon: Padding(
                            padding:
                            EdgeInsets.only(left: 16.w, right: 12.w),
                            child: Icon(Icons.email_outlined,
                                color: AppColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email'.tr;
                            } else if (!AppConstants.emailValidate
                                .hasMatch(value)) {
                              return "Invalid email".tr;
                            }
                            return null;
                          },
                        ),
                      ),

                      /// Password
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: CustomTextField(
                          controller:
                          signInController.loginPassTEController,
                          isPassword: true,
                          hintText: 'globalPass'.tr,
                          prefixIcon: Padding(
                            padding:
                            EdgeInsets.only(left: 16.w, right: 12.w),
                            child: Icon(Icons.key,
                                color: AppColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password'.tr;
                            } else if (value.length < 8 ||
                                !AppConstants.validatePassword(value)) {
                              return "Password: 8 characters min, letters & digits required"
                                  .tr;
                            }
                            return null;
                          },
                        ),
                      ),

                      /// Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: StyleTextButton(
                          text: 'signInForgetPass'.tr,
                          onTap: () {
                            Get.toNamed(RouteNames.forgetPassScreen,
                                parameters: {
                                  'email': signInController
                                      .loginEmailTEController.text,
                                },
                                preventDuplicates: false);
                          },
                        ),
                      ),
                      SizedBox(height: sizeH * .016),

                      /// Login Button
                      Obx(() => CustomButtonCommon(
                        loading:
                        signInController.loadingLoading.value,
                        title: 'signInLogin'.tr,
                        onpress: () {
                          if (_formInKey.currentState!.validate()) {
                            signInController.loginHandle(
                              signInController
                                  .loginEmailTEController.text,
                              signInController
                                  .loginPassTEController.text,
                              context,
                            );
                          }
                        },
                      )),

                      SizedBox(height: sizeH * .02),

                      /// Other Buttons (Optional)
                      CustomButtonCommon(
                        title: 'Apple'.tr,
                        color: Colors.black,
                        onpress: () {},
                      ),
                      SizedBox(height: sizeH * .02),
                      CustomButtonCommon(
                        title: 'Google'.tr,
                        color: Colors.black12,
                        titlecolor: Colors.black,
                        onpress: () {},
                      ),

                      SizedBox(height: sizeH * .02),

                      /// Signup Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HeadingThree(
                              data: 'signInDoNtHaveAccount'.tr),
                          StyleTextButton(
                            text: 'signUp'.tr,
                            onTap: () {
                              context.pushNamed(RouteNames.singUpScreen);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
