import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../global widget/global_widget.dart';
import '../../../routes/routes_name.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/utils.dart';

class QuestionScreen3 extends StatefulWidget {
  const QuestionScreen3({super.key});

  @override
  State<QuestionScreen3> createState() => _QuestionScreen3State();
}

class _QuestionScreen3State extends State<QuestionScreen3> {
  // Track the selected option
  String? selectedAnswer;

  // List of possible answers
  final List<String> options = [
    "Improve my health",
    "Look better",
    "Build confidence",
    "Perform better in sports",
    "Other"
  ];
  // Initialize the default selected answer
  @override
  void initState() {
    super.initState();
    selectedAnswer = options[1]; // Set default selection
  }

  // Continue button click handler
  void _onContinue() {
    if (selectedAnswer != null) {
      // Navigate to the next page or handle the answer as needed
      print("Selected Answer: $selectedAnswer");
      // You can navigate to the next screen here, e.g., Navigator.push(...);
    } else {
      // Show a message if no answer is selected
      print("Please select an answer.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: SvgPicture.asset(AppIcons.qIcon3),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizeW * 0.12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Question
            Center(
              child: Text(
                "Why do you want to start now?",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // List of selectable answers
            ...options.map((option) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAnswer = option;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 15.h),
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedAnswer == option
                          ? Colors.red
                          : Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Continue Button
            SizedBox(height: 40.h),
            CustomTextButton(
              onTap: () {
                context.pushNamed(RouteNames.fitnessQuestionScreen4);
              },
              text: "Continue",
            ),
          ],
        ),
      ),
    );
  }
}
