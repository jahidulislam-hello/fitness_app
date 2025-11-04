import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../controller/calculate_controller.dart';

class ImperialScreen extends StatefulWidget {
  const ImperialScreen({super.key, required this.tabController, required this.controller});
  final TabController tabController;
  final CalculateController controller;

  @override
  State<ImperialScreen> createState() => _ImperialScreenState();
}

class _ImperialScreenState extends State<ImperialScreen> {
  late CalculateController calculateController;

  @override
  void initState() {
    super.initState();
    calculateController = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                CustomText(text: "What is your Height?".tr),
                SizedBox(height: sizeH * .01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              controller: calculateController.ftController,
                              hintText: "5",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Expanded(flex: 1, child: CustomText(text: "ft")),
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
                              controller: calculateController.inchController,
                              hintText: "5",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Expanded(flex: 1, child: CustomText(text: "in")),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sizeH * .02),
                CustomText(text: "Select your activity level"),
                SizedBox(height: sizeH * .01),
                buildPopupMenuField(
                  ['0-2 Workout per week', '3-5 Workout per week', '6+ Workout per week'],
                  selectedValue: calculateController.selectedActivityLevel,
                  hintText: 'Select your activity level',
                  onChanged: (value) {
                    setState(() => calculateController.selectedActivityLevel = value);
                  },
                ),
                SizedBox(height: sizeH * .02),
                CustomText(text: "Goal"),
                SizedBox(height: sizeH * .01),
                buildPopupMenuField(
                  ['cutting', 'maintenance', 'bulking'],
                  selectedValue: calculateController.selectedGoal,
                  hintText: 'Maintenance',
                  onChanged: (value) {
                    setState(() => calculateController.selectedGoal = value);
                  },
                ),
                SizedBox(height: sizeH * .02),
                CustomText(text: "What is your current Weight?"),
                SizedBox(height: sizeH * .01),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: CustomTextField(
                        controller: calculateController.currentLbsController,
                        hintText: "170",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(flex: 1, child: CustomText(text: "lbs")),
                  ],
                ),
                SizedBox(height: sizeH * .02),
                CustomText(text: "What is your objective Weight?"),
                SizedBox(height: sizeH * .01),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: CustomTextField(
                        controller: calculateController.desiredLbsController,
                        hintText: "165",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(flex: 1, child: CustomText(text: "lbs")),
                  ],
                ),
                SizedBox(height: sizeH * .02),
                CustomText(text: "Speed of weight loss per week"),
                SizedBox(height: sizeH * .01),
                Center(child: SizedBox(width: double.infinity, child: ImperialWeightSlider(controller: calculateController))),
                SizedBox(height: sizeH * .02),
                Align(
                  alignment: Alignment.center,
                  child: CustomButtonCommon(
                    title: 'Done'.tr,
                    onpress: () => calculateController.addBasicInfoHandle(isMetric: false, context: context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







class ImperialWeightSlider extends StatefulWidget {
  final CalculateController controller;
  const ImperialWeightSlider({super.key, required this.controller});

  @override
  State<ImperialWeightSlider> createState() => _ImperialWeightSliderState();
}

class _ImperialWeightSliderState extends State<ImperialWeightSlider> {
  double _value = 0.8;

  @override
  void initState() {
    super.initState();
    // Initialize controller value as string
    widget.controller.weightLossSpeed = _value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Labels row
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LabelBox(text: "0.1 lb"),
              _LabelBox(text: "0.8 lb"),
              _LabelBox(text: "1.5 lb"),
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
            divisions: 14,
            value: _value,
            onChanged: (newVal) {
              setState(() => _value = newVal);
              // Convert to string for backend
              widget.controller.weightLossSpeed = newVal.toStringAsFixed(1);
            },
          ),
        ),
        const SizedBox(height: 6),
        Text("${_value.toStringAsFixed(1)} lb/week",
            style: const TextStyle(fontWeight: FontWeight.w500)),
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
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}