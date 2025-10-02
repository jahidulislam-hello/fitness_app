import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/widgets/custom_text.dart';

import '../../../controller/controllers.dart';
import '../../../global widget/global_widget.dart';
import '../../../models/models.dart';

import '../../../utils/utils.dart';
import '../screens.dart';


class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => CustomNavbarState();
}

class CustomNavbarState extends State<CustomNavbar> {
  // HomeController homeController = Get.put(HomeController());
  int currentIndex = 0;

  final screens = [
    WorkoutScreen(),
    CircularProgressIndicator(),
    CircularProgressIndicator(),
    //  HomeScreen(),
    // const WorkoutScreen(),
    // // const ChatScorpion(),
    // const MealPlanScreen(),
    // const ProgressScreen(),
  ];
  @override
  void initState() {
    super.initState();
    // Register this state to be found by Get.find<CustomNavbarState>()
   // homeController.getMacrosData();
    Get.put(this);
  }

  // Method to update the current index from external sources
  // void setCurrentIndex(int index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }

  // List<WorkoutPlanResponseModel> selectedWorkoutPlans = [];
  //
  // void setCurrentIndex(int index, {List<WorkoutPlanResponseModel>? workoutPlans}) {
  //   setState(() {
  //     currentIndex = index;
  //     if (workoutPlans != null) {
  //       selectedWorkoutPlans = workoutPlans;
  //     }
  //   });
  // }
  //

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppLogo(),
        ),
        // currentIndex == 0 ? Column(
        //  crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     HeadingThree(data: 'home_hello'.tr, color: AppColors.primaryColor),
        //    Obx((){
        //      return homeController.getMyCouponResponseModel.value.name == "" ?CustomText(text: "user",): HeadingThree(data: '${homeController.getMyCouponResponseModel.value.name ?? "N/A"} ✨');
        //    }),
        //   ],
        // ):null,
        actions: [
          IconButton(onPressed: () {}, icon: AppIcons.fire),
          IconButton(onPressed: () {
        //    Get.toNamed(RouteNames.cartScreen,preventDuplicates: false);
          }, icon: Icon(Icons.shopping_cart_outlined),),
          InkWell(
            onTap: () {
         //     Get.toNamed(RouteNames.profileScreen);
            },
            child:
            // Obx(()=>
              CircleAvatar(
                radius: sizeH * .02,
            //    backgroundImage: NetworkImage("${ApiConstants.imageBaseUrl}${homeController.getMyCouponResponseModel.value.image}"),
              ),
            // ),
          ),
          SizedBox(width: sizeW * .02),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: _buildBottomNavBar(sizeH, sizeW),
    );
  }

  Widget _buildBottomNavBar(double sizeH, double sizeW) {
    return Container(
      height: sizeH * .08,
      margin: EdgeInsets.all(sizeH * .01),
      padding: EdgeInsets.symmetric(horizontal: sizeW * .04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sizeH * .04),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

           _buildNavItem(Icons.fitness_center, 0, true),
          _buildNavItem(Icons.restaurant, 1, true),
          _buildNavItem(Icons.show_chart, 2,true),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, bool isIcon) {
    final sizeH = MediaQuery.of(context).size.height;
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isIcon == true ?  Icon(icon, color: isSelected ? AppColors.primaryColor : Colors.grey, size: sizeH * .03): SvgPicture.asset( AppIcons.chatIcon,width: 30.w,height: 30.h, colorFilter: ColorFilter.mode(
            isSelected ? AppColors.primaryColor : Colors.grey,
            BlendMode.srcIn,
          ),),
          if (isSelected)
            Padding(
              padding: EdgeInsets.only(top: sizeH * .004),
              child: Container(
                height: 3.h,
                width: 25.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
