import 'package:e_learning/layout/student/student_layout.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/modules/test_module/student_test/test_view/student_test_result/student_result_statistics_screen/student_results_card_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../student_test_leader_board.dart';

class StudentTestResultScreen extends StatelessWidget {
  const StudentTestResultScreen({Key? key, required this.test, required this.cubit})
      : super(key: key);

  final Test test;
  final TestCubit cubit;

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Text(test.name!),
            centerTitle: true,
            leading: Container(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: StudentResultsCardBuildItem(
                      deviceInfo: deviceInfo,
                      test: test,
                      cubit: cubit,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: defaultMaterialIconButton(
                          onPressed: () {
                            navigateTo(context, StudentTestLeaderBoard());
                          },
                          icon: Icons.leaderboard_outlined,
                          text: 'الترتيب',
                          backgroundColor: successColor,
                          height: 15,
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Expanded(
                        child: defaultMaterialIconButton(
                          height: 15,
                          onPressed: () {
                            navigateToAndFinish(context, StudentLayout());
                          },
                          icon: Icons.close,
                          text: 'انهاء',
                          backgroundColor: errorColor,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
