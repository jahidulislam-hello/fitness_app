
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/viwes/screens/screens.dart';

import '../helpers/prefs_helper.dart';
import '../utils/utils.dart';
import 'routes_name.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splashScreen, // Define initial route here
    routes: [


      GoRoute(
        path: RouteNames.splashScreen,
        name: RouteNames.splashScreen,
        builder: (context, state) => SplashScreen(),
        redirect: (context, state) {
          Future.delayed(const Duration(seconds: 3), ()async{
            String token = await PrefsHelper.getString(AppConstants.bearerToken);
            if(token.isNotEmpty){
              // AppRoutes.goRouter.replaceNamed(AppRoutes.customBottomNavBar);
              // Get.find<CustomBottomNavBarController>().onChange(0);
            }else{
              AppRoutes.router.replaceNamed(RouteNames.onboardingScreen);
            }


          });
          return null;
        },
      ),


      // GoRoute(
      //   path: RouteNames.splashScreen,
      //   builder: (context, state) => SplashScreen(),
      // ),

      GoRoute(
        path: RouteNames.onboardingScreen,
        builder: (context, state) => OnboardingScreen(),
      ),


    ],
    // Optionally, define error handling
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text('Page not found!')),
      );
    },
  );
}