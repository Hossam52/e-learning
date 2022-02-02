import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/student_test/student_test_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'test_view/test_start_alert_screen.dart';

class ExamTab extends StatelessWidget {
  const ExamTab({
    Key? key,
    required this.deviceInfo,
    required this.isChampion,
    required this.tests,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final bool isChampion;
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
                if(test.result != null) {
                  showSnackBar(context: context, text: 'لقد قمت بأداء هذا الامتحان من قبل');
                } else if(isChampion) {
                  TestLayoutCubit.get(context).changeSelectedTest(index);
                } else {
                  navigateTo(context, TestStartAlertScreen(
                    test: test,
                  ));
                }
              },
              label: textLabel(test),
              testName: test.name!,
              teacherName: 'ا / اسم الاستاذ',
              isSelected: TestLayoutCubit.get(context).selectedTestIndex == index ? true : false,
              labelColor: test.result != null
                  ? resultPercentageColor(textLabel(test, isText: false)) : primaryColor,
            );
          }),
    );
  }
  dynamic textLabel(Test test, {bool isText = true}) {
    if(test.result != null) {
      int percent = ((num.parse(test.result!) / test.questions!.length) * 100).toInt();
      return isText
          ? "$percent%"
          : percent;
    }
    else return 'جديد';
  }
}
