
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import '../../../../controller/controllers.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class ImperialScreen extends StatefulWidget {
   ImperialScreen({super.key, required this.tabController});
  final TabController tabController;

  @override
  State<ImperialScreen> createState() => _ImperialScreenState();
}

class _ImperialScreenState extends State<ImperialScreen> {
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
                CustomText(text: "What is your Height?".tr,),
                SizedBox(height: sizeH * .01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TextField
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              controller: authController.heightController,
                              hintText: "5".tr,
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
                          Expanded(
                            flex: 1,
                            child: CustomText(text: "ft",),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              controller: authController.heightController,
                              hintText: "5".tr,
                              borderColor: AppColors.textFieldBorderColor,
                              keyboardType: TextInputType.number,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please enter '.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomText(text: "in",),
                          )
                        ],
                      ),
                    ),
          
          
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
                      child: CustomText(text: "lbs",),
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
                      context.pushNamed(RouteNames.calculateMacros);
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


class WeightSlider extends StatefulWidget {
  const WeightSlider({super.key});

  @override
  State<WeightSlider> createState() => _WeightSliderState();
}

class _WeightSliderState extends State<WeightSlider> {
  double _value = 0.8; // initial value

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Labels row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _LabelBox(text: "0.1 kg"),
              _LabelBox(text: "0.8 kg"),
              _LabelBox(text: "1.5 kg"),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 12,
            inactiveTrackColor: Colors.grey.shade300,
            activeTrackColor: Colors.black87,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            min: 0.1,
            max: 1.5,
            value: _value,
            onChanged: (newVal) => setState(() => _value = newVal),
          ),
        ),
      ],
    );
  }
}

class _LabelBox extends StatelessWidget {
  final String text;
  const _LabelBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
      ),
    );
  }
}
