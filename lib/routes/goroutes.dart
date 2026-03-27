import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/viwes/workout/settings/edit_profile/edit_profile_screen/edit_profile_screen.dart';
import '../viwes/screens/screens.dart';
import '../viwes/screens/auths/info/info_congratulation_screen.dart';
import '../viwes/workout/buy_package/buy_package_screen/buy_package_screen.dart';

import '../viwes/workout/choose_language/choose_laguage_screen/choose_language_screen.dart';
import '../viwes/workout/exercise/exercise_screen/exercise_screen.dart';
import '../viwes/workout/exercise/exercise_history_screen/exercise_history_screen.dart';
import '../viwes/workout/meal_plan/meal_plan_screen/meal_plan_screen.dart';
import '../viwes/workout/settings/change_password/change_password.dart';
import '../viwes/workout/settings/settings/settings_screen/settings_profile_screen.dart';
import '../viwes/workout/settings/settings/settings_screen/settings_screen.dart';
import '../viwes/workout/settings/privacy_policy/privacy_policy_screen/privacy_policy_screen.dart';
import '../viwes/workout/settings/privacy_policy/privacy_policy_screen/terms_condition_screen.dart';
import '../viwes/workout/subscription_packages/subscription_packages_screen/subscription_buy_screen.dart';
import '../viwes/workout/subscription_packages/subscription_packages_screen/subscription_card_screen.dart';
import '../viwes/workout/subscription_packages/subscription_packages_screen/subscription_code_screen.dart';
import '../viwes/workout/subscription_packages/subscription_packages_screen/Profile_subscription_packages_screen.dart';
import '../viwes/workout/subscription_packages/subscription_packages_screen/add_coupon_screen.dart';
import '../viwes/workout/weight_tracking/weight_tracking_screen/weight_tracking_screen.dart';
import '../viwes/screens/question/question_screen.dart';
import '../viwes/screens/question/quesstion_screen2.dart';
import '../viwes/screens/question/question_screen3.dart';
import '../viwes/screens/question/quesstion_screen4.dart';
import '../viwes/screens/question/question_final_screen.dart';
import '../viwes/screens/auths/select_screen.dart';
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
      // Question Screens
      GoRoute(
        path: RouteNames.fitnessQuestionScreen,
        name: RouteNames.fitnessQuestionScreen,
        builder: (context, state) => const FitnessQuestionScreen(),
      ),
      GoRoute(
        path: RouteNames.fitnessQuestionScreen2,
        name: RouteNames.fitnessQuestionScreen2,
        builder: (context, state) => const QuesstionScreen2(),
      ),
      GoRoute(
        path: RouteNames.fitnessQuestionScreen3,
        name: RouteNames.fitnessQuestionScreen3,
        builder: (context, state) => const QuestionScreen3(),
      ),
      GoRoute(
        path: RouteNames.fitnessQuestionScreen4,
        name: RouteNames.fitnessQuestionScreen4,
        builder: (context, state) => const QuesstionScreen4(),
      ),
      GoRoute(
        path: RouteNames.questionFinalScreen,
        name: RouteNames.questionFinalScreen,
        builder: (context, state) => const QuestionFinalScreen(),
      ),
      GoRoute(
        path: RouteNames.selectScreen,
        name: RouteNames.selectScreen,
        builder: (context, state) => const SelectScreen(),
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
      // Info Congratulation Screen
      GoRoute(
        path: RouteNames.infoCongratulationScreen,
        name: RouteNames.infoCongratulationScreen,
        builder: (context, state) => const InfoCongratulationScreen(),
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
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ExerciseScreen(
            workoutId: extra?['workoutId'],
            trainingName: extra?['trainingName'],
          );
        },
      ),
      GoRoute(
        path: '/exercise-history',
        name: 'exerciseHistory',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ExerciseHistoryScreen(
            workoutId: extra?['workoutId'],
            trainingName: extra?['trainingName'],
          );
        },
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
      GoRoute(
        path: RouteNames.choosecardScreen,
        name: RouteNames.choosecardScreen,
        builder: (context, state) => ChooseYourCardScreen(),
      ),
      GoRoute(
        path: RouteNames.subscriptioncodeScreen,
        name: RouteNames.subscriptioncodeScreen,
        builder: (context, state) => SubscriptionCodeScreen(),
      ),
      GoRoute(
        path: RouteNames.subscriptionbuyScreen,
        name: RouteNames.subscriptionbuyScreen,
        builder: (context, state) => SubscriptionBuyScreen(),
      ),
      GoRoute(
        path: RouteNames.addCouponScreen,
        name: RouteNames.addCouponScreen,
        builder: (context, state) => const AddCouponScreen(),
      ),
      // Privacy & Terms
      GoRoute(
        path: RouteNames.privacyPolicyScreen,
        name: RouteNames.privacyPolicyScreen,
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: RouteNames.termsScreen,
        name: RouteNames.termsScreen,
        builder: (context, state) => const TermsScreen(),
      ),
      // Add more screens as needed...
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found!')),
    ),
  );
}
