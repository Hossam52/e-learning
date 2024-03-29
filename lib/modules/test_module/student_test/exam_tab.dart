import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/student_test/student_test_build_item.dart';
import 'package:e_learning/modules/test_module/student_test/test_view/student_test_quetion.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'test_view/test_start_alert_screen.dart';

class ExamTab extends StatelessWidget {
  const ExamTab(
      {Key? key,
      required this.deviceInfo,
      required this.isChampion,
      required this.tests,
      this.onChampionTap})
      : super(key: key);

  final DeviceInformation deviceInfo;
  final bool isChampion;
  final void Function(int index)? onChampionTap;
  final List<Test> tests;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: GridView.builder(
          itemCount: tests.length,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.33,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10.w,
          ),
          itemBuilder: (context, index) {
            var test = tests[index];
            return StudentTestBuildItem(
              onTap: () {
                if (test.result != null) {
                  showSnackBar(
                      context: context, text: context.tr.taken_exam_before);
                } else if (isChampion) {
                  TestLayoutCubit.get(context).changeSelectedTest(index, tests);
                  if (onChampionTap != null) {
                    onChampionTap!(index);
                  }
                } else {
                  navigateTo(
                      context,
                      TestStartAlertScreen(
                        test: test,
                      ));
                }
              },
              label: textLabel(context, test),
              testName: test.name!,
              teacherName: test.teacher!.name!, // 'ا / اسم الاستاذ',
              isSelected:
                  TestLayoutCubit.get(context).selectedTestIndex == index
                      ? true
                      : false,
              labelColor: test.result != null
                  ? resultPercentageColor(
                      textLabel(context, test, isText: false))
                  : primaryColor,
            );
          }),
    );
  }

  dynamic textLabel(BuildContext context, Test test, {bool isText = true}) {
    if (test.result != null) {
      int percent =
          ((num.parse(test.result!) / test.questions!.length) * 100).toInt();
      return isText ? "$percent%" : percent;
    } else
      return context.tr.new_word;
  }
}
