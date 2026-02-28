import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/controller/localization_controller.dart';

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
  final LocalizationController _localizationController = Get.find<LocalizationController>();

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
              SizedBox(height: sizeH * 0.05),
              // Language toggle at the top-right
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: sizeW * 0.05),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Spanish',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Switch(
                              value: _localizationController.isLtr,
                              onChanged: (value) {
                                setState(() {
                                  _localizationController.isLtr
                                      ? _localizationController.setLanguage(const Locale('es', "ES"))
                                      : _localizationController.setLanguage(const Locale('en', "US"));
                                });
                              },
                              activeThumbColor: AppColors.primaryColor,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'English',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                            context.go(RouteNames.forgetPassScreen);
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
                        icon: Image.asset('assets/icons/Apple.png', height: 24.h, width: 24.w),
                        onpress: () {},
                      ),
                      SizedBox(height: sizeH * .02),
                      CustomButtonCommon(
                        title: 'Google'.tr,
                        color: Colors.black12,
                        titlecolor: Colors.black,
                        icon: Image.asset('assets/icons/Google.png', height: 24.h, width: 24.w),
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
