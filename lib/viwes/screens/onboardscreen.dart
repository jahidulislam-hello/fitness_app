
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gym_cheloper/viwes/widgets/custom_text.dart';
import '../../controller/controllers.dart';
import '../../routes/routes_name.dart';
import '../../utils/utils.dart';
import '../../global widget/global_widget.dart';

import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Your Care Journey Starts Here",
      "description":
      "Whether you're a Nurse, Carer, or Cleaner — we connect you with real opportunities to support people in their homes.",
      "onboardImage": "assets/images/firstOnbordIcon.png",
    },
    {
      "title": "Care When You Can",
      "description":
      "Choose the jobs that fit your availability — morning, evening, or weekends. You're in control.",
      "onboardImage": "assets/images/secondOnbordIcons.png",
    },
    {
      "title": "Track Hours. See Your Earnings.",
      "description":
      "Clock in/out with one tap and keep track of your pay with ease. We make it simple to stay on top of your time.",
      "onboardImage": "assets/images/thirdOnbordIcon.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != currentPage) {
        setState(() {
          currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final LocalizationController _localizationController =
  Get.find<LocalizationController>(); // Tracks the current language state

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sizeW * .12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CarouselSlider Implementation
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 380.h, // You can change the height based on your design
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentPage = index;
                          });
                        },
                      ),
                      items: onboardingData.map((data) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    data["onboardImage"]!,
                                    width: 405.w,
                                    height: 320.h,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
        
                    // Optional: Page Indicator (if required)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                            (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 14.h,
                          width: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Track Your Macros. Log your Workouts. See Results.".tr,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Color(0xff222222)
                      ),
                      textAlign: TextAlign.center,
                    ),
        
                  ],
                ),
              ),
            ),
        
            // Get Started Button
            Positioned(
              bottom: 90.h,
              left: sizeW * 0.12,
              right: sizeW * 0.12,
              child: CustomTextButton(
                text:  'Get Started'.tr,
                onTap: () {
                  context.pushNamed(RouteNames.fitnessQuestionScreen);
        
        
                  // Navigate to next screen
                },
              ),
            ),
        
        
            Positioned(
              bottom: 40.h,
              left: sizeW * 0.20,
              right: sizeW * 0.12,
              child: Row(
                children: [
                  CustomText(text: "Already have an account?",),
                  InkWell(
                      onTap: (){
                        context.pushNamed(RouteNames.signInScreen);
                      },
                      child: CustomText(text: " Log In",color: AppColors.primaryColor,fontWeight: FontWeight.w500,))
                ],
              )
            ),
        
            // Language toggle at the top-right
            Positioned(
              top: sizeH * 0.05,
              right: sizeW * 0.05,
              child:Row(
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
                              'Spanish',
                              style: TextStyle(
                                // color: _localizationController.isLtr
                                //     ? Colors.grey
                                //     : Colors.white,
                                color: Colors.grey,
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
                            activeThumbColor: AppColors.primaryColor,
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
                              'English',
                              style: TextStyle(
                                // color: _localizationController.isLtr
                                //     ? Colors.white
                                //     : Colors.grey,
                                color:  Colors.grey,
        
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
      ),
    );
  }
}
