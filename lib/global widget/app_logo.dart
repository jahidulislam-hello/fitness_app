
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,

  });


  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;
    return  SvgPicture.asset(AppIcons.cheloperIcon);
    // return Image.asset(
    //   AppImages.finalLogo,
    //   height: sizeH * .25,
    //   width: sizeW * .6,
    // );
  }
}