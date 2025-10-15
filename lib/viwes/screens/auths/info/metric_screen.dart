
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import '../../../../controller/controllers.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import 'package:go_router/go_router.dart';

import 'imperial_screen.dart';

class MetricScreen extends StatefulWidget {
  final TabController tabController;
   const MetricScreen({super.key, required this.tabController});

  @override
  State<MetricScreen> createState() => _MetricScreenState();
}

class _MetricScreenState extends State<MetricScreen> {
  AuthController authController = Get.put(AuthController());



  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TextField
                    Expanded(
                      flex: 4,
                      child: CustomTextField(
                        controller: authController.heightController,
                        hintText: "176".tr,
                        borderColor: AppColors.textFieldBorderColor,
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please enter Age'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
          
                    SizedBox(width: 8.w), // Spacer between TextField and Dropdown
                    Expanded(
                      flex: 1,
                      child: CustomText(text: "cm",),
                    )
                  ],
                ),
                SizedBox(height: sizeH * .02),
                // Age Input
                CustomText(text: "Select your activity level".tr,),
                SizedBox(height: sizeH * .01),
                ///=============Name===================
                buildPopupMenuField(
                  ['0-2 Workout per week', '3-5 Workout per week', '6+ Workout per week'],
                  selectedValue: authController.selectedActivityLevel?.tr,
                  hintText: 'Select your activity level',
                  onChanged: (String? value) {
                    setState(() {
                      authController.selectedActivityLevel = value;
                      print(value);
                    });
                  },
          
                ),
          
                SizedBox(height: sizeH * .02),
                // Age Input
                CustomText(text: "Goal".tr,),
                SizedBox(height: sizeH * .01),
                ///=============Name===================
                buildPopupMenuField(
                  ['Cutting', 'Maintenance', 'Bulking'],
                  selectedValue: authController.selectedGoal?.tr,
                  hintText: 'Maintenance',
                  onChanged: (String? value) {
                    setState(() {
                      authController.selectedGoal = value;
                      print(value);
                    });
                  },
          
                ),
          
                SizedBox(height: sizeH * .02),
          
                ///===============Which meals do you do a day?=========================================
                CustomText(text: "What is your current Weight? ".tr ,),
                SizedBox(height: sizeH * .01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TextField
                    Expanded(
                      flex: 4,
                      child: CustomTextField(
                        controller: authController.currentHeightController,
                        hintText: "176".tr,
                        borderColor: AppColors.textFieldBorderColor,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'current Weight?'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
          
                    Expanded(
                      flex: 1,
                      child: CustomText(text: "lbs",),
                    )
                  ],),
          
                SizedBox(height: sizeH * .02),
          
                ///===============Which meals do you do a day?=========================================
                CustomText(text: "What is your objective Weight? ".tr ,),
                SizedBox(height: sizeH * .01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TextField
                    Expanded(
                      flex: 4,
                      child: CustomTextField(
                        controller: authController.objectiveHeightController,
                        hintText: "176".tr,
                        borderColor: AppColors.textFieldBorderColor,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'objective Weight?'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
          
                    Expanded(
                      flex: 1,
                      child: CustomText(text: "kg",),
                    )
                  ],),
          
                SizedBox(height: sizeH * .02),
          
                ///===============Which meals do you do a day?=========================================
                CustomText(text: "Speed of weight loss per week".tr ,),
                SizedBox(height: sizeH * .01),
                Center(child: SizedBox(width: double.infinity, child: WeightSlider())),
                SizedBox(height: sizeH * .02),
                Align(
                  alignment: Alignment.center,
                  child: CustomButtonCommon(
          
                    title: 'Done'.tr,
                    onpress: () {
                      context.pushNamed(RouteNames.infoCongratulationScreen);
                      // Validate and trigger sign up
          
                    },
                  ),
                ),
                SizedBox(height: sizeH * .01),
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
