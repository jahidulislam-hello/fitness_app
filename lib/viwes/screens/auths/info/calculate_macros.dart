import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(text: "Information".tr, fontsize: 18.sp),
        leading: InkWell(
          onTap: () => context.pop(),
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
            child: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ImperialScreen(
                  tabController: tabController,
                  controller: Get.put(CalculateController(), tag: "imperial"),
                ),
                MetricScreen(
                  tabController: tabController,
                  controller: Get.put(CalculateController(), tag: "metric"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
