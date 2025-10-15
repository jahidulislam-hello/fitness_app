import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionCodeController extends GetxController {
  RxString code = ''.obs;

  late TextEditingController codeController;

  @override
  void onInit() {
    super.onInit();
    codeController = TextEditingController();
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}
