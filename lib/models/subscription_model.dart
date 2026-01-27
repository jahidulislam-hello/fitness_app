class SubscriptionPackageModel {
  final String? id;
  final String packageName;
  final String packageAmount;
  final String packageDuration;
  final List<String> packageFeatures;

  SubscriptionPackageModel({
    this.id,
    required this.packageName,
    required this.packageAmount,
    required this.packageDuration,
    required this.packageFeatures,
  });

  factory SubscriptionPackageModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPackageModel(
      id: json['_id'] as String?,
      packageName: json['packageName'] as String? ?? '',
      packageAmount: json['packageAmount']?.toString() ?? '0',
      packageDuration: json['packageDuration'] as String? ?? '',
      packageFeatures: (json['packageFeatures'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'packageName': packageName,
      'packageAmount': packageAmount,
      'packageDuration': packageDuration,
      'packageFeatures': packageFeatures,
    };
    if (id != null) {
      data['_id'] = id;
    }
    return data;
  }
}

class CouponModel {
  final String? id;
  final String couponCode;
  final String packageDuration;
  final String subscriptions;

  CouponModel({
    this.id,
    required this.couponCode,
    required this.packageDuration,
    required this.subscriptions,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'] as String?,
      couponCode: json['couponCode'] as String? ?? '',
      packageDuration: json['packageDuration'] as String? ?? '',
      subscriptions: json['subscriptions'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'couponCode': couponCode,
      'packageDuration': packageDuration,
      'subscriptions': subscriptions,
    };
    if (id != null) {
      data['_id'] = id;
    }
    return data;
  }
}
