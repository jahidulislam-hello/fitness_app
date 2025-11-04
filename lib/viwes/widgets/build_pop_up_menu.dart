import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/utils.dart';

Widget buildPopupMenuField(List<String> options, {String? selectedValue, required String hintText, ValueChanged<String?>? onChanged, double? width, double? fontsize}) {
  return Container(
    height: 50.h, // Adjust the height here
    width: width?? double.infinity, // Full width
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.r), // Rounded corners
      border: Border.all(color: AppColors.textFieldBorderColor,), // Border styling
      color: Colors.white, // Background color
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text((selectedValue ?? hintText.tr).toLowerCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selectedValue == null
                ? Colors.black.withOpacity(0.5)
                : Colors.black,
            fontSize: fontsize?? 14.sp,
          ),
        ),

        PopupMenuButton<String>(
          onSelected: (String value) {
            if (onChanged != null) {
              onChanged(value);
            }
          },
          icon: Icon(Icons.arrow_drop_down, size: 24.h, color: AppColors.iconColor), // Dropdown icon size
          itemBuilder: (BuildContext context) {
            return options.map((String option) {
              return PopupMenuItem<String>(
                value: option,
                child: Text(option.tr), // Use .tr here to get the translated text
              );
            }).toList();
          },
        ),
      ],
    ),
  );
}