
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import '../../../../controller/controllers.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthController authController = Get.put(AuthController());

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: sizeH * .03),
        
                /// Name
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: CustomTextField(
                    controller: authController.nameTEController,
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
        
                /// Gender Selection
                buildPopupMenuField(
                  ['male', 'female'],
                  selectedValue: authController.selectedGender?.tr,
                  hintText: 'hint_gender',
                  onChanged: (String? value) {
                    setState(() {
                      authController.selectedGender = value;
                    });
                  },
                ),
        
                SizedBox(height: sizeH * .4), // Push the button down a bit
        
                /// Sign Up Button
                Align(
                  alignment: Alignment.center,
                  child: CustomButtonCommon(
                    loading: authController.signUpLoading.value == true,
                    title: 'Continue'.tr,
                    onpress: () {
                      context.pushNamed(RouteNames.calculateMacros);
                      // Validate and trigger sign up
        
                    },
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

