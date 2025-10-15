import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/workout/settings/edit_profile/edit_profile_controller/edit_profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gym_cheloper/global%20widget/custom_appbar.dart';
import '../../../../widgets/custom_button.dart';


class ProfileInfoScreen extends StatelessWidget {
  final controller = Get.put(ProfileInfoController());
  final ImagePicker _picker = ImagePicker();

  ProfileInfoScreen({super.key});

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      controller.profileImage.value = picked.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Profile Information",
        showBackButton: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔴 Profile Image with Camera Icon + Red Border
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 1), // thin red border
                        ),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.purple.shade200,
                          backgroundImage:
                          controller.profileImage.value.isNotEmpty
                              ? (controller.profileImage.value
                              .startsWith('http')
                              ? NetworkImage(
                              controller.profileImage.value)
                              : FileImage(
                              File(controller.profileImage.value))
                          as ImageProvider)
                              : null,
                          child: controller.profileImage.value.isEmpty
                              ? Text(
                            _getInitials(
                                "${controller.firstName.value} ${controller.lastName.value}"),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          )
                              : null,
                        ),
                      ),

                      /// 📸 Camera Icon (only visible in edit mode)
                      if (controller.isEditMode.value)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// Name
                _buildLabel("Name"),
                ProfileInfoTile(
                  editable: controller.isEditMode.value,
                  controller: controller.fullNameController,
                  hint: "Enter your name",
                ),
                const SizedBox(height: 16),

                /// Email
                _buildLabel("Email"),
                ProfileInfoTile(
                  editable: controller.isEditMode.value,
                  controller: controller.emailController,
                  hint: "Enter your email",
                ),
                const SizedBox(height: 16),

                /// Gender
                _buildLabel("Gender"),
                ProfileInfoTile(
                  editable: controller.isEditMode.value,
                  controller: controller.genderController,
                  hint: "Enter your gender",
                ),
                const SizedBox(height: 16),

                /// Age
                _buildLabel("Age"),
                ProfileInfoTile(
                  editable: controller.isEditMode.value,
                  controller: controller.ageController,
                  hint: "Enter your age",
                ),
                const SizedBox(height: 16),

                /// Height
                _buildLabel("Height"),
                ProfileInfoTile(
                  editable: controller.isEditMode.value,
                  controller: controller.heightController,
                  hint: "Enter your height",
                ),
                const SizedBox(height: 16),

                /// Weight
                _buildLabel("Weight"),
                ProfileInfoTile(
                  editable: controller.isEditMode.value,
                  controller: controller.weightController,
                  hint: "Enter your weight",
                ),

                const SizedBox(height: 32),

                /// 🔘 Edit / Update Button
                CustomNewButton(
                  title: controller.isEditMode.value
                      ? "Update Profile"
                      : "Edit Profile",
                  onpress: () {
                    if (controller.isEditMode.value) {
                      // Save logic
                      controller.updateProfile();
                    }
                    controller.toggleEditMode();
                  },
                  color: controller.isEditMode.value
                      ? Colors.red
                      : Colors.black,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(color: Colors.black, fontSize: 14),
  );
}



class ProfileInfoTile extends StatelessWidget {
  final bool editable;
  final TextEditingController controller;
  final String hint;

  const ProfileInfoTile({
    super.key,
    required this.editable,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF222222), width: 1),
      ),
      alignment: Alignment.centerLeft,
      child: editable
          ? TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle:
          const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16),
      )
          : Text(
        controller.text.isNotEmpty ? controller.text : hint,
        style: const TextStyle(color: Color(0xFF222222), fontSize: 16),
      ),
    );
  }
}
