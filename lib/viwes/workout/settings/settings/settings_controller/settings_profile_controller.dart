import 'package:get/get.dart';

class SettingsProfileController extends GetxController {
  // 🔹 Loading state
  RxBool isLoading = false.obs;


  RxString profileImage = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;

  // 🔹 Measurement system (Metric / Imperial)
  RxString measurementSystem = 'Metric'.obs;
  RxBool isMeasurementDropdownVisible = false.obs; // Controls popup toggle

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// 🔸 Simulate fetching user profile (you can replace with API call)
  void fetchUserProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    profileImage.value = "https://i.pravatar.cc/150?img=3";
    firstName.value = "John";
    lastName.value = "Doe";
    email.value = "johndoe@example.com";
    isLoading.value = false;
  }

  /// 🔸 Toggle dropdown visibility (if used inline)
  void toggleMeasurementDropdown() {
    isMeasurementDropdownVisible.toggle();
  }

  /// 🔸 Change measurement system (Metric / Imperial)
  void changeMeasurementSystem(String system) {
    measurementSystem.value = system;
    Get.back(); // ✅ Closes popup immediately after selection
  }
}
