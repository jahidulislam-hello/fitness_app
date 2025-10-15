import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/utils/app_icons.dart';
import '../../../global widget/global_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuesstionScreen2 extends StatefulWidget {
  const QuesstionScreen2({super.key});

  @override
  State<QuesstionScreen2> createState() => _QuesstionScreen2State();
}

class _QuesstionScreen2State extends State<QuesstionScreen2> {
  // Track the selected option
  String? selectedAnswer;

  // List of possible answers
  final List<String> options = [

    "Yes but I lost motivation",
    "Yes, but they were too complicated",
   "No this is  my first one"
  ];

  @override
  void initState() {
    super.initState();
    selectedAnswer = options[0]; // Set default selection
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
      appBar: AppBar(leading: InkWell(
          onTap: (){
            context.pop();
          },
          child: Icon(Icons.arrow_back_ios)),
      title: SvgPicture.asset(AppIcons.qIcon2),
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
                " Have you tried any other fitness app?",
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
            CustomTextButton(onTap: (){

              context.pushNamed(RouteNames.fitnessQuestionScreen3);
            },text: "Continue",)
          ],
        ),
      ),
    );
  }
}
