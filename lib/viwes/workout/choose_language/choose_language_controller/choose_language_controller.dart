import 'package:get/get.dart';

class ChooseLanguageController extends GetxController {
  /// Holds the selected language
  RxString selectLanguage = 'English'.obs;

  /// Change the selected language
  void changeLanguage(String language) {
    selectLanguage.value = language;
  }
}
