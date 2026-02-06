import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_cheloper/viwes/workout/exercise/dialog.dart';

// Model for Exercise
class Exercise {
  final String id;
  final String name;
  final String? icon;

  Exercise({
    required this.id,
    required this.name,
    this.icon,
  });
}

// Controller for Add Training Day
class AddTrainingDayController extends ChangeNotifier {
  String _workoutName = '';
  List<Exercise> _exercises = [];

  String get workoutName => _workoutName;
  List<Exercise> get exercises => List.unmodifiable(_exercises);

  void setWorkoutName(String name) {
    _workoutName = name;
    notifyListeners();
  }

  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(String exerciseId) {
    _exercises.removeWhere((e) => e.id == exerciseId);
    notifyListeners();
  }

  void clearAll() {
    _workoutName = '';
    _exercises.clear();
    notifyListeners();
  }

  bool get isValid => _workoutName.isNotEmpty && _exercises.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'workoutName': _workoutName,
      'exercises': _exercises.map((e) => {
        'id': e.id,
        'name': e.name,
        'icon': e.icon,
      }).toList(),
    };
  }
}

// Main Bottom Sheet Widget
class AddTrainingDayBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>)? onDone;

  const AddTrainingDayBottomSheet({
    Key? key,
    this.onDone,
  }) : super(key: key);

  static Future<void> show(
      BuildContext context, {
        Function(Map<String, dynamic>)? onDone,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTrainingDayBottomSheet(onDone: onDone),
    );
  }

  @override
  State<AddTrainingDayBottomSheet> createState() =>
      _AddTrainingDayBottomSheetState();
}

class _AddTrainingDayBottomSheetState extends State<AddTrainingDayBottomSheet> {
  late AddTrainingDayController _controller;
  late TextEditingController _workoutNameController;

  @override
  void initState() {
    super.initState();
    _controller = AddTrainingDayController();
    _workoutNameController = TextEditingController();

    // Add demo exercise
    _controller.addExercise(Exercise(
      id: '1',
      name: 'Incline Chest',
      icon: '💪',
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _workoutNameController.dispose();
    super.dispose();
  }

  void _handleDone() {
    if (_controller.workoutName.isNotEmpty) {
      Navigator.pop(context);
      widget.onDone?.call(_controller.toJson());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add workout name'),
        ),
      );
    }
  }

  void _showAddExerciseDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: AddNewExerciseDialog(
          isBottomSheet: true,
          onAddExercise: (exerciseName) {
            _controller.addExercise(Exercise(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: exerciseName,
              icon: '💪',
            ));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            children: [
              // Top indicator bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D1D6),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Add New Training Day',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),

                      // Workout Name Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _workoutNameController,
                          onChanged: (value) => _controller.setWorkoutName(value),
                          decoration: InputDecoration(
                            hintText: 'Name of the workout',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF9E9E9E),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Add New Exercise Button
                      GestureDetector(
                        onTap: _showAddExerciseDialog,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9E9E9E),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 20.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Add New Exercise',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Exercise List
                      if (_controller.exercises.isNotEmpty)
                        ..._controller.exercises.map((exercise) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: ExerciseCard(
                              exercise: exercise,
                              onRemove: () => _controller.removeExercise(exercise.id),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),

              // Done Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: GestureDetector(
                  onTap: _handleDone,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Exercise Card Widget
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onRemove;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: Text(
                exercise.icon ?? '💪',
                style: TextStyle(fontSize: 20.sp),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Exercise Name
          Expanded(
            child: Text(
              exercise.name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          // Remove Button
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 20.sp,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}

// Demo Usage Page
class TrainingDayDemo extends StatelessWidget {
  const TrainingDayDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Training Day Demo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AddTrainingDayBottomSheet.show(
              context,
              onDone: (data) {
                print('Training Day Created: $data');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Created: ${data['workoutName']} with ${data['exercises'].length} exercises',
                    ),
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
          ),
          child: Text(
            'Add Training Day',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}