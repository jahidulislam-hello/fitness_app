
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/viwes/workout/buy_package/buy_package_screen/buy_package_screen.dart';
import 'package:gym_cheloper/viwes/workout/calculate_marcos/calculate_marcos_screen/calculate_marcos_screen.dart';
import 'package:gym_cheloper/viwes/workout/exercise/exercise_screen/exercise_screen.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_plan_screen/meal_plan_screen.dart';
import 'package:gym_cheloper/viwes/workout/settings/edit_profile/edit_profile_screen/edit_profile_screen.dart';
import 'package:gym_cheloper/viwes/workout/settings/settings/settings_screen/settings_profile_screen.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_screen/subscription_buy_screen.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_screen/subscription_card_screen.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_screen/subscription_code_screen.dart';
import 'package:gym_cheloper/viwes/workout/subscription_packages/subscription_packages_screen/subscription_packages_screen.dart';
import 'package:gym_cheloper/viwes/workout/weight_tracking/weight_tracking_screen/weight_tracking_screen.dart';
import '../viwes/screens/screens.dart';
import 'routes_name.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splashScreen, // Define initial route here
    routes: [

      GoRoute(
        path: RouteNames.splashScreen,
        name: RouteNames.splashScreen,
        builder: (context, state) =>  SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboardingScreen,
        name: RouteNames.onboardingScreen,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.fitnessQuestionScreen,
        name: RouteNames.fitnessQuestionScreen,
        builder: (context, state) =>  FitnessQuestionScreen(),
      ),
      GoRoute(
        path: RouteNames.fitnessQuestionScreen2,
        name: RouteNames.fitnessQuestionScreen2,
        builder: (context, state) =>  QuesstionScreen2(),
      ),
      GoRoute(
        path: RouteNames.fitnessQuestionScreen3,
        name: RouteNames.fitnessQuestionScreen3,
        builder: (context, state) =>  QuestionScreen3(),
      ),
      GoRoute(
        path: RouteNames.fitnessQuestionScreen4,
        name: RouteNames.fitnessQuestionScreen4,
        builder: (context, state) =>  QuesstionScreen4(),
      ),

      GoRoute(
        path: RouteNames.questionFinalScreen,
        name: RouteNames.questionFinalScreen,
        builder: (context, state) =>  QuestionFinalScreen(),
      ),
      GoRoute(
        path: RouteNames.signInScreen,
        name: RouteNames.signInScreen,
        builder: (context, state) =>  SignInScreen(),
      ),
      GoRoute(
        path: RouteNames.forgetPassScreen,
        name: RouteNames.forgetPassScreen,
        builder: (context, state) =>  ForgetPassScreen(),
      ),
      GoRoute(
        path: RouteNames.otpVerificationScreen,
        name: RouteNames.otpVerificationScreen,
        builder: (context, state) =>  OtpVerificationScreen(),
      ),
      GoRoute(
        path: RouteNames.resetPassScreen,
        name: RouteNames.resetPassScreen,
        builder: (context, state) =>  ResetPassScreen(),
      ),
      GoRoute(
        path: RouteNames.singUpScreen,
        name: RouteNames.singUpScreen,
        builder: (context, state) =>  SignUpScreen(),
      ),
      GoRoute(
        path: RouteNames.basicInfo,
        name: RouteNames.basicInfo,
        builder: (context, state) =>  BasicInfoScreen(),
      ),
      GoRoute(
        path: RouteNames.calculateMacros,
        name: RouteNames.calculateMacros,
        builder: (context, state) =>  CalculateMacros(),
      ),
      GoRoute(
        path: RouteNames.infoCongratulationScreen,
        name: RouteNames.infoCongratulationScreen,
        builder: (context, state) =>  InfoCongratulationScreen(),
      ),
      GoRoute(
        path: RouteNames.subscriptionScreen,
        name: RouteNames.subscriptionScreen,
        builder: (context, state) =>  SubscriptionPackegeScreen(),
      ),
      GoRoute(
        path: RouteNames.customNavBar,
        name: RouteNames.customNavBar,
        builder: (context, state) =>  CustomNavbar(),
      ),
      GoRoute(
        path: RouteNames.exercise,
        name: RouteNames.exercise,
        builder: (context, state) =>  ExerciseScreen(),
      ),
      GoRoute(
        path: RouteNames.mealPlan,
        name: RouteNames.mealPlan,
        builder: (context, state) =>  MealScreen(),
      ),
      GoRoute(
        path: RouteNames.weightTrack,
        name: RouteNames.weightTrack,
        builder: (context, state) =>  WeightTrackingScreen(),
      ),
      GoRoute(
        path: RouteNames.calculateMacro,
        name: RouteNames.calculateMacro,
        builder: (context, state) =>  CalculateMacrosScreen(),
      ),
      GoRoute(
        path: RouteNames.settingsProfile,
        name: RouteNames.settingsProfile,
        builder: (context, state) =>  SettingsProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.profileInfoScreen,
        name: RouteNames.profileInfoScreen,
        builder: (context, state) =>  ProfileInfoScreen(),
      ),

      GoRoute(
        path: RouteNames.buypackScreen,
        name: RouteNames.buypackScreen,
        builder: (context, state) =>  BuyPackageScreen(),
      ),
      GoRoute(
        name: RouteNames.subscriptionbuyScreen,
        path: RouteNames.subscriptionbuyScreen,
        builder: (context, state) =>  SubscriptionBuyScreen(),
      ),
      GoRoute(
        name: RouteNames.subscriptioncodeScreen,
        path: RouteNames.subscriptioncodeScreen,
        builder: (context, state) =>  SubscriptionCodeScreen(),
      ),
      GoRoute(
        name: RouteNames.choosecardScreen,
        path: RouteNames.choosecardScreen,
        builder: (context, state) =>  ChooseYourCardScreen(),
      ),


      //
      // GoRoute(
      //   path: RouteNames.splashScreen,
      //   name: RouteNames.splashScreen,
      //   builder: (context, state) => SplashScreen(),
      //   redirect: (context, state) {
      //     Future.delayed(const Duration(seconds: 3), ()async{
      //       String token = await PrefsHelper.getString(AppConstants.bearerToken);
      //       if(token.isNotEmpty || token == ""){
      //         // AppRoutes.goRouter.replaceNamed(AppRoutes.customBottomNavBar);
      //         // Get.find<CustomBottomNavBarController>().onChange(0);
      //       }else{
      //         AppRoutes.router.replaceNamed(RouteNames.onboardingScreen);
      //       }
      //
      //
      //     });
      //     return null;
      //   },
      // ),



    ],
    // Optionally, define error handling
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text('Page not found!')),
      );
    },
  );
}