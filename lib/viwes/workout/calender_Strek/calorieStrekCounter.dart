import 'package:flutter/material.dart';

// Controller to manage streak state
class CalorieStreakController extends ChangeNotifier {
  int _currentStreak = 200;
  int _bestStreak = 200;

  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;

  void updateStreak(int newStreak) {
    _currentStreak = newStreak;
    if (newStreak > _bestStreak) {
      _bestStreak = newStreak;
    }
    notifyListeners();
  }

  void incrementStreak() {
    updateStreak(_currentStreak + 1);
  }

  void resetStreak() {
    _currentStreak = 0;
    notifyListeners();
  }

  void setStreaks({required int current, required int best}) {
    _currentStreak = current;
    _bestStreak = best;
    notifyListeners();
  }
}

// Main Streak Counter Widget
class CalorieStreakCounter extends StatelessWidget {
  final CalorieStreakController controller;
  final VoidCallback? onClose;

  const CalorieStreakCounter({
    Key? key,
    required this.controller,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'This is your Calorie Streak Count!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFFe74c3c),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Current Streak
              Row(
                children: [
                  const Text(
                    '🔥',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current streak: ${controller.currentStreak}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1a1a1a),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Best Streak
              Row(
                children: [
                  const Text(
                    '🔥',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Best streak: ${controller.bestStreak}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1a1a1a),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Example usage with dialog
class CalorieStreakDialog extends StatelessWidget {
  final CalorieStreakController controller;

  const CalorieStreakDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  static void show(BuildContext context, CalorieStreakController controller) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: CalorieStreakCounter(
          controller: controller,
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: CalorieStreakCounter(
        controller: controller,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

// Example demo page
class CalorieStreakDemo extends StatefulWidget {
  const CalorieStreakDemo({Key? key}) : super(key: key);

  @override
  State<CalorieStreakDemo> createState() => _CalorieStreakDemoState();
}

class _CalorieStreakDemoState extends State<CalorieStreakDemo> {
  late CalorieStreakController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalorieStreakController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      appBar: AppBar(
        title: const Text('Calorie Streak Counter Demo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                CalorieStreakDialog.show(context, _controller);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Show Streak Counter'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _controller.incrementStreak();
              },
              child: const Text('Increment Streak'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                _controller.resetStreak();
              },
              child: const Text('Reset Current Streak'),
            ),
          ],
        ),
      ),
    );
  }
}