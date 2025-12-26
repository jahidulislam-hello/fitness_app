import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:gym_cheloper/viwes/screens/workout/workout_api_service.dart';

// Workout Set Model
class WorkoutSet {
  final RxInt reps;
  final RxInt weight;
  final RxString date;
  final RxBool isCompleted;

  WorkoutSet({
    required int reps,
    required int weight,
    required String date,
    required bool isCompleted,
  })  : reps = reps.obs,
        weight = weight.obs,
        date = date.obs,
        isCompleted = isCompleted.obs;

  // Helper method to create a copy with updated values
  WorkoutSet copyWith({
    int? reps,
    int? weight,
    String? date,
    bool? isCompleted,
  }) {
    return WorkoutSet(
      reps: reps ?? this.reps.value,
      weight: weight ?? this.weight.value,
      date: date ?? this.date.value,
      isCompleted: isCompleted ?? this.isCompleted.value,
    );
  }
}

// Exercise Item Model
class ExerciseItem {
  final String name;
  final String exerciseId;
  final RxBool isExpanded;
  final RxString imageUrl;
  final RxBool isImageLoading;
  final RxList<WorkoutSet> sets;

  ExerciseItem({
    required this.name,
    required this.exerciseId,
    bool isExpanded = false,
    String imageUrl = '',
    bool isImageLoading = true,
    List<WorkoutSet>? sets,
  })  : isExpanded = isExpanded.obs,
        imageUrl = imageUrl.obs,
        isImageLoading = isImageLoading.obs,
        sets = (sets ?? <WorkoutSet>[]).obs;
}

class ExerciseController extends GetxController {
  final WorkoutApiService _apiService = WorkoutApiService();

