
// ==================== CONTROLLER ====================
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gym_cheloper/viwes/workout/weight_tracking/weight_bottomsheet.dart';
import 'package:gym_cheloper/viwes/workout/weight_tracking/weight_tracking_screen/weight_tracking_screen.dart';
import 'package:gym_cheloper/viwes/workout/weight_tracking/weight_tracking_api_service.dart';
import 'package:intl/intl.dart';

class WeightTrackingController extends GetxController {
  final WeightTrackingApiService _apiService = WeightTrackingApiService();

  // Weight entries list
  var weightEntries = <WeightEntry>[].obs;

  // Loading states
  var isLoading = false.obs;
  var isSubmitting = false.obs;

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

  // Format date for API (M/d/yyyy)
  String _formatDateForAPI(DateTime date) {
    return DateFormat('M/d/yyyy').format(date);
  }

  // Parse date from API (M/d/yyyy)
  DateTime _parseDateFromAPI(String dateString) {
    try {
      return DateFormat('M/d/yyyy').parse(dateString);
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }

  Future<void> _loadWeightData() async {
    try {
      isLoading.value = true;

      print('📅 Loading weight tracking data from API...');

      final response = await _apiService.getProgressBar();

      print('🔍 API Response Success: ${response['success']}');
      print('📋 Response Message: ${response['message']}');
      print('📦 Data length: ${response['data']?.length ?? 0}');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List;
        print('✅ Data received, parsing...');

        weightEntries.value = data.map((item) {
          return WeightEntry.fromJson(item);
        }).toList();

        print('📊 Parsed ${weightEntries.length} weight entries');
      } else {
        print('⚠️ No data or unsuccessful response');
        weightEntries.clear();
      }
    } catch (e) {
      print('❌ Error in _loadWeightData: $e');
      Get.snackbar(
        'Error',
        'Failed to load weight data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
      print('🏁 Loading complete. Total entries: ${weightEntries.length}');
    }
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

  Future<void> submitWeight() async {
    if (weightController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter weight');
      return;
    }

    try {
      isSubmitting.value = true;

      final dateString = _formatDateForAPI(selectedDate.value);

      print('📤 Submitting weight data...');
      print('📅 Date: $dateString');

      final response = await _apiService.addProgressBar(
        weight: weightController.text,
        bodyFat: bodyFatController.text.isEmpty ? '' : bodyFatController.text + (bodyFatController.text.contains('%') ? '' : '%'),
        waist: waistController.text.isEmpty ? '' : waistController.text,
        neck: neckController.text.isEmpty ? '' : neckController.text,
        arm: armController.text.isEmpty ? '' : armController.text,
        calves: calvesController.text.isEmpty ? '' : calvesController.text,
        thigh: thighController.text.isEmpty ? '' : thighController.text,
        date: dateString,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Weight entry added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );

        // Reload weight data to show updated data
        await _loadWeightData();

        Get.back(); // Close bottom sheet
      }
    } catch (e) {
      print('❌ Error in submitWeight: $e');
      Get.snackbar(
        'Error',
        'Failed to add weight entry: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isSubmitting.value = false;
    }
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

  // Factory constructor to create from JSON
  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    // Parse date from API format (M/d/yyyy)
    DateTime parseDate(String dateString) {
      try {
        return DateFormat('M/d/yyyy').parse(dateString);
      } catch (e) {
        print('Error parsing date: $e');
        return DateTime.now();
      }
    }

    // Helper to parse double values
    double? parseDouble(dynamic value) {
      if (value == null || value == '') return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    // Helper to parse int values (for bodyFat, remove % sign if present)
    int? parseInt(dynamic value) {
      if (value == null || value == '') return null;
      if (value is int) return value;
      if (value is String) {
        // Remove % sign if present
        final cleanValue = value.replaceAll('%', '').trim();
        return int.tryParse(cleanValue);
      }
      return null;
    }

    return WeightEntry(
      weight: parseDouble(json['weight']) ?? 0.0,
      date: parseDate(json['date'] ?? ''),
      bodyFat: parseInt(json['bodyFat']),
      waist: parseDouble(json['waist']),
      neck: parseDouble(json['neck']),
      arm: parseDouble(json['arm']),
      calves: parseDouble(json['calves']),
      thigh: parseDouble(json['thigh']),
    );
  }
}


