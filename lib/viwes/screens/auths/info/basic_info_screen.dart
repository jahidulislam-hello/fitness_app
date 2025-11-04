import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/viwes/screens/auths/controller/basic_info_controller.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key}); // No token needed

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BasicInfoController basicInfoController = Get.put(BasicInfoController());

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Information".tr, fontsize: 18.sp),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(sizeH * .016),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: sizeH * .03),
                  CustomText(text: "Please Enter your Name".tr),
                  SizedBox(height: sizeH * .01),

                  // Name
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: CustomTextField(
                      controller: basicInfoController.nameTEController,
                      hintText: "signUpName".tr,
                      borderColor: AppColors.textFieldBorderColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name'.tr;
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: sizeH * .01),
                  CustomText(text: "Please select your Gender".tr),
                  SizedBox(height: sizeH * .01),

                  // Gender Selection
                  buildPopupMenuField(
                    ['male', 'female'],
                    selectedValue: basicInfoController.selectedGender,
                    hintText: 'Select Gender',
                    onChanged: (String? value) {
                      setState(() {
                        basicInfoController.selectedGender = value;
                      });
                    },
                  ),

                  SizedBox(height: sizeH * .03),
                  CustomText(text: "Please Enter your Age".tr),
                  SizedBox(height: sizeH * .01),

                  // Age
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: CustomTextField(
                      controller: basicInfoController.ageController,
                      hintText: "signUpAge".tr,
                      borderColor: AppColors.textFieldBorderColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Age'.tr;
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: sizeH * .4),

                  // Continue Button
                  Align(
                    alignment: Alignment.center,
                    child: Obx(() => CustomButtonCommon(
                      loading: basicInfoController.basicInfoLoading.value,
                      title: 'Continue'.tr,
                      onpress: () {
                        if (_formKey.currentState!.validate()) {
                          basicInfoController.basicInfo(context);
                        }
                      },
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
