import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../student_test_answers_screen.dart';
import 'student_test_result_build_item.dart';

class StudentResultsCardBuildItem extends StatelessWidget {
  const StudentResultsCardBuildItem({
    Key? key,
    required this.deviceInfo,
    required this.test,
    required this.cubit,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final Test test;
  final TestCubit cubit;

  @override
  Widget build(BuildContext context) {
    final int testResultPercentage =
        ((cubit.correctAnswersCount / cubit.testCorrectionStudent.length) * 100)
            .toInt();
    return Card(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 32.0.h, bottom: 20.h),
            child: Text(
              test.name!,
              style: secondaryTextStyle(null)
                  .copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          defaultDivider(),
          Expanded(
            child: AnimationLimiter(
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    StudentTestResultBuildItem(
                      deviceInfo: deviceInfo,
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      color: successColor,
                      title: 'الاجابات الصحيحه',
                      result: '${cubit.correctAnswersCount}',
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    StudentTestResultBuildItem(
                      deviceInfo: deviceInfo,
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                      color: errorColor,
                      title: 'الاجابات الخاطئه',
                      result: '${cubit.wrongAnswersCount}',
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    StudentTestResultBuildItem(
                        deviceInfo: deviceInfo,
                        icon: Icon(
                          Icons.access_time_outlined,
                          color: Colors.white,
                        ),
                        color: thirdColor,
                        title: 'المده المستغرق',
                        result: _mapTime(cubit.elapsedTime)
                        // '${cubit.elapsedTime} دقائق',
                        ),
                    SizedBox(
                      height: 10.h,
                    ),
                    StudentTestResultBuildItem(
                      deviceInfo: deviceInfo,
                      icon: Icon(
                        CupertinoIcons.percent,
                        color: Colors.white,
                      ),
                      color: thirdColor,
                      title: 'النسبه المئويه',
                      result: '$testResultPercentage%',
                      textColor: resultPercentageColor(testResultPercentage),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    StudentTestResultBuildItem(
                      deviceInfo: deviceInfo,
                      icon: SvgPicture.asset('assets/images/icons/points.svg'),
                      color: thirdColor,
                      title: 'عدد النقاط',
                      result: '١٥',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: DefaultAppButton(
              text: 'عرض الاجابات الصحيحه',
              isLoading: false,
              textStyle: thirdTextStyle(deviceInfo),
              isDisabled: false,
              onPressed: () {
                navigateTo(
                    context,
                    StudentTestAnswersScreen(
                      cubit: cubit,
                      test: test,
                    ));
              },
              width: deviceInfo.screenwidth * 0.55,
            ),
          ),
        ],
      ),
    );
  }

  String _mapTime(int ellapsedTime) {
    final minutes = _mapMinutes(ellapsedTime);
    final seconds = _mapSeconds(ellapsedTime);
    if (minutes == 0)
      return '$seconds seconds';
    else
      return '$minutes Minute $seconds Second';
  }

  int? _mapSeconds(int ellapsedTime) {
    final seconds = ellapsedTime % 60;
    return seconds;
  }

  int _mapMinutes(int ellapsedTime) {
    final minutes = ellapsedTime / 60;
    return minutes.toInt();
  }
}
