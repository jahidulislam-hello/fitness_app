
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../controller/controllers.dart';
import '../../../global widget/global_widget.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {

  final TextEditingController _rePassTEController = TextEditingController();
  final TextEditingController _passTEController = TextEditingController();
 // AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _formInKey = GlobalKey();
  @override
  Widget build(BuildContext context) {

    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title:  HeadingTwo(data: 'resetButton'.tr),
      ),
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(sizeH * .016),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: sizeH*.08,),
            const AppLogo(),
            SizedBox(height: sizeH*.08,),
            Padding(
              padding: EdgeInsets.all(sizeH * .016),
              child: Form(
                key: _formInKey,
                child: Column(
                  children: [
                    //==========================>Text Field<============================

                    ///password
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CustomTextField(
                        controller: _passTEController,
                        isPassword: true,
                        hintText:   'resetNewsPass'.tr,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 12.w),
                          child: Icon(Icons.key,color: AppColors.primaryColor,),
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please enter your Password'.tr;
                          }else if(value.length < 8 || !AppConstants.validatePassword(value)){
                            return "Password: 8 characters min, letters & digits \nrequired".tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    ///password
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CustomTextField(
                        controller: _rePassTEController,
                        isPassword: true,
                          hintText:'resetRePass'.tr,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 12.w),
                          child: Icon(Icons.key,color: AppColors.primaryColor,),
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please enter your Confirm Password'.tr;
                          }else if(_passTEController.text != _rePassTEController.text){
                            return "Not Match Password".tr;
                          }else if(value.length < 8 || !AppConstants.validatePassword(value)){
                            return "Password: 8 characters min, letters & digits \nrequired".tr;
                          }
                          return null;

                        },
                      ),
                    ),

                    SizedBox(
                      height: sizeH * .03,
                    ),
                    //==========================>Reset Pass Button<============================
                    CustomButtonCommon(
                    //  loading: authController.isResetLoading.value,
                        title: 'resetButton'.tr,
                        onpress: () {
                          if(_formInKey.currentState!.validate()){
                          //  authController.resetPassword(_passTEController.text, _rePassTEController.text);
                          }
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passTEController.dispose();
    _rePassTEController.dispose();
    super.dispose();

  }
}
