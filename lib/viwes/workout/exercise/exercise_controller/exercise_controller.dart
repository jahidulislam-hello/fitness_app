import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ExerciseItem {
  final String name;
  final String exerciseId;
  RxBool isExpanded = false.obs;
  RxString imageUrl = ''.obs;
  RxBool isImageLoading = true.obs;

  ExerciseItem(this.name, this.exerciseId);
}

class ExerciseController extends GetxController {
  var exercises = <ExerciseItem>[
    ExerciseItem('Barbell Incline Press', '0001'),
    ExerciseItem('Barbell Bench Press', '0002'),
    ExerciseItem('Dumbbell Chest Fly', '0003'),
  ].obs;

  var currentExerciseImage = ''.obs;
  var isMainImageLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    print('🎬 ExerciseController onInit - Starting image loading...');
    loadMainExerciseImage('0003'); // Load the first exercise image
    for (var exercise in exercises) {
      loadExerciseImage(exercise);
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

  void addExercise(String name) {
    exercises.add(ExerciseItem(name, '0001'));
  }

  void removeExercise(int index) {
    exercises.removeAt(index);
  }
}
