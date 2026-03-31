import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_cheloper/utils/app_icons.dart';
import '../../../../routes/routes_name.dart';
import '../../../widgets/widgets.dart';
import '../controller/calculate_controller.dart';

class InfoCongratulationScreen extends StatefulWidget {
  const InfoCongratulationScreen({super.key});

  @override
  State<InfoCongratulationScreen> createState() => _InfoCongratulationScreenState();
}

class _InfoCongratulationScreenState extends State<InfoCongratulationScreen> {
  late CalculateController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CalculateController>();
    // Fetch custom plan data
    controller.fetchCustomPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => context.go(RouteNames.customNavBar),
                  child: const Icon(Icons.arrow_back_ios, size: 24),
                ),
              ),
              SizedBox(height: 20.h),
              Center(child: SvgPicture.asset(AppIcons.congraIcon)),
              SizedBox(height: 20.h),
              CustomText(
                text: "Congratulations\nyour custom plan is ready",
                fontsize: 20.sp,
              ),
              SizedBox(height: 30.h),
              CustomText(text: "You should ${controller.isWeightLoss.value ? 'lose' : 'gain'}:"),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(left: 40.w, right: 40.w),
                  child: Obx(() {
                    final weightText = controller.isWeightLoss.value
                        ? '${controller.weightToLose.value} ${controller.unit.value} by ${_formatDate(controller.goalDate.value)}'
                        : '${controller.weightToLose.value} ${controller.unit.value} by ${_formatDate(controller.goalDate.value)}';
                    return CustomButtonCommon(
                      color: Colors.black,
                      title: weightText,
                      onpress: () {
                        context.go(RouteNames.customNavBar);
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: 20.h),
              CustomText(
                text:
                    "Plan based on the following sources, among \nother peer-reviewed medical studies:",
              ),
              SizedBox(height: 10.h),
              Center(child: BulletPointList()),
              SizedBox(height: 20.h),
              Obx(() {
                final calories = controller.calories.value.toInt();
                final protein = controller.protein.value.toInt();
                final carbs = controller.carbs.value.toInt();
                final fat = controller.fat.value.toInt();
                
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMacroProgress(calories, 2100, Colors.black, "Calories"),
                        SizedBox(width: 40.w),
                        _buildMacroProgress(protein, 2400, Colors.black, "Protein"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMacroProgress(carbs, 2100, Colors.black, "Carbs"),
                        SizedBox(width: 40.w),
                        _buildMacroProgress(fat, 2400, Colors.black, "Fat"),
                      ],
                    ),
                  ],
                );
              }),
              SizedBox(height: 20.h),
              CustomText(text: "You can always fully customize your macros"),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.center,
                child: CustomButtonCommon(
                  title: 'Start your Journey'.tr,
                  onpress: () {
                    context.go(RouteNames.subscriptionScreen);
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return "September 12";
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day} ${_getMonthName(date.month)}, ${date.year}";
    } catch (e) {
      // If parsing fails, return a formatted date 24 days from now
      final futureDate = DateTime.now().add(const Duration(days: 24));
      return "${futureDate.day} ${_getMonthName(futureDate.month)}, ${futureDate.year}";
    }
  }

  String _getMonthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  Widget _buildMacroProgress(int value, int total, Color color, String dailyWeek) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.h),
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 14.0,
          percent: value / total,
          center: Text(
            "$value",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.2),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        SizedBox(height: 10.h),
        Text(dailyWeek, style: TextStyle(fontSize: 10.sp)),
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

  BulletPointList({super.key});

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
