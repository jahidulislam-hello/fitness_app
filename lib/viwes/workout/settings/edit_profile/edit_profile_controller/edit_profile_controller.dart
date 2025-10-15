import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class ProfileInfoController extends GetxController {
  RxBool isLoading = false.obs;
  RxString profileImage = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;
  RxString gender = ''.obs;
  RxString age = ''.obs;
  RxString height = ''.obs;
  RxString weight = ''.obs;
  RxBool isEditMode = false.obs;

  // TextControllers
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    genderController = TextEditingController();
    ageController = TextEditingController(); // ✅ initialized
    heightController = TextEditingController();
    weightController = TextEditingController();// ✅ initialized
    fetchUserProfile();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    genderController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  void fetchUserProfile() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    profileImage.value = 'https://i.pravatar.cc/150?img=3';
    firstName.value = 'John';
    lastName.value = 'Doe';
    email.value = 'john.doe@example.com';
    gender.value = 'Male';
    age.value = '24 yrs';
    height.value = '178 cm';
    weight.value = '55 kg';

    // Fill TextControllers
    fullNameController.text = '${firstName.value} ${lastName.value}';
    emailController.text = email.value;
    genderController.text = gender.value;
    ageController.text = age.value;
    heightController.text = height.value;
    weightController.text = weight.value;

    isLoading.value = false;
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = image.path;
    }
  }

  void updateProfile() {
    final fullName = fullNameController.text.trim();
    final parts = fullName.split(' ');
    firstName.value = parts.first;
    lastName.value = parts.length > 1 ? parts.last : '';

    email.value = emailController.text.trim();
    gender.value = genderController.text.trim();
    age.value = ageController.text.trim();
    height.value = heightController.text.trim();
    weight.value = weightController.text.trim();

    // no navigation here, screen will call Get.back()
  }

}