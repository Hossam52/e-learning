import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/student_test/student_champion/champion_choose_friends_screen.dart';
import 'package:e_learning/modules/test_module/student_test/student_champion/create_champion_screen.dart';
import 'package:e_learning/modules/test_module/student_test/test_view/test_start_alert_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherProfileTestBuildItem extends StatelessWidget {
  const TeacherProfileTestBuildItem({Key? key, required this.test})
      : super(key: key);

  final Test test;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text("${test.name}"),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        trailing: SizedBox(
          // width: 120.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  if (test.result != null) {
                    showSnackBar(
                        context: context, text: context.tr.taken_exam_before
                        // 'لقد قمت بأداء هذا الامتحان من قبل'
                        );
                  } else {
                    navigateTo(
                        context,
                        TestStartAlertScreen(
                          test: test,
                        ));
                  }
                },
                child: Text(context.tr.make_test
                    // 'اختبر'
                    ),
              ),
              SizedBox(width: 5),
              TextButton(
                child: Text(
                  context.tr.compete,
                  // 'نافس',
                  style: TextStyle(color: successColor),
                ),
                onPressed: () {
                  if (test.result != null) {
                    showSnackBar(
                        context: context, text: context.tr.taken_exam_before
                        //  'لقد قمت بأداء هذا الامتحان من قبل'
                        );
                  } else {
                    navigateTo(
                        context,
                        ChampionChooseFriendScreen(
                          testId: test.id!,
                          test: test,
                        ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
