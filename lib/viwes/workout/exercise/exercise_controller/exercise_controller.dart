import 'package:get/get.dart';

class ExerciseItem {
  final String name;
  RxBool isExpanded = false.obs;

  ExerciseItem(this.name);
}

class ExerciseController extends GetxController {
  var exercises = <ExerciseItem>[
    ExerciseItem('Barbell Incline Press'),
    ExerciseItem('Barbell Bench Press'),
    ExerciseItem('Dumbbell Chest Fly'),
  ].obs;

  void toggleExpand(int index) {
    exercises[index].isExpanded.value = !exercises[index].isExpanded.value;
  }

  void addExercise(String name) {
    exercises.add(ExerciseItem(name));
  }

  void removeExercise(int index) {
    exercises.removeAt(index);
  }
}
