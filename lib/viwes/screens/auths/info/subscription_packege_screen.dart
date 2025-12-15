import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../widgets/widgets.dart';

class SubscriptionPackegeScreen extends StatefulWidget {
  const SubscriptionPackegeScreen({super.key});

  @override
  State<SubscriptionPackegeScreen> createState() => _SubscriptionPackegeScreenState();
}

class _SubscriptionPackegeScreenState extends State<SubscriptionPackegeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child:
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [

                    SizedBox(height: 40.h,),
                    Center(child: CustomText(text: "We want to try \nScorpion Fitness for FREE",fontsize: 25.sp,)),
                    SizedBox(height: 40.h,),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 360.h,
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
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    data["onboardImage"]!,
                                    width: 405.w,
                                    height: 290.h,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
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
                    SizedBox(height: 20.h),
                    Stack(
                      children: [
                        SizedBox(
                          height: 150.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 170.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Monthly', style: TextStyle(color: Colors.grey)),
                                    Text('US\$ 12.99/mo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  ],
                                ),
                              ),

                              Container(
                                width: 170.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('3 month', style: TextStyle(color: Colors.grey)),
                                    Text('US\$ 9.74/mo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 16.h,
                            right: 45.w,
                            child: Container(
                              width: 80.w,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black),
                                child: CustomText(text: "Save 25%",color: Colors.white,fontsize: 12.sp,)))
                      ],
                    ),
                    CustomText(text: "Best Price value offer in the market",),
                    Padding(
                      padding:  EdgeInsets.all(8.r),
                      child: CustomButtonCommon(title: "START 5 DAY FREE TRAIL", onpress: (){},color: Colors.black,),
                    ),
                    SizedBox(height: 20.h,),
                    CustomText(text: "5 days free, then US\$ 29,23 per 3 months (US\$ 9.74/mo)",),
                    SizedBox(height: 20.h,),
                    CustomText(text: "You won’t be charged now. Your selected subscription \nwill start after your free trial ends. Cancel anytime in AppStore.",fontsize: 12.sp,),
                    SizedBox(height: 20.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Restore Purchases",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          "Redeem Code",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    CustomText(text: "Any Questions?", fontWeight: FontWeight.w600,
                      fontsize: 14.sp,),
                    SizedBox(height: 20.h,),
                    CustomText(text: "Contact Us at scorpionfitnessapp@gmail.com",
                      fontsize: 14.sp,),
                    SizedBox(height: 50.h,),

                  ],
                ),
              ),
            )
        ),
    );
  }

}

class PricingPlan extends StatelessWidget {
  const PricingPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Monthly Plan
        Container(
          width: 160,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Monthly', style: TextStyle(color: Colors.grey)),
              Text('US\$ 12.99/mo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
        SizedBox(width: 16),

        // 3-month Plan with "Save 25%" badge
        Container(
          width: 160,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.black,
                      child: Text('Save 25%', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
              Text('3 month', style: TextStyle(color: Colors.grey)),
              Text('US\$ 9.74/mo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
      ],
    );
  }
}