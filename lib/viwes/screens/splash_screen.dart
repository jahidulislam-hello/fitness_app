
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../helpers/helpers.dart';
import '../../routes/routes_name.dart';
import '../../utils/utils.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward(); // Automatically start the animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Navigate after splash screen duration
    _goNext();
  }
  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 3));

    String token = await PrefsHelper.getString(AppConstants.bearerToken);

    if (token.isNotEmpty) {
      context.goNamed(RouteNames.signInScreen);
    } else {
      context.goNamed(RouteNames.onboardingScreen);
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ScaleTransition(
                scale: _scaleAnimation,
                child: SvgPicture.asset(AppIcons.cheloperIcon),
              );
            },
          ),
        ),
      ),
    );
  }
}
