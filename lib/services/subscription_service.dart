import 'package:get/get.dart';
import '../models/subscription_model.dart';
import 'api_client.dart';
import 'api_constants.dart';

class SubscriptionService {
  /// Add or update subscription package
  static Future<Response> addSubscription(SubscriptionPackageModel package) async {
    return await ApiClient.postData(
      ApiConstants.addSubscription,
      package.toJson(),
    );
  }

  /// Get all subscription packages
  static Future<Response> getSubscriptions() async {
    return await ApiClient.getData(ApiConstants.getSubscriptions);
  }

  /// Add or update coupon
  static Future<Response> addCoupon(CouponModel coupon) async {
    return await ApiClient.postData(
      ApiConstants.addCoupon,
      coupon.toJson(),
    );
  }

  /// Validate coupon code
  static Future<Response> validateCoupon(String couponCode) async {
    return await ApiClient.postData(
      ApiConstants.validateCoupon,
      {'couponCode': couponCode},
    );
  }
}
