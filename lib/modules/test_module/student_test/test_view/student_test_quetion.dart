import 'dart:async';

import 'package:e_learning/layout/student/student_layout.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/modules/test_module/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import 'student_test_question_build_item.dart';

class StudentTestQuestion extends StatefulWidget {
  const StudentTestQuestion({
    Key? key,
    required this.test,
    required this.isChampion,
  }) : super(key: key);

  final Test test;
  final bool isChampion;

  @override
  _StudentTestQuestionState createState() => _StudentTestQuestionState();
}

class _StudentTestQuestionState extends State<StudentTestQuestion> {
  Timer? timer;

  bool isLast = false;
  bool hasError = false;
  late int testMaxTime;

  @override
  void initState() {
    testMaxTime = int.parse(widget.test.minuteNum!);
    if (widget.test.questions!.length <= 1) {
      isLast = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: BlocProvider(
        create: (context) => TestCubit()
          ..startTimer(
            time: int.parse(widget.test.minuteNum!),
            test: widget.test,
            context: context,
            isChampion: widget.isChampion,
          )
          ..initStudentTestAnswerList(widget.test.questions!.length)
          ..changeTestCounter(widget.isChampion),
        child: BlocConsumer<TestCubit, TestStates>(
          listener: (context, state) {},
          builder: (context, state) {
            TestCubit cubit = TestCubit.get(context);
            return ProgressHUD(
              indicatorWidget: cubit.hasStudentEndTestError
                  ? showErrorWidget(cubit, context)
                  : null,
              child: responsiveWidget(
                responsive: (_, deviceInfo) {
                  return Scaffold(
                      appBar: AppBar(
                        elevation: 1,
                        title: Text(widget.test.name!),
                        centerTitle: true,
                        leading: Container(),
                      ),
                      body: WillPopScope(
                        onWillPop: () async {
                          defaultAlertDialog(
                            context: context,
                            title: context.tr.exit_from_exam,
                            subTitle: context
                                .tr.confirm_exit_all_answered_will_be_deleted,
                            // 'هل تريد ان تخرج من الاختبار كل ما اجبته سوف يحذف؟',
                            buttonConfirm: context.tr.exit,
                            buttonReject: context.tr.cancel,
                            onConfirm: () {
                              navigateToAndFinish(context, StudentLayout());
                            },
                            onReject: () {},
                          );
                          return false;
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.timer,
                                    color: cubit.testTimerColor == thirdColor
                                        ? Colors.black
                                        : cubit.testTimerColor,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: LinearProgressIndicator(
                                        value: 1 -
                                            cubit.testTime.inSeconds /
                                                (testMaxTime * 60),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                cubit.testTimerColor),
                                        backgroundColor: Colors.grey[300],
                                        minHeight: 8,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${cubit.testMinutes}:${cubit.testSeconds}',
                                    style: TextStyle(
                                      color: cubit.testTimerColor == thirdColor
                                          ? Colors.black
                                          : cubit.testTimerColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GridView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              itemCount: widget.test.questions!.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 10,
                                childAspectRatio: 4,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 3,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: cubit.studentCurrentIndex == index
                                        ? successColor
                                        : cubit.studentCurrentIndex > index
                                            ? primaryColor
                                            : thirdColor,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: deviceInfo.screenHeight * 0.015),
                            Expanded(
                              child: PageView.builder(
                                  itemCount: widget.test.questions!.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: cubit.studentQuestionController,
                                  onPageChanged: (value) {
                                    if (cubit.studentCurrentIndex ==
                                        widget.test.questions!.length - 1) {
                                      isLast = true;
                                    } else {
                                      isLast = false;
                                    }
                                    cubit.changeTestDuration();
                                  },
                                  itemBuilder: (context, index) {
                                    var question =
                                        widget.test.questions![index];
                                    return StudentTestQuestionBuildItem(
                                      deviceInfo: deviceInfo,
                                      questionNumber:
                                          '${context.tr.question} ${cubit.studentCurrentIndex + 1}/${widget.test.questions!.length}',
                                      cubit: cubit,
                                      question: question,
                                      questionIndex: index,
                                    );
                                  }),
                            ),
                            SizedBox(height: deviceInfo.screenHeight * 0.02),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: DefaultAppButton(
                                      text: context.tr.previous,
                                      isLoading: false,
                                      textStyle: thirdTextStyle(deviceInfo),
                                      isDisabled: false,
                                      onPressed: () {
                                        if (cubit.studentCurrentIndex > 0) {
                                          cubit.navigateStudentToNextQuestion(
                                              isNext: false);
                                        }
                                      },
                                      background: Colors.transparent,
                                      border: primaryColor,
                                      textColor: primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 25),
                                  Expanded(
                                    child: DefaultAppButton(
                                      text: isLast
                                          ? context.tr.finish
                                          : context.tr.next,
                                      isLoading: false,
                                      background: isLast ? successColor : null,
                                      textStyle: thirdTextStyle(deviceInfo),
                                      isDisabled: false,
                                      onPressed: () {
                                        if (cubit.studentChooseAnswerList[
                                                cubit.studentCurrentIndex] !=
                                            null) {
                                          if (isLast) {
                                            cubit.endStudentTest(
                                              context: context,
                                              test: widget.test,
                                              isChampion: widget.isChampion,
                                            );
                                          } else {
                                            cubit.navigateStudentToNextQuestion(
                                                isNext: true);
                                          }
                                        } else {
                                          showAnswerToast();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: deviceInfo.screenHeight * 0.02),
                          ],
                        ),
                      ));
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void showAnswerToast() {
    showToast(
      msg: context.tr.please_select_answer,
      state: ToastStates.WARNING,
    );
  }

  Widget showErrorWidget(TestCubit cubit, BuildContext context) => Container(
          child: Column(
        children: [
          Icon(
            Icons.error,
            color: Colors.white,
            size: 45,
          ),
          TextButton(
            onPressed: () {
              cubit.sendStudentResult(
                context: context,
                test: widget.test,
                result: cubit.correctAnswersCount,
                elapsedTime: cubit.elapsedTime,
                isTryAgain: true,
                isChampion: widget.isChampion,
              );
            },
            child: Text(context.tr.try_again),
          ),
        ],
      ));
}
