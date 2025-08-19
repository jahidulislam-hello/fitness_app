import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          ],
        )
    ));
  }
}
