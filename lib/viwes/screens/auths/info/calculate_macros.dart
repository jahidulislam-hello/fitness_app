import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/widgets/custom_text.dart';
import '../../../../utils/utils.dart';
import '../../screens.dart';
import 'package:gym_cheloper/viwes/screens/auths/controller/calculate_controller.dart';

class CalculateMacros extends StatefulWidget {
  const CalculateMacros({super.key});

  @override
  State<CalculateMacros> createState() => _CalculateMacrosState();
}

class _CalculateMacrosState extends State<CalculateMacros> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late CalculateController imperialController;
  late CalculateController metricController;
  bool _hasSubmitted = false; // Prevent duplicate submissions

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    // Initialize controllers with unit system
    imperialController = Get.put(CalculateController(unitSystem: "Imperial"), tag: "imperial");
    metricController = Get.put(CalculateController(unitSystem: "Metric"), tag: "metric");
  }

  @override
  void dispose() {
    tabController.dispose();
    Get.delete<CalculateController>(tag: "imperial");
    Get.delete<CalculateController>(tag: "metric");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(text: "Information".tr, fontsize: 18.sp),
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffBABABA)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: List.generate(2, (index) {
                  bool isSelected = tabController.index == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => tabController.index = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.textColor : const Color(0xffBABABA),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          index == 0 ? "Imperial" : "Metric",
                          style: TextStyle(
                            fontFamily: "Montserrat-Light",
                            color: isSelected ? Colors.white : AppColors.textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Obx(() {
              // Show loading while data is being fetched
              if (imperialController.profileLoading.value && metricController.profileLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              return TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ImperialScreen(
                    tabController: tabController,
                    controller: imperialController,
                  ),
                  MetricScreen(
                    tabController: tabController,
                    controller: metricController,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
