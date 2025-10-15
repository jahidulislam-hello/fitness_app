import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/utils/app_colors.dart';
import 'package:gym_cheloper/utils/app_images.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? customTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color backgroundColor;
  final Color iconColor;
  final String? leadingIcon;
  final Color? leadingIconColor;
  final Widget? customLeading;


  const CustomAppBar({
    super.key,
    required this.title,
    this.customTitle,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.customLeading,
    this.leadingIcon,
    this.leadingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,


      // Leading/back button
      leading: customLeading ??
          (showBackButton
              ? IconButton(
            icon: Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: SvgPicture.asset(
                leadingIcon ??
                    AppImages.chevronLeft,
                height: 16.h,
                width: 16.w,
                color: leadingIconColor ?? iconColor,
              ),
            ),
            onPressed: onBackPressed ?? () => Get.back(),
          )
              : null),

      // Title
      title: customTitle ??
          Text(
            title,
            // style: AppTextStyles.H6_Medium.copyWith(color: iconColor),
          ),

      // Actions (developer must pass the color explicitly in SvgPicture.asset)
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);
}