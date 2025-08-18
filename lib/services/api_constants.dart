
class ApiConstants{
  // static const String baseUrl = "https://asifur5000.sobhoy.com/api/v1";
  // static const String imageBaseUrl = "https://asifur5000.sobhoy.com/";


  static const String baseUrl = "https://escorpion-fitness-asifur-rahman.sarv.live/api/v1";

  static const String imageBaseUrl = "https://escorpion-fitness-asifur-rahman.sarv.live/";



  static const String signUpEndPoint = "/user/register";
  static const String otpEndPoint = "/user/verify-otp";
  static const String signInEndPoint = "/user/login";
  static String infoEndPoint(String id) => "/user-information/create?id=$id";
  static const String resetPassEndPoint = "/user/reset-password";
  static const String getTermsCOnEndPoint = "/terms";
  static const String getAboutEndPoint = "/about";
  static const String getPrivacyEndPoint = "/privacy";
  static const String getUserEndPoint = "/user/my-profile";
  static const String updateProfileEndPoint = "/user/update";
  static const String setPasswordEndPoint = "/user/change-password";
  static const String getMacros = "/macros";
  static const String getWorkoutPlans = "/workout-plan";
  static  String getDayWorkoutPlans(String day) => "/workout-plan/exercise-list?day=$day";












  static const String allSearchBusinessEndPoint = "/businesses?limit=5000";
  static  String allPostCodeEndPoint(String postCode) => "/suburbs?limit=50&postcode=$postCode";
  static String singleBusinessEndPoint(String id) => "/businesses/$id";
  static String singlePortfolioEndPoint(String page, String id) => "/portfolios?page=$page&businessId=$id";
  static String serviceWiseBusinessEndPoint(String serviceId, lat, longs) => "/businesses/?serviceId=$serviceId&limit=50&latitude=$lat&longitude=$longs";
  static const String allServiceEndPoint = "/services?limit=5000";
  static const String userCallEndPoint = "/communications";
  static const String userMessageEndPoint = "/messages";

  static String reviews(String id) => "/reviews?businessId=$id";








  static const String verifyEmailEndPoint = "/user/verify-otp";
  static  String getResendOTPEndPoint(String userId) => "/auth/otp?userId=$userId";
  static const String forgotPassEndPoint = "/user/forget-password";





  static const String userMoreInformationEndPoint = "/user/information";
  static const String allMyPmojiEndPoint = "/sticker/my-sticker";
  static const String passCartIdiEndPoint = "/cart/add-to-cart";
  static const String getCartEndPoint = "/cart/my-cart";

  static const String changePassEndPoint = "/user/change-password";
  static const String promoCodePassEndPoint = "/promo-code/use-promo";
  static const String notificationEndPoint = "/notification/my-notification";
  static String singleGalleryDeleteEndPoint(String id) => "/portfolios/$id";
  static String singleJobsDeleteEndPoint(String id) => "/jobs/$id";
  static  String galleryEndPoint(String page, String id) => "/portfolios?page=$page&businessId=$id";
  static  String providerNotiEndPoint(String page,) => "/notification?page=$page";
  static  String customerJobsEndPoint(String page,) => "/jobs?page=$page";
  static  String customerJobsLongLatEndPoint(String lat, long, ) => "/jobs?latitude=$lat&longitude=$long";
  static  String providerBitsEndPoint(String page,) => "/bits?page=$page";
  static  String providerJobsEndPoint(String page,String businessId) => "/jobs?page=$page&businessId=$businessId";
  static  String providerJobsApplicationEndPoint(String page,String jobId) => "/job-applications?page=$page&jobId=$jobId";

}