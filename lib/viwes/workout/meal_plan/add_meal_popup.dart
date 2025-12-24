import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_plan_controller/add_meal_controller.dart';
import 'package:gym_cheloper/utils/app_icons.dart';

class AddMealPopup extends StatelessWidget {
  final String selectedDate;

  const AddMealPopup({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddMealController());
    controller.selectedDate = selectedDate;

    // Load data after initializing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.selectedDate.isNotEmpty) {
        controller.loadTabData();
      }
    });

    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Add Meal',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
      body: Column(
        children: [
          // Search Bar with Three Dots
          _buildSearchBar(context, controller),

          SizedBox(height: 12.h),

          // Tab Bar
          _buildTabBar(controller),

          SizedBox(height: 16.h),

          // Content Area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffF93533),
                  ),
                );
              }

              return _buildTabContent(controller);
            }),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AddMealController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search food...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 20.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () {
              _showOptionsMenu(context);
            },
            child: Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.more_vert,
                color: Colors.black87,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(AddMealController controller) {
    return Container(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.tabs.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedTabIndex.value == index;
            return GestureDetector(
              onTap: () => controller.changeTab(index),
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xffF93533) : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? Color(0xffF93533) : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    controller.tabs[index],
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildTabContent(AddMealController controller) {
    switch (controller.selectedTabIndex.value) {
      case 0: // My Food
        return _buildMyFoodTab(controller);
      case 1: // My Recipe
        return _buildMyRecipeTab(controller);
      case 2: // Favourite
        return _buildFavouriteTab(controller);
      case 3: // Search Food
        return _buildSearchFoodTab(controller);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildMyFoodTab(AddMealController controller) {
    return Obx(() {
      if (controller.myFoodList.isEmpty) {
        return _buildEmptyState('No food items found');
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.myFoodList.length,
        itemBuilder: (context, index) {
          final item = controller.myFoodList[index];
          return _buildFoodItemCard(item, controller);
        },
      );
    });
  }

  Widget _buildMyRecipeTab(AddMealController controller) {
    return Obx(() {
      if (controller.myRecipeList.isEmpty) {
        return _buildEmptyState('No recipes found');
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.myRecipeList.length,
        itemBuilder: (context, index) {
          final item = controller.myRecipeList[index];
          return _buildFoodItemCard(item, controller);
        },
      );
    });
  }

  Widget _buildFavouriteTab(AddMealController controller) {
    return Obx(() {
      if (controller.favouriteList.isEmpty) {
        return _buildEmptyState('No favourite items');
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.favouriteList.length,
        itemBuilder: (context, index) {
          final item = controller.favouriteList[index];
          return _buildFoodItemCard(item, controller);
        },
      );
    });
  }

  Widget _buildSearchFoodTab(AddMealController controller) {
    return Obx(() {
      if (controller.isSearching.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Color(0xffF93533),
          ),
        );
      }

      if (controller.searchQuery.value.isEmpty) {
        return _buildEmptyState('Search for food items');
      }

      if (controller.searchResults.isEmpty) {
        return _buildEmptyState('No results found');
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.searchResults.length,
        itemBuilder: (context, index) {
          final item = controller.searchResults[index];
          return _buildSearchFoodItemCard(item, controller);
        },
      );
    });
  }

  Widget _buildFoodItemCard(FoodItem item, AddMealController controller) {
    final nutrition = item.nutritionValue;
    final calories = nutrition['calories']?.toDouble() ?? 0.0;
    final protein = nutrition['protein']?.toDouble() ?? 0.0;
    final carbs = nutrition['carbs']?.toDouble() ?? 0.0;
    final fat = nutrition['fat']?.toDouble() ?? 0.0;

    return GestureDetector(
      onTap: () => controller.selectFood(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.foodName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (item.isFavourite)
                  Icon(
                    Icons.favorite,
                    color: Color(0xffF93533),
                    size: 18.sp,
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              '${item.quantity} ${item.serving}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                _buildNutritionChip('${calories.toStringAsFixed(0)} kcal'),
                _buildNutritionChip('C: ${carbs.toStringAsFixed(1)}g'),
                _buildNutritionChip('P: ${protein.toStringAsFixed(1)}g'),
                _buildNutritionChip('F: ${fat.toStringAsFixed(1)}g'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFoodItemCard(SearchFoodItem item, AddMealController controller) {
    return GestureDetector(
      onTap: () => controller.selectSearchFood(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Row(
          children: [
            // Food Image
            if (item.photoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  item.photoUrl!,
                  width: 50.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.restaurant,
                        color: Colors.grey[400],
                        size: 24.sp,
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.grey[400],
                  size: 24.sp,
                ),
              ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.foodName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${item.servingQty.toStringAsFixed(0)} ${item.servingUnit}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _buildNutritionChip('${item.calories.toStringAsFixed(0)} kcal'),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Color(0xffF93533),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),

            // Create Food
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.snackbar(
                  'Info',
                  'Create Food feature coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create Food',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SvgPicture.asset(
                      AppIcons.food,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ],
                ),
              ),
            ),

            Divider(height: 1, thickness: 1, color: Colors.grey[200]),

            // Create Recipe
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.snackbar(
                  'Info',
                  'Create Recipe feature coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create Recipe',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SvgPicture.asset(
                      AppIcons.recipe,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
