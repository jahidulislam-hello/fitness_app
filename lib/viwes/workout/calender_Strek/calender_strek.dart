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
  DateTime _currentMonth = DateTime.now();
  List<CalendarDay> _days = [];
  DateTime? _selectedDate;
  Map<String, DayStatus> _dateStatusMap = {};

  String get monthYear {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[_currentMonth.month - 1]}, ${_currentMonth.year}';
  }

  DateTime get currentMonth => _currentMonth;
  DateTime? get selectedDate => _selectedDate;
  List<CalendarDay> get days => List.unmodifiable(_days);

  CalendarStreakController() {
    _initializeDays();
  }

  void _initializeDays() {
    _days = [];

    // Get first day of month
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    // Get last day of month
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    // Get the weekday of first day (1 = Monday, 7 = Sunday)
    int startWeekday = firstDayOfMonth.weekday;
    // Adjust for Sunday start (convert Monday=1 to Sunday=0)
    int leadingEmptyDays = startWeekday % 7;

    // Add empty days for padding
    for (int i = 0; i < leadingEmptyDays; i++) {
      _days.add(CalendarDay(day: 0, status: DayStatus.none));
    }

    // Add actual days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final dateKey = _formatDate(date);
      final status = _dateStatusMap[dateKey] ?? DayStatus.none;

      _days.add(CalendarDay(day: day, status: status));
    }

    // Fill remaining slots to complete the grid (6 rows x 7 cols = 42)
    while (_days.length < 42) {
      _days.add(CalendarDay(day: 0, status: DayStatus.none));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void goToPreviousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    _initializeDays();
    notifyListeners();
  }

  void goToNextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    _initializeDays();
    notifyListeners();
  }

  void selectDate(int day) {
    if (day > 0) {
      _selectedDate = DateTime(_currentMonth.year, _currentMonth.month, day);
      notifyListeners();
    }
  }

  bool isSelectedDay(int day) {
    if (_selectedDate == null || day == 0) return false;
    return _selectedDate!.year == _currentMonth.year &&
           _selectedDate!.month == _currentMonth.month &&
           _selectedDate!.day == day;
  }

  bool isToday(int day) {
    if (day == 0) return false;
    final today = DateTime.now();
    return today.year == _currentMonth.year &&
           today.month == _currentMonth.month &&
           today.day == day;
  }

  void setMonthYear(String monthYear) {
    // Parse and set month/year if needed
    notifyListeners();
  }

  void setDateStatus(DateTime date, DayStatus status) {
    final dateKey = _formatDate(date);
    _dateStatusMap[dateKey] = status;
    _initializeDays();
    notifyListeners();
  }

  void setDateStatusMap(Map<String, DayStatus> statusMap) {
    _dateStatusMap = statusMap;
    _initializeDays();
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
  final bool isSelected;
  final bool isToday;

  const CalendarDayCircle({
    Key? key,
    required this.day,
    this.size = 36,
    this.isSelected = false,
    this.isToday = false,
  }) : super(key: key);

  Color _getStatusColor() {
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

  Color _getBackgroundColor() {
    // Empty day (padding)
    if (day.day == 0) return Colors.transparent;

    // Selected day - filled with status color or primary color
    if (isSelected) {
      return day.status != DayStatus.none
          ? _getStatusColor()
          : const Color(0xffF93533);
    }

    // Has data - show white background with colored border
    if (day.status != DayStatus.none) {
      return Colors.white;
    }

    // No data, not selected - light grey background
    return const Color(0xFFF5F5F5);
  }

  Color _getBorderColor() {
    // Empty day
    if (day.day == 0) return Colors.transparent;

    // Has status data - show status color border
    if (day.status != DayStatus.none) {
      return _getStatusColor();
    }

    // Today without data
    if (isToday) {
      return const Color(0xffF93533);
    }

    // Default grey border
    return const Color(0xFFE0E0E0);
  }

  Color _getTextColor() {
    // Empty day
    if (day.day == 0) return Colors.transparent;

    // Selected - white text
    if (isSelected) return Colors.white;

    // Has status - dark text
    if (day.status != DayStatus.none) {
      return const Color(0xFF1a1a1a);
    }

    // Default
    return const Color(0xFF9E9E9E);
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
            color: _getStatusColor(),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.star,
          size: 8,
          color: _getStatusColor(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Empty day (padding)
    if (day.day == 0) {
      return SizedBox(width: size, height: size);
    }

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
              border: Border.all(
                color: _getBorderColor(),
                width: day.status != DayStatus.none || isToday ? 2.5 : 1.5,
              ),
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
          // Today indicator dot
          if (isToday && !isSelected)
            Positioned(
              bottom: 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xffF93533),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Main calendar widget
class CalendarStreakView extends StatelessWidget {
  final CalendarStreakController controller;
  final VoidCallback? onClose;
  final Function(DateTime)? onDateSelected;
  final Set<String>? datesWithMealData; // Dates that have meal plans

  const CalendarStreakView({
    Key? key,
    required this.controller,
    this.onClose,
    this.onDateSelected,
    this.datesWithMealData,
  }) : super(key: key);

  // Check if a date has meal data
  bool _dateHasMealData(int day) {
    if (day == 0 || datesWithMealData == null) return false;
    final date = DateTime(controller.currentMonth.year, controller.currentMonth.month, day);
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return datesWithMealData!.contains(dateStr);
  }

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
              // Header with navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous month button
                  GestureDetector(
                    onTap: () => controller.goToPreviousMonth(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        size: 20,
                        color: Color(0xFF1a1a1a),
                      ),
                    ),
                  ),
                  // Month/Year text
                  Text(
                    controller.monthYear,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                  // Next month button
                  GestureDetector(
                    onTap: () => controller.goToNextMonth(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Color(0xFF1a1a1a),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Close button row
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
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
              ),
              const SizedBox(height: 8),

              // Weekday headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _WeekdayHeader('Sun'),
                  _WeekdayHeader('Mon'),
                  _WeekdayHeader('Tue'),
                  _WeekdayHeader('Wed'),
                  _WeekdayHeader('Thu'),
                  _WeekdayHeader('Fri'),
                  _WeekdayHeader('Sat'),
                ],
              ),
              const SizedBox(height: 8),

              // Calendar grid (7 columns x 6 rows)
              _buildCalendarGrid(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendarGrid() {
    // Colors for days with meal data
    final List<Color> dayColors = [
      const Color(0xFFE57373), // Red
      const Color(0xFFFFB74D), // Orange
      const Color(0xFFFFD54F), // Yellow
      const Color(0xFF4CAF50), // Green
      const Color(0xFF64B5F6), // Blue
      const Color(0xFF9575CD), // Purple
      const Color(0xFFFF8A80), // Pink
    ];

    final rowCount = (controller.days.length / 7).ceil();
    return Column(
      children: [
        for (int row = 0; row < rowCount; row++)
          Padding(
            padding: EdgeInsets.only(bottom: row < rowCount - 1 ? 6 : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int col = 0; col < 7; col++)
                  if (row * 7 + col < controller.days.length)
                    Builder(
                      builder: (context) {
                        final dayData = controller.days[row * 7 + col];
                        final hasMealData = _dateHasMealData(dayData.day);
                        final isSelected = controller.isSelectedDay(dayData.day);
                        final colorIndex = dayData.day % 7;

                        return GestureDetector(
                          onTap: () {
                            if (dayData.day > 0 && onDateSelected != null) {
                              controller.selectDate(dayData.day);
                              final selectedDate = DateTime(
                                controller.currentMonth.year,
                                controller.currentMonth.month,
                                dayData.day,
                              );
                              onDateSelected!(selectedDate);
                            }
                          },
                          child: _buildCalendarDayCircle(
                            day: dayData.day,
                            hasMealData: hasMealData,
                            isSelected: isSelected,
                            color: dayColors[colorIndex],
                          ),
                        );
                      },
                    ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCalendarDayCircle({
    required int day,
    required bool hasMealData,
    required bool isSelected,
    required Color color,
  }) {
    // Empty day (padding)
    if (day == 0) {
      return const SizedBox(width: 36, height: 36);
    }

    // Determine colors based on state
    Color borderColor = const Color(0xFFE0E0E0); // Default grey
    Color fillColor = Colors.white;
    Color textColor = const Color(0xFF9E9E9E);

    // Has meal data - show colored border
    if (hasMealData) {
      borderColor = color;
      textColor = const Color(0xFF1a1a1a);
    }

    // Selected - fill with color
    if (isSelected) {
      fillColor = color;
      borderColor = color;
      textColor = Colors.white;
    }

    return SizedBox(
      width: 36,
      height: 36,
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: hasMealData || isSelected ? 3 : 1.5,
          ),
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String text;
  const _WeekdayHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9E9E9E),
          ),
        ),
      ),
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