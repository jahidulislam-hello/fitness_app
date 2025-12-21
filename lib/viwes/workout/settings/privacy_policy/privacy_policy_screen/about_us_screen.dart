import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/global%20widget/custom_appbar.dart';
import 'package:gym_cheloper/viwes/workout/settings/privacy_policy/privacy_policy_controller/all_terms_about_controller.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsPrivacyAboutController());

    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      appBar: CustomAppBar(title: 'About Us'),
      body: Obx(() {
        // Show loading indicator while fetching data
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xffF93533),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshContent(),
          color: Color(0xffF93533),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Section Header from API
                Obx(() => SectionHeader(controller.aboutTitle.value)),
                const SizedBox(height: 20),

                // Section Body from API
                Obx(() => SectionBody(controller.aboutContent.value)),
                const SizedBox(height: 28),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black87,
      ),
    );
  }
}

class SectionBody extends StatelessWidget {
  final String text;

  const SectionBody(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 29, right: 29),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          height: 1.5,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}