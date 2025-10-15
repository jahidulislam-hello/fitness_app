import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionBuyController extends GetxController {
  // Observables
  RxString code = ''.obs;
  RxString selectedExpireDate = ''.obs;

  // TextEditingControllers
  late TextEditingController packageNameController;
  late TextEditingController cardHolderController;
  late TextEditingController cardNumberController;
  late TextEditingController expireDateController;
  late TextEditingController cvvController;

  @override
  void onInit() {
    super.onInit();
    packageNameController = TextEditingController();
    cardHolderController = TextEditingController();
    cardNumberController = TextEditingController();
    expireDateController = TextEditingController();
    cvvController = TextEditingController();
  }

  @override
  void onClose() {
    packageNameController.dispose();
    cardHolderController.dispose();
    cardNumberController.dispose();
    expireDateController.dispose();
    cvvController.dispose();
    super.onClose();
  }

  /// 📅 Pick expiry date
  Future<void> pickExpireDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xffF93533),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted =
          "${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().substring(2)}";
      expireDateController.text = formatted;
      selectedExpireDate.value = formatted;
    }
  }
}
