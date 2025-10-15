// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class CardDetectionController extends GetxController {
// RxString cardNumber = ''.obs;
// RxString cardType = ''.obs;
// RxString bankName = ''.obs;
//
// void detectCardType(String input) {
// cardNumber.value = input.replaceAll(' ', '');
//
// if (cardNumber.value.startsWith('4')) {
// cardType.value = 'Visa';
// bankName.value = 'Chase Bank';
// } else if (cardNumber.value.startsWith('5')) {
// cardType.value = 'MasterCard';
// bankName.value = 'AYC Bank';
// } else if (cardNumber.value.startsWith('3')) {
// cardType.value = 'American Express';
// bankName.value = 'American Express Bank';
// } else if (cardNumber.value.startsWith('6')) {
// cardType.value = 'Discover';
// bankName.value = 'Discover Bank';
// } else {
// cardType.value = 'Unknown';
// bankName.value = 'Unknown Bank';
// }
// }
// }
//
//
//
































//
// import 'package:get/get.dart';
//
// class ChooseYourCardController extends GetxController {
//   // raw card number typed by user
//   RxString rawNumber = ''.obs;
//
//   // derived values
//   RxString formattedNumber = ''.obs; // for display on card
//   RxString cardType = ''.obs; // Visa, MasterCard, American Express, Discover, Debit
//   RxString bankName = ''.obs; // Example bank name from prefix map
//   RxString expiry = '10/28'.obs; // default or from previous screen
//
//   // simple bank mapping by BIN prefix (expand as needed)
//   final Map<String, String> _bankPrefixMap = {
//     // Common MasterCard starting ranges (50-55 and 2221-2720) - short demo keys
//     '5': 'AYCBank',
//     '4': 'VBank',
//     '34': 'AmexBank',
//     '37': 'AmexBank',
//     '6': 'DiscoverBank',
//     '51': 'AYCBank',
//     '52': 'AYCBank',
//     '53': 'AYCBank',
//     '54': 'AYCBank',
//     '55': 'AYCBank',
//     // Add more exact BINs if you have them
//   };
//
//   @override
//   void onInit() {
//     super.onInit();
//     // reactively detect changes
//     ever(rawNumber, (_) => _onNumberChanged(rawNumber.value));
//   }
//
//   void setNumber(String value) {
//     // keep only digits
//     final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
//     rawNumber.value = digits;
//   }
//
//   void _onNumberChanged(String digits) {
//     // Detect card type
//     detectCardType(digits);
//
//     // Format number for display
//     formattedNumber.value = _formatForDisplay(digits);
//
//     // detect bank name using prefixes (try longer prefixes first)
//     bankName.value = _detectBankName(digits);
//   }
//
//   void detectCardType(String digits) {
//     if (digits.isEmpty) {
//       cardType.value = '';
//       return;
//     }
//     // American Express: starts with 34 or 37, length 15
//     if (RegExp(r'^(34|37)').hasMatch(digits)) {
//       cardType.value = 'American Express';
//       return;
//     }
//     // Visa: starts with 4
//     if (digits.startsWith('4')) {
//       cardType.value = 'Visa';
//       return;
//     }
//     // MasterCard: 51-55 or 2221-2720
//     if (RegExp(r'^(5[1-5])').hasMatch(digits) || RegExp(r'^(2(2[2-9]|[3-6][0-9]|7[0-1]|720))').hasMatch(digits)) {
//       cardType.value = 'MasterCard';
//       return;
//     }
//     // Discover: 6011, 65, 644-649
//     if (RegExp(r'^(6011|65|64[4-9])').hasMatch(digits)) {
//       cardType.value = 'Discover';
//       return;
//     }
//     // Fallback: Debit / Unknown
//     cardType.value = 'Debit Card';
//   }
//
//   String _detectBankName(String digits) {
//     if (digits.isEmpty) return '';
//     // Try to match longer prefixes first
//     final possiblePrefixes = _bankPrefixMap.keys.toList()
//       ..sort((a, b) => b.length.compareTo(a.length));
//     for (final p in possiblePrefixes) {
//       if (digits.startsWith(p)) return _bankPrefixMap[p]!;
//     }
//     // fallback names by card type
//     switch (cardType.value) {
//       case 'Visa':
//         return 'VBank';
//       case 'MasterCard':
//         return 'AYCBank';
//       case 'American Express':
//         return 'AmexBank';
//       case 'Discover':
//         return 'DiscoverBank';
//       default:
//         return 'My Bank';
//     }
//   }
//
//   String _formatForDisplay(String digits) {
//     if (digits.isEmpty) return 'XXXX XXXX XXXX XXXX';
//     // Amex format: 4-6-5 (15 digits)
//     if (cardType.value == 'American Express') {
//       final parts = <String>[];
//       final p1 = digits.length >= 4 ? digits.substring(0, 4) : digits;
//       parts.add(p1);
//       if (digits.length > 4) {
//         final p2 = digits.length >= 10 ? digits.substring(4, 10) : digits.substring(4);
//         parts.add(p2);
//       }
//       if (digits.length > 10) {
//         final p3 = digits.substring(10);
//         parts.add(p3);
//       }
//       return parts.join(' ').padRight(17, 'X'); // pad for consistent width
//     }
//     // Default 4-4-4-4 groups
//     final buffer = StringBuffer();
//     for (int i = 0; i < digits.length; i++) {
//       buffer.write(digits[i]);
//       final next = i + 1;
//       if (next % 4 == 0 && next != digits.length && next < 16) buffer.write(' ');
//     }
//     // Pad with X groups if short
//     final result = buffer.toString();
//     if (cardType.value == 'Visa' || cardType.value == 'MasterCard' || cardType.value == 'Discover') {
//       // ensure at least 19 chars (including spaces) for visual stability
//       return result.padRight(19, 'X');
//     }
//     return result;
//   }
// }
// import 'package:flutter/material.dart';




//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//



import 'package:get/get.dart';

class ChooseYourCardController extends GetxController {
  RxString cardNumber = ''.obs;
  RxString cardType = ''.obs;
  RxString bankName = ''.obs;
  RxString expiryDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Example default data (you can set these dynamically from previous screen)
    cardNumber.value = "8763273698730329";
    expiryDate.value = "10/28";
    detectCardType(cardNumber.value);
  }

  /// 🔍 Detect card type based on number pattern
  void detectCardType(String number) {
    if (number.isEmpty) {
      cardType.value = "";
      bankName.value = "";
      return;
    }

    if (number.startsWith('4')) {
      cardType.value = "Visa";
      bankName.value = "VBank";
    } else if (number.startsWith('5')) {
      cardType.value = "MasterCard";
      bankName.value = "AYCBank";
    } else if (number.startsWith('3')) {
      cardType.value = "American Express";
      bankName.value = "AmexBank";
    } else if (number.startsWith('6')) {
      cardType.value = "Discover";
      bankName.value = "DiscoverBank";
    } else {
      cardType.value = "Debit Card";
      bankName.value = "My Bank";
    }
  }
}