  var exercises = <ExerciseItem>[].obs;
  var currentExerciseImage = ''.obs;
  var isMainImageLoading = true.obs;
  var isLoading = false.obs;
  var trainingName = 'Chest Day'.obs;
  var workoutId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('🎬 ExerciseController onInit - Loading workout data from API...');
    loadWorkoutData();
  }

  /// Load workout data from API
  Future<void> loadWorkoutData() async {
    try {
      isLoading.value = true;
      print('🌐 Fetching workout log from API...');

      final response = await _apiService.getWorkoutLog();

      print('🔍 API Response Success: ${response['success']}');
      print('📋 Response Message: ${response['message']}');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List;
        print('✅ Data received, parsing workouts...');

        if (data.isNotEmpty) {
          // Get the first workout (or you can let user select which workout)
          final firstWorkout = data[0];
          _parseWorkoutData(firstWorkout);
        } else {
          print('⚠️ No workout data available');
          exercises.clear();
        }
      } else {
        print('⚠️ No data or unsuccessful response');
        exercises.clear();
      }
    } catch (e) {
      print('❌ Error in loadWorkoutData: $e');
      Get.snackbar(
        'Error',
        'Failed to load workout data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      print('🏁 Loading complete. Total exercises: ${exercises.length}');
    }
  }

  /// Parse workout data from API response
  void _parseWorkoutData(Map<String, dynamic> workout) {
    try {
      exercises.clear();

      // Set training name and workout ID
      trainingName.value = workout['trainingName'] ?? 'Workout';
      workoutId.value = workout['_id'] ?? '';

      print('📊 Parsing workout: ${trainingName.value}');

      final exercisesList = workout['exercises'] as List? ?? [];

      for (var exerciseData in exercisesList) {
        // Skip if exercise data is incomplete
        if (exerciseData == null || exerciseData['exerciseName'] == null) {
          continue;
        }

        final exerciseName = exerciseData['exerciseName'] ?? 'Unknown Exercise';
        final exerciseId = exerciseData['exerciseId'] ?? '0001';

        print('🏋️ Parsing exercise: $exerciseName (ID: $exerciseId)');

        // Parse workout logs (sets)
        final workoutLogs = exerciseData['workoutLogs'] as List? ?? [];
        List<WorkoutSet> sets = [];

        for (var log in workoutLogs) {
          if (log == null) continue;

          final setDataList = log['setData'] as List? ?? [];

          for (var setData in setDataList) {
            if (setData == null) continue;

            // Parse reps
            final repsStr = setData['rep'] ?? '0';
            final reps = int.tryParse(repsStr.toString()) ?? 0;

            // Parse weight (remove 'kg' suffix if present)
            final weightStr = setData['weight'] ?? '0';
            final weightCleaned = weightStr.toString().replaceAll('kg', '').trim();
            final weight = int.tryParse(weightCleaned) ?? 0;

            // Parse date
            final dateStr = setData['date'] ?? '';
            String formattedDate = '07,Dec 25'; // Default
            if (dateStr.isNotEmpty) {
              try {
                final parsedDate = DateTime.parse(dateStr);
                formattedDate = DateFormat('dd,MMM yy').format(parsedDate);
              } catch (e) {
                print('⚠️ Error parsing date: $e');
              }
            }

            sets.add(WorkoutSet(
              reps: reps,
              weight: weight,
              date: formattedDate,
              isCompleted: false, // Default to not completed
            ));

            print('  ✅ Added set: $reps reps, $weight kg, $formattedDate');
          }
        }

        // Create exercise item
        final exerciseItem = ExerciseItem(
          name: exerciseName,
          exerciseId: exerciseId,
          sets: sets,
        );

        exercises.add(exerciseItem);

        // Load exercise image
        loadExerciseImage(exerciseItem);
      }

      // Load main image for first exercise if available
      if (exercises.isNotEmpty) {
        loadMainExerciseImage(exercises.first.exerciseId);
      }

      exercises.refresh();
      print('✅ Successfully parsed ${exercises.length} exercises');
    } catch (e) {
      print('❌ Error parsing workout data: $e');
    }
  }

  Future<void> loadMainExerciseImage(String exerciseId) async {
    try {
      isMainImageLoading.value = true;
      final url = 'https://exercisedb.p.rapidapi.com/image?resolution=1080&exerciseId=$exerciseId';
      print('🖼️ Loading main exercise image from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-rapidapi-key': 'fb9a00baa2msh43336df37f58631p1ceeaejsnd8eacd0ede8e',
          'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
          'x-app-id': '8ad96951',
          'x-app-key': 'f04813f79bf461d565d4a33ca5a86e9a',
        },
      );

      print('📡 Main image response status: ${response.statusCode}');
      print('📦 Main image response headers: ${response.headers}');
      print('📦 Main image content-type: ${response.headers['content-type']}');

      if (response.statusCode == 200) {
        currentExerciseImage.value = url;
        print('✅ Main exercise image loaded successfully');
      } else {
        print('❌ Failed to load main image. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading main exercise image: $e');
    } finally {
      isMainImageLoading.value = false;
      print('🏁 Main image loading complete. URL: ${currentExerciseImage.value}');
    }
  }

  Future<void> loadExerciseImage(ExerciseItem exercise) async {
    try {
      exercise.isImageLoading.value = true;
      final url = 'https://exercisedb.p.rapidapi.com/image?resolution=1080&exerciseId=${exercise.exerciseId}';
      print('🖼️ Loading exercise image for ${exercise.name} (ID: ${exercise.exerciseId}) from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-rapidapi-key': 'fb9a00baa2msh43336df37f58631p1ceeaejsnd8eacd0ede8e',
          'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
          'x-app-id': '8ad96951',
          'x-app-key': 'f04813f79bf461d565d4a33ca5a86e9a',
        },
      );

      print('📡 Exercise image response status for ${exercise.name}: ${response.statusCode}');

      if (response.statusCode == 200) {
        exercise.imageUrl.value = url;
        print('✅ Exercise image loaded successfully for ${exercise.name}');
      } else {
        print('❌ Failed to load image for ${exercise.name}. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading exercise image for ${exercise.name}: $e');
    } finally {
      exercise.isImageLoading.value = false;
    }
  }

  void toggleExpand(int index) {
    exercises[index].isExpanded.value = !exercises[index].isExpanded.value;
  }

  /// Search for exercise by name and get exerciseId
  Future<String?> searchExerciseByName(String exerciseName) async {
    try {
      final url = 'https://exercisedb.p.rapidapi.com/exercises/name/${Uri.encodeComponent(exerciseName.toLowerCase())}';
      print('🔍 Searching for exercise: $exerciseName');
      print('🌐 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-rapidapi-key': 'fb9a00baa2msh43336df37f58631p1ceeaejsnd8eacd0ede8e',
          'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
        },
      );

      print('📡 Search response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> exercises = jsonDecode(response.body);
        print('✅ Found ${exercises.length} exercises');

        if (exercises.isNotEmpty) {
          final exerciseId = exercises[0]['id']?.toString() ?? '0001';
          print('✅ Using exerciseId: $exerciseId for $exerciseName');
          return exerciseId;
        } else {
          print('⚠️ No exercises found for: $exerciseName');
          return '0001'; // Default ID
        }
      } else {
        print('❌ Search failed. Status: ${response.statusCode}');
        return '0001'; // Default ID
      }
    } catch (e) {
      print('❌ Error searching exercise: $e');
      return '0001'; // Default ID
    }
  }

  /// Add exercise with API exercise ID lookup
  Future<void> addExercise(String name) async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: Color(0xffF93533),
          ),
        ),
        barrierDismissible: false,
      );

      // Search for exercise ID
      final exerciseId = await searchExerciseByName(name);

      // Close loading dialog
      Get.back();

      // Add exercise to list
      final newExercise = ExerciseItem(
        name: name,
        exerciseId: exerciseId ?? '0001',
        sets: [],
      );

      exercises.add(newExercise);

      // Load exercise image
      loadExerciseImage(newExercise);

      print('✅ Added exercise: $name with ID: $exerciseId');
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      print('❌ Error adding exercise: $e');
    }
  }

  void removeExercise(int index) {
    if (index >= 0 && index < exercises.length) {
      exercises.removeAt(index);
    }
  }

  // Swap exercise - replaces an existing exercise with a new one
  Future<void> swapExercise(int index, String newExerciseName) async {
    if (index >= 0 && index < exercises.length) {
      try {
        // Show loading indicator
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xffF93533),
            ),
          ),
          barrierDismissible: false,
        );

        final oldSets = exercises[index].sets;

        // Search for new exercise ID
        final exerciseId = await searchExerciseByName(newExerciseName);

        // Close loading dialog
        Get.back();

        // Create new exercise with searched ID
        final newExercise = ExerciseItem(
          name: newExerciseName,
          exerciseId: exerciseId ?? '0001',
          sets: oldSets, // Keep the existing sets
        );

        exercises[index] = newExercise;

        // Load new exercise image
        loadExerciseImage(newExercise);

        print('✅ Swapped exercise at index $index to: $newExerciseName (ID: $exerciseId)');
      } catch (e) {
        // Close loading dialog if still open
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        print('❌ Error swapping exercise: $e');
      }
    }
  }

  // Add a workout set to a specific exercise
  void addWorkoutSet({
    required int exerciseIndex,
    required int reps,
    required int weight,
    String? date,
  }) {
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      final currentDate = date ?? DateFormat('dd,MMM yy').format(DateTime.now());

      final newSet = WorkoutSet(
        reps: reps,
        weight: weight,
        date: currentDate,
        isCompleted: false,
      );

      exercises[exerciseIndex].sets.add(newSet);
      print('✅ Added workout set to ${exercises[exerciseIndex].name}: $reps reps, $weight kg');
    }
  }

  // Remove a specific set from an exercise
  void removeWorkoutSet(int exerciseIndex, int setIndex) {
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      if (setIndex >= 0 && setIndex < exercises[exerciseIndex].sets.length) {
        exercises[exerciseIndex].sets.removeAt(setIndex);
        print('✅ Removed workout set from ${exercises[exerciseIndex].name}');
      }
    }
  }

  // Toggle set completion
  void toggleSetCompletion(int exerciseIndex, int setIndex) {
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      if (setIndex >= 0 && setIndex < exercises[exerciseIndex].sets.length) {
        final set = exercises[exerciseIndex].sets[setIndex];
        set.isCompleted.value = !set.isCompleted.value;
      }
    }
  }

  // Update a specific set
  void updateWorkoutSet({
    required int exerciseIndex,
    required int setIndex,
    int? reps,
    int? weight,
  }) {
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      if (setIndex >= 0 && setIndex < exercises[exerciseIndex].sets.length) {
        final set = exercises[exerciseIndex].sets[setIndex];
        if (reps != null) set.reps.value = reps;
        if (weight != null) set.weight.value = weight;
      }
    }
  }

  // Get total sets for an exercise
  int getTotalSets(int exerciseIndex) {
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      return exercises[exerciseIndex].sets.length;
    }
    return 0;
  }

  // Get completed sets count for an exercise
  int getCompletedSetsCount(int exerciseIndex) {
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      return exercises[exerciseIndex].sets.where((set) => set.isCompleted.value).length;
    }
    return 0;
  }

  // Check if all sets are completed for an exercise
  bool areAllSetsCompleted(int exerciseIndex) {
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      final sets = exercises[exerciseIndex].sets;
      if (sets.isEmpty) return false;
      return sets.every((set) => set.isCompleted.value);
    }
    return false;
  }
}