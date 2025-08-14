

import 'package:flutter/material.dart';

import '../../controller/controllers.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // bool isEnglish = true;
  // late VideoPlayerController _controller;
  // // Initialize the video player with your asset video or network video URL
  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize the video player with your asset video or network video URL
  //   _controller = VideoPlayerController.networkUrl(
  //     Uri.parse('https://escorpion-fitness-asifur-rahman.sarv.live/video/intro-video-es.mp4'),
  //   ) // Replace with a network URL if needed
  //     ..initialize().then((_) {
  //       setState(() {
  //         _controller.play(); // Auto-play video
  //       });
  //     });
  //   // Listen for video completion and navigate to the next screen
  //   // _controller.addListener(() async{
  //   //   if (_controller.value.position == _controller.value.duration) {
  //   //     // When the video reaches the end, navigate to the home screen
  //   //
  //   //       // String token = await PrefsHelper.getString(AppConstants.bearerToken);
  //   //       // if(token.isNotEmpty){
  //   //       //   Get.offAllNamed(RouteNames.customNavBar);
  //   //       // }else{
  //   //       //   Get.offAllNamed(RouteNames.signInScreen);
  //   //       // }
  //   //
  //   //
  //   //   }
  //   // });
  // }

  final LocalizationController _localizationController =
  Get.find<LocalizationController>(); // Tracks the current language state

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main image
          // Image.asset(
          //   AppImages.onBoarding,
          //   fit: BoxFit.fitHeight,
          //   height: double.infinity,
          //   width: double.infinity,
          // ),



          // SizedBox(
          //   height: double.infinity,
          //   width: double.infinity,
          //   child: FittedBox(
          //     fit: BoxFit.cover, // Ensures the video covers the full screen
          //     child: SizedBox(
          //       width: _controller.value.size.width,
          //       height: _controller.value.size.height,
          //       child: VideoPlayer(_controller),
          //     ),
          //   ),
          // ),
          // Dark shadow
          Container(color: Colors.black.withOpacity(0.5),),
          // Main content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeW * .12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo
                  // SizedBox(height: sizeH * .03),
                  // Image.asset(
                  //   AppImages.finalLogo,
                  //   height: sizeH * .3,
                  //   width: sizeW * .7,
                  //   color: Colors.white,
                  // ),
                  // SizedBox(height: sizeH * .10),
                  //
                  // // Title
                  // HeadingTwo(
                  //   data: 'onboardingText1'.tr,
                  //   fontSize: sizeH * .030,
                  //   color: AppColors.primaryColor,
                  // ),
                  // SizedBox(height: sizeH * .03),
                  //
                  // // Subtitle
                  // HeadingThree(
                  //   data: 'onboardingText2'.tr,
                  //   fontSize: sizeH * .018,
                  //   color: Colors.white,
                  // ),
                  // SizedBox(height: sizeH * .03),
                  Spacer(),
                  // Button
                  // CustomTextButton(
                  //   text: 'splashButtonText'.tr,
                  //   onTap: () {
                  //     Get.offAllNamed(RouteNames.singUpScreen);
                  //   },
                  // ),
                  // SizedBox(height: sizeH * .01),
                  //
                  // // Already have account
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     HeadingThree(
                  //       data: 'alreadyAccount'.tr,
                  //       fontSize: sizeH * .018,
                  //       color: Colors.white,
                  //     ),
                  //     StyleTextButton(
                  //       text: 'signIn'.tr,
                  //       onTap: () {
                  //         Get.offAllNamed(RouteNames.signInScreen);
                  //       },
                  //     ),
                  //     SizedBox(height: sizeH * .03),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),

          // Language toggle at the top-right
          Positioned(
            top: sizeH * 0.05,
            right: sizeW * 0.05,
            child: Row(
              children: [
                Text(
                  'language_title'.tr,
                  style: TextStyle(color: Colors.white, fontSize: sizeH * 0.02),
                ),
                const SizedBox(width: 8),
                // Toggle for language
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // setState(() {
                          //    = false;
                          //   Get.updateLocale(const Locale('es', 'ES'));
                          // });
                        },
                        child: Text(
                          'Esp',
                          style: TextStyle(
                            color: _localizationController.isLtr
                                ? Colors.grey
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Switch(
                        value: _localizationController.isLtr,
                        onChanged: (value) {
                          setState(() {
                            //   isEnglish = value;
                            //   Get.updateLocale(value
                            //       ? const Locale('en', 'US')
                            //       : const Locale('es', 'ES'));
                            _localizationController.isLtr
                                ? _localizationController
                                .setLanguage(const Locale('es', "ES"))
                                : _localizationController
                                .setLanguage(const Locale('en', "US"));
                          });
                        },
                        activeColor: AppColors.primaryColor,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      ),
                      GestureDetector(
                        onTap: () {
                          // setState(() {
                          //   isEnglish = true;
                          //   Get.updateLocale(const Locale('en', 'US'));
                          // });
                        },
                        child: Text(
                          'Eng',
                          style: TextStyle(
                            color: _localizationController.isLtr
                                ? Colors.white
                                : Colors.grey,
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
        ],
      ),
    );
  }
}