import 'package:flutter/material.dart';

import 'app_colors.dart';

class HeadingTwo extends StatelessWidget {
  final String data;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final Color? backGroundColor;
  const HeadingTwo({
    super.key,
    required this.data,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.sizeOf(context).height;

    return Text(
      data,
      style: TextStyle(
        color: color ?? AppColors.textColor,
        fontSize: fontSize ?? sizeHeight * .025,
        backgroundColor: backGroundColor,
        fontFamily: 'Exo_2',
      ),
    );
  }
}

class HeadingThree extends StatelessWidget {
  final String data;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final Color? backGroundColor;
  const HeadingThree({
    super.key,
    required this.data,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.sizeOf(context).height;
    return Text(
      data,
      style: TextStyle(
        color: color ?? AppColors.textColor,
        fontSize: fontSize ?? sizeHeight * 0.02,

        backgroundColor: backGroundColor,
        fontFamily: 'Lora',
      ),
    );
  }
}
