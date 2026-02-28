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

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  final GlobalKey<FormState> _formInKey = GlobalKey<FormState>();
  final SignInController signInController = Get.put(SignInController
    ());
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
                      // Toggle for language
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

                      Center(
                        child: Text("Sign Up With"),
                      ),


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
                      CustomButtonCommon(
                        title: 'Email'.tr,
                        color: Colors.black12,
                        titlecolor: Colors.black,
                        icon: Image.asset('assets/icons/email.png', height: 24.h, width: 24.w),
                        onpress: () {},
                      ),

                      SizedBox(height: sizeH * .02),

                      /// Signup Navigation
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
                      ),


                      SizedBox(height: sizeH * .02),

                      // Terms & Conditions and Privacy Policy
                      Column(
                        children: [
                          Text(
                            "By continuing you agree to the",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.pushNamed(RouteNames.termsScreen);
                                },
                                child: Text(
                                  "Terms & Conditions",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(
                                " and ",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black54,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  context.pushNamed(RouteNames.privacyPolicyScreen);
                                },
                                child: Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
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
