import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_stepper/stepper.dart';

class TestStepperBuildItem extends StatelessWidget {
  const TestStepperBuildItem({
    Key? key,
    required this.questionNumber,
    required this.currentIndex,
  }) : super(key: key);

  final int questionNumber;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Color(0xff8BCAFD),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: NumberStepper(
            numbers: List.generate(questionNumber, (index) => index + 1),
            scrollingDisabled: false,
            enableNextPreviousButtons: false,
            stepRadius: MediaQuery.of(context).size.width / 25,
            lineLength: 5,
            lineColor: Colors.transparent,
            activeStepBorderWidth: 0,
            activeStepBorderPadding: 0,
            stepColor: Colors.transparent,
            activeStepColor: primaryColor,
            enableStepTapping: false,
            activeStep: currentIndex,
          ),
        ),
      ),
    );
  }
}
