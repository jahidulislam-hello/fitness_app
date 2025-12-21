import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/viwes/screens/workout/workout_api_service.dart';

class WorkoutController extends GetxController {
  final WorkoutApiService _apiService = WorkoutApiService();

  // Loading state
  var isLoading = false.obs;

  // Workout data
  var workouts = <WorkoutModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWorkoutLog();
  }

  /// Load Workout Log from API
  Future<void> loadWorkoutLog() async {
    try {
      isLoading.value = true;

      final response = await _apiService.getWorkoutLog();

      print('🔍 API Response Success: ${response['success']}');
      print('📋 Response Message: ${response['message']}');
      print('📦 Data length: ${response['data']?.length ?? 0}');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List;
        print('✅ Data received, parsing...');
        _parseWorkoutData(data);
      } else {
        print('⚠️ No data or unsuccessful response');
        workouts.clear();
      }
    } catch (e) {
      print('❌ Error in loadWorkoutLog: $e');
      Get.snackbar(
        'Error',
        'Failed to load workouts: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
      print('🏁 Loading complete. Total workouts: ${workouts.length}');
    }
  }

  /// Parse Workout Data
  void _parseWorkoutData(List<dynamic> data) {
    workouts.clear();

    for (var item in data) {
      workouts.add(WorkoutModel(
        id: item['_id'] ?? '',
        trainingName: item['trainingName'] ?? 'Unknown',
        completed: item['completed'] ?? false,
        userId: item['userId'] ?? '',
        exercises: item['exercises'] ?? [],
      ));
    }

    print('📊 Parsed ${workouts.length} workouts');
    workouts.refresh();
  }

  /// Delete Workout
  void deleteWorkout(int index) {
    // TODO: Implement delete API call if available
    workouts.removeAt(index);
    workouts.refresh();

    Get.snackbar(
      'Deleted',
      'Workout removed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Pin Workout
  void pinWorkout(int index) {
    final workout = workouts[index];
    workouts.removeAt(index);
    workouts.insert(0, workout);
    workouts.refresh();
  }
}

// ==================== MODEL ====================
class WorkoutModel {
  String id;
  String trainingName;
  bool completed;
  String userId;
  List<dynamic> exercises;

  WorkoutModel({
    required this.id,
    required this.trainingName,
    required this.completed,
    required this.userId,
    required this.exercises,
  });
}
