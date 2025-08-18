import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



import '../utils/utils.dart';

import '../viwes/widgets/widgets.dart';
import 'custom_button.dart';

class CustomCard extends StatelessWidget {
  final String img;
  final String title;
  final String title1;
  final Color? textColor;
  final Color? text2Color;
  final String buttonText;
  final VoidCallback onTap;
  final Color? bgColor;
  final Color? firstTextBgColor;

  const CustomCard({
    super.key, required this.img, required this.title, required this.buttonText, required this.onTap, this.bgColor,this.firstTextBgColor, this.title1 ="" , this.textColor,this.text2Color,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: double.infinity,
      height: sizeH * .20,
      child: Stack(
        children: [

          // ClipRRect(
          //     borderRadius: BorderRadius.circular(sizeH * .022),
          //     child: Image.asset(
          //       img,
          //       width: double.infinity,
          //       fit: BoxFit.cover,
          //     )),
          Container(decoration:
            BoxDecoration(
                color: bgColor ?? Color(0xffE9E9E9) ,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(sizeH * .02)

            ),),
          Padding(
            padding: EdgeInsets.all(sizeH * .02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Center(child: CustomText(text:title,color:  textColor ?? Colors.black,maxline: 2,fontsize: 20.sp,)),
                ),
                SizedBox(
                  width: sizeW*.5,
                  child:  Center(child: HeadingTwo(data:title1 ,color: text2Color ??  Colors.white,fontWeight: FontWeight.w400,)),
                ),

                SizedBox(
                    width: sizeW * .4,
                    child: CustomTextButton(
                      text: buttonText,
                      onTap: onTap,
                      fontSize: 12.sp,
                      padding: sizeH * .002,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
