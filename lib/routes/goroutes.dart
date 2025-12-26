import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/viwes/workout/settings/edit_profile/edit_profile_screen/edit_profile_screen.dart';
import '../viwes/screens/screens.dart';
import '../viwes/workout/buy_package/buy_package_screen/buy_package_screen.dart';
import '../viwes/workout/calculate_marcos/calculate_marcos_screen/calculate_marcos_screen.dart';
import '../viwes/workout/choose_language/choose_laguage_screen/choose_language_screen.dart';
import '../viwes/workout/exercise/exercise_screen/exercise_screen.dart';
import '../viwes/workout/meal_plan/meal_plan_screen/meal_plan_screen.dart';
import '../viwes/workout/settings/change_password/change_password.dart';
import '../viwes/workout/settings/settings/settings_screen/settings_profile_screen.dart';
import '../viwes/workout/settings/settings/settings_screen/settings_screen.dart';
import '../viwes/workout/subscription_packages/subscription_packages_screen/subscription_buy_screen.dart';
import '../viwes/workout/subscription_packages/subscription_packages_screen/subscription_card_screen.dart';
import '../viwes/workout/subscription_packages/subscription_packages_screen/subscription_code_screen.dart';
import '../viwes/workout/subscription_packages/subscription_packages_screen/Profile_subscription_packages_screen.dart';
import '../viwes/workout/weight_tracking/weight_tracking_screen/weight_tracking_screen.dart';
import 'routes_name.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splashScreen,
    routes: [
      // Splash
      GoRoute(
        path: RouteNames.splashScreen,
        name: RouteNames.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      // Onboarding
      GoRoute(
        path: RouteNames.onboardingScreen,
        name: RouteNames.onboardingScreen,
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Authentication
      GoRoute(
        path: RouteNames.signInScreen,
        name: RouteNames.signInScreen,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: RouteNames.singUpScreen,
        name: RouteNames.singUpScreen,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RouteNames.forgetPassScreen,
        name: RouteNames.forgetPassScreen,
        builder: (context, state) => const ForgetPassScreen(),
      ),
      GoRoute(
        path: RouteNames.otpVerificationScreen,
        name: RouteNames.otpVerificationScreen,
        builder: (context, state) =>  OtpVerificationScreen(),
      ),
      // Basic Info
      GoRoute(
        path: RouteNames.basicInformation,
        name: RouteNames.basicInformation,
        builder: (context, state) => BasicInfoScreen(),
      ),

      // Calculate Macros
      GoRoute(
        path: RouteNames.calculateMacros,
        name: RouteNames.calculateMacros,
        builder: (context, state) => CalculateMacros(),
      ),
      // Custom NavBar / Dashboard
      GoRoute(
        path: RouteNames.customNavBar,
        name: RouteNames.customNavBar,
        builder: (context, state) => const CustomNavbar(),
      ),
      // Other screens
      GoRoute(
        path: RouteNames.exercise,
        name: RouteNames.exercise,
        builder: (context, state) => const ExerciseScreen(),
      ),
      GoRoute(
        path: RouteNames.mealPlan,
        name: RouteNames.mealPlan,
        builder: (context, state) => const MealScreen(),
      ),
      GoRoute(
        path: RouteNames.weightTrack,
        name: RouteNames.weightTrack,
        builder: (context, state) => const WeightTrackingScreen(),
      ),

      GoRoute(
        path: RouteNames.settingsProfile,
        name: RouteNames.settingsProfile,
        builder: (context, state) => SettingsProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: RouteNames.settings,
        builder: (context, state) => SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.chooseLanguage,
        name: RouteNames.chooseLanguage,
        builder: (context, state) => ChooseLanguageScreen(),
      ),
      GoRoute(
        path: RouteNames.profileInfoScreen,
        name: RouteNames.profileInfoScreen,
        builder: (context, state) => ProfileInfoScreen(),
      ),
      GoRoute(
        path: RouteNames.profilsubscriptionScreen,
        name: RouteNames.profilsubscriptionScreen,
        builder: (context, state) => ProfileSubscriptionScreen(),
      ),
      // Add more screens as needed...
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found!')),
    ),
  );
}
