import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_cheloper/utils/app_icons.dart';

import '../../../widgets/widgets.dart';

class InfoCongratulationScreen extends StatelessWidget {
  const InfoCongratulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    SafeArea(
        child:
        Column(
          children: [
            SizedBox(height: 40.h,),
            Center(child: SvgPicture.asset(AppIcons.congraIcon)),
            SizedBox(height: 20.h,),
            CustomText(text: "Congratulations your custom plan is ready",fontsize: 20.sp,),
            SizedBox(height: 30.h,),
            CustomText(text: "You should lose:",),
            SizedBox(height: 20.h,),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(left: 40.w,right: 40.w),
                child: CustomButtonCommon(
                  color: Colors.black,
                  title: '6 kg by September 12'.tr,
                  onpress: () {
                    //  context.pushNamed(RouteNames.calculateMacros);
                    // Validate and trigger sign up

                  },
                ),
              ),
            ),
            SizedBox(height: 20.h,),

            CustomText(text: "Plan based on the following sources, among \nother peer-reviewed medical studies:",),
            SizedBox(height: 10.h,),
            Center(child: BulletPointList()),

            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMacroProgress(800, 2100, Colors.black, "Calories"),
                SizedBox(width: 40.w,),
                _buildMacroProgress(800, 2400, Colors.black, "Protein"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMacroProgress(800, 2100, Colors.black, "Carbs"),
                SizedBox(width: 40.w,),
                _buildMacroProgress(800, 2400, Colors.black, "Fat"),
              ],
            ),
            SizedBox(height: 20.h),
            CustomText(text: "You can always fully customize your macros",),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.center,
              child: CustomButtonCommon(
                title: 'Start your Journey'.tr,
                onpress: () {
                //  context.pushNamed(RouteNames.calculateMacros);
                  // Validate and trigger sign up

                },
              ),
            ),


          ],
        )
    ));
  }

  Widget _buildMacroProgress(int value, int total, Color color,String dailyWeek) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.h,),

        SizedBox(height: 10.h,),
        CircularPercentIndicator(
          radius: 40.0,
          lineWidth: 8.0,
          percent: value / total, // Fill based on the value and total
          center: Text(
            "$value", // Show only the current value
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          progressColor: color, // Color of the progress circle
          backgroundColor: color.withOpacity(0.2), // Subtle background circle
          circularStrokeCap: CircularStrokeCap.round, // Optional: Round the edges of the progress stroke
        ),


        SizedBox(height: 10.h),
        Text('${dailyWeek}',style: TextStyle(fontSize: 10.sp,),),
      ],
    );
  }

}

class BulletPointList extends StatelessWidget {
  final List<String> sources = [
    "Basal metabolic rate",
    "Calorie counting – Harvard",
    "International Society of Sports Nutrition",
    "National Institutes of Health",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: sources.map((source) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 70.w),
            Icon(Icons.circle, size: 8.sp, color: Colors.black),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                source,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}