import 'package:flutter/material.dart';

// Enum for day status
enum DayStatus {
  none,        // Gray - no data
  missed,      // Red - missed day
  partial,     // Yellow - partial completion
  completed,   // Green - completed
}

// Model for a single day
class CalendarDay {
  final int day;
  final DayStatus status;
  final bool hasIcon; // Trophy/star icon

  CalendarDay({
    required this.day,
    required this.status,
    this.hasIcon = false,
  });

  CalendarDay copyWith({
    int? day,
    DayStatus? status,
    bool? hasIcon,
  }) {
    return CalendarDay(
      day: day ?? this.day,
      status: status ?? this.status,
      hasIcon: hasIcon ?? this.hasIcon,
    );
  }
}

// Controller to manage calendar state
class CalendarStreakController extends ChangeNotifier {
  String _monthYear = 'June, 2025';
  List<CalendarDay> _days = [];

  String get monthYear => _monthYear;
  List<CalendarDay> get days => List.unmodifiable(_days);

  CalendarStreakController() {
    _initializeDays();
  }

  void _initializeDays() {
    // Initialize with 35 days (5 weeks)
    _days = List.generate(35, (index) {
      return CalendarDay(
        day: index + 1,
        status: DayStatus.none,
      );
    });
  }

  void setMonthYear(String monthYear) {
    _monthYear = monthYear;
    notifyListeners();
  }

  void setDayStatus(int day, DayStatus status, {bool hasIcon = false}) {
    final index = _days.indexWhere((d) => d.day == day);
    if (index != -1) {
      _days[index] = _days[index].copyWith(
        status: status,
        hasIcon: hasIcon,
      );
      notifyListeners();
    }
  }

  void setMultipleDays(Map<int, DayStatus> dayStatusMap, {Set<int>? iconDays}) {
    for (var entry in dayStatusMap.entries) {
      final index = _days.indexWhere((d) => d.day == entry.key);
      if (index != -1) {
        _days[index] = _days[index].copyWith(
          status: entry.value,
          hasIcon: iconDays?.contains(entry.key) ?? false,
        );
      }
    }
    notifyListeners();
  }

  void loadDemoData() {
    // Simulate the data from the image
    final demoData = {
      1: DayStatus.missed,
      2: DayStatus.partial,
      3: DayStatus.completed,
      5: DayStatus.none,
      6: DayStatus.none,
      7: DayStatus.none,

      8: DayStatus.missed,
      9: DayStatus.partial,
      10: DayStatus.completed,
      11: DayStatus.partial,
      15: DayStatus.partial,

      16: DayStatus.missed,
      17: DayStatus.partial,
      19: DayStatus.completed,
      20: DayStatus.none,
      21: DayStatus.partial,
      22: DayStatus.partial,

      23: DayStatus.partial,
      25: DayStatus.partial,
      26: DayStatus.none,
      28: DayStatus.completed,
      29: DayStatus.none,

      30: DayStatus.partial,
      31: DayStatus.missed,
      33: DayStatus.partial,
      34: DayStatus.completed,
    };

    final iconDays = {4, 14, 19, 28};

    setMultipleDays(demoData, iconDays: iconDays);
  }

  void reset() {
    _initializeDays();
    notifyListeners();
  }

  int getCurrentStreak() {
    int streak = 0;
    for (int i = _days.length - 1; i >= 0; i--) {
      if (_days[i].status == DayStatus.completed ||
          _days[i].status == DayStatus.partial) {
        streak++;
      } else if (_days[i].status == DayStatus.missed) {
        break;
      }
    }
    return streak;
  }

  int getTotalCompletedDays() {
    return _days.where((d) => d.status == DayStatus.completed).length;
  }
}

// Single day circle widget
class CalendarDayCircle extends StatelessWidget {
  final CalendarDay day;
  final double size;

  const CalendarDayCircle({
    Key? key,
    required this.day,
    this.size = 36,
  }) : super(key: key);

  Color _getBackgroundColor() {
    switch (day.status) {
      case DayStatus.completed:
        return const Color(0xFF4CAF50); // Green
      case DayStatus.partial:
        return const Color(0xFFFFC107); // Yellow
      case DayStatus.missed:
        return const Color(0xFFEF5350); // Red
      case DayStatus.none:
        return const Color(0xFFE0E0E0); // Gray
    }
  }

  Color _getTextColor() {
    if (day.status == DayStatus.none) {
      return const Color(0xFF9E9E9E);
    }
    return Colors.white;
  }

  Widget _buildIcon() {
    if (!day.hasIcon) return const SizedBox.shrink();

    return Positioned(
      top: 2,
      right: 2,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: _getBackgroundColor(),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.star,
          size: 8,
          color: _getBackgroundColor(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _getTextColor(),
                ),
              ),
            ),
          ),
          _buildIcon(),
        ],
      ),
    );
  }
}

// Main calendar widget
class CalendarStreakView extends StatelessWidget {
  final CalendarStreakController controller;
  final VoidCallback? onClose;

  const CalendarStreakView({
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
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.monthYear,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFFEF5350),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Calendar grid (7 columns x 5 rows)
              _buildCalendarGrid(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        for (int row = 0; row < 5; row++)
          Padding(
            padding: EdgeInsets.only(bottom: row < 4 ? 8 : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int col = 0; col < 7; col++)
                  CalendarDayCircle(
                    day: controller.days[row * 7 + col],
                    size: 36,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

// Dialog wrapper
class CalendarStreakDialog extends StatelessWidget {
  final CalendarStreakController controller;

  const CalendarStreakDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  static void show(BuildContext context, CalendarStreakController controller) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: CalendarStreakView(
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
      child: CalendarStreakView(
        controller: controller,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

// Demo page
class CalendarStreakDemo extends StatefulWidget {
  const CalendarStreakDemo({Key? key}) : super(key: key);

  @override
  State<CalendarStreakDemo> createState() => _CalendarStreakDemoState();
}

class _CalendarStreakDemoState extends State<CalendarStreakDemo> {
  late CalendarStreakController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarStreakController();
    _controller.loadDemoData(); // Load demo data from image
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
        title: const Text('Calendar Streak Tracker'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Current Streak: ${_controller.getCurrentStreak()} days',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Completed Days: ${_controller.getTotalCompletedDays()}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                CalendarStreakDialog.show(context, _controller);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Show Calendar'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.setDayStatus(1, DayStatus.completed);
                  },
                  child: const Text('Mark Day 1 Complete'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.setDayStatus(2, DayStatus.partial);
                  },
                  child: const Text('Mark Day 2 Partial'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.setDayStatus(3, DayStatus.missed);
                  },
                  child: const Text('Mark Day 3 Missed'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.loadDemoData();
                  },
                  child: const Text('Load Demo Data'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}