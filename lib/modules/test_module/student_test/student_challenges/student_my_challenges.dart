import 'dart:developer';

import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/test_module/student_test/test_view/test_start_alert_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/default_refresh_widget.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'student_challenges_build_item.dart';

class StudentMyChallenges extends StatefulWidget {
  const StudentMyChallenges({Key? key}) : super(key: key);

  @override
  _StudentMyChallengesState createState() => _StudentMyChallengesState();
}

class _StudentMyChallengesState extends State<StudentMyChallenges> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    TestLayoutCubit.get(context).getStudentTests(TestType.Challenge);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('My challenges Challenge');
    return BlocConsumer<TestLayoutCubit, TestLayoutStates>(
      listener: (context, state) {
        if (state is StudentTestsSuccessState) {
          refreshController.refreshCompleted();
        } else if (state is StudentTestsErrorState)
          refreshController.refreshFailed();
      },
      builder: (context, state) {
        TestLayoutCubit cubit = TestLayoutCubit.get(context);
        return DefaultRefreshWidget(
          refreshController: refreshController,
          enablePullUp: false,
          onRefresh: () => cubit.getStudentTests(TestType.Challenge),
          child: responsiveWidget(
            responsive: (context, deviceInfo) {
              return Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    state is! StudentTestsLoadingState,
                fallbackBuilder: (context) => DefaultLoader(),
                widgetBuilder: (context) => cubit.noStudentChallengeData
                    ? NoDataWidget(
                        onPressed: () =>
                            cubit.getStudentTests(TestType.Challenge))
                    : ListView.separated(
                        itemCount: cubit.studentChallengeList.length,
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16.0),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 30),
                        itemBuilder: (context, index) {
                          var test = cubit.studentChallengeList[index];
                          return StudentChallengeBuildItem(
                            deviceInfo: deviceInfo,
                            backgroundColor: successColor,
                            buttonText: generateButtonText(test.result),
                            status: context.tr.tournment_now,
                            testName: test.name!,
                            onPressed:
                                generateButtonFunction(test.result, test),
                          );
                        },
                      ),
              );
            },
          ),
        );
      },
    );
  }

  String generateButtonText(String? result) {
    if (result != null) {
      return context.tr.done_subscription;
    } else if (authType == false) {
      return context.tr.you_could_not_join;
    } else {
      return context.tr.join;
    }
  }

  Function()? generateButtonFunction(String? result, Test test) {
    if (result != null || authType == false) {
      return null;
    } else {
      return () {
        navigateTo(context, TestStartAlertScreen(test: test));
      };
    }
  }
}
