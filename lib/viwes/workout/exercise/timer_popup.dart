import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestTimerPopup extends StatefulWidget {
  const RestTimerPopup({super.key});

  @override
  _RestTimerPopupState createState() => _RestTimerPopupState();
}

class _RestTimerPopupState extends State<RestTimerPopup> {
  int seconds = 60;
  bool isRunning = false;

  void increaseTime() {
    setState(() {
      seconds += 10;
    });
  }

  void decreaseTime() {
    setState(() {
      if (seconds > 10) seconds -= 10;
    });
  }

  void startTimer() {
    // implement your timer logic here
    setState(() {
      isRunning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Container(
        width: 380.w,
        height: 217.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close, size: 20.sp),
              ),
            ),

            // Title
            Text(
              "Rest Timer",
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Timer display with -10s, circle, +10s in one line
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: decreaseTime,
                  child: Text("-10s", style: TextStyle(fontSize: 14.sp)),
                ),
                SizedBox(width: 20.w),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 2.w),
                      ),
                    ),
                    Text(
                      "${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: increaseTime,
                  child: Text("+10s", style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),

            // Start button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  "Start",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}