
// ==================== CONTROLLER ====================
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gym_cheloper/viwes/workout/weight_tracking/weight_bottomsheet.dart';
import 'package:gym_cheloper/viwes/workout/weight_tracking/weight_tracking_screen/weight_tracking_screen.dart';

class WeightTrackingController extends GetxController {
  // Weight entries list
  var weightEntries = <WeightEntry>[].obs;

  // Form controllers for popup
  final weightController = TextEditingController();
  final bodyFatController = TextEditingController();
  final waistController = TextEditingController();
  final armController = TextEditingController();
  final calvesController = TextEditingController();
  final thighController = TextEditingController();
  final neckController = TextEditingController();

  // Selected date
  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _loadWeightData();
  }

  void _loadWeightData() {
    // Mock data - replace with actual API call
    weightEntries.value = [
      WeightEntry(
        weight: 87.1,
        date: DateTime(2025, 10, 25),
        bodyFat: 13,
        waist: 80,
        neck: 40,
        arm: 40.5,
        calves: 39,
        thigh: 61,
      ),
      WeightEntry(
        weight: 89.0,
        date: DateTime(2025, 10, 27),
        bodyFat: 15,
        waist: 82,
        neck: 41,
        arm: 41,
        calves: 40,
        thigh: 62,
      ),
    ];
  }

  void showWeightInputDialog(BuildContext context) {
    // Clear previous inputs
    clearInputs();
    selectedDate.value = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WeightInputBottomSheet(controller: this),
    );
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  void submitWeight() {
    if (weightController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter weight');
      return;
    }

    final newEntry = WeightEntry(
      weight: double.tryParse(weightController.text) ?? 0,
      date: selectedDate.value,
      bodyFat: int.tryParse(bodyFatController.text),
      waist: double.tryParse(waistController.text),
      neck: double.tryParse(neckController.text),
      arm: double.tryParse(armController.text),
      calves: double.tryParse(calvesController.text),
      thigh: double.tryParse(thighController.text),
    );

    weightEntries.insert(0, newEntry);
    Get.back(); // Close bottom sheet
    Get.snackbar('Success', 'Weight entry added successfully');
  }

  void clearInputs() {
    weightController.clear();
    bodyFatController.clear();
    waistController.clear();
    armController.clear();
    calvesController.clear();
    thighController.clear();
    neckController.clear();
  }

  // Get latest weight entry
  WeightEntry? get latestEntry =>
      weightEntries.isNotEmpty ? weightEntries.first : null;

  @override
  void onClose() {
    weightController.dispose();
    bodyFatController.dispose();
    waistController.dispose();
    armController.dispose();
    calvesController.dispose();
    thighController.dispose();
    neckController.dispose();
    super.onClose();
  }
}

// ==================== MODEL ====================
class WeightEntry {
  final double weight;
  final DateTime date;
  final int? bodyFat;
  final double? waist;
  final double? neck;
  final double? arm;
  final double? calves;
  final double? thigh;

  WeightEntry({
    required this.weight,
    required this.date,
    this.bodyFat,
    this.waist,
    this.neck,
    this.arm,
    this.calves,
    this.thigh,
  });
}


