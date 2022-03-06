import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'student_test_answers_build_item.dart';

class StudentTestAnswersScreen extends StatelessWidget {
  StudentTestAnswersScreen({Key? key, required this.cubit, required this.test})
      : super(key: key);

  final TestCubit cubit;
  final Test test;

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Text(test.name!),
            centerTitle: true,
            leading: defaultBackButton(context, deviceInfo.screenHeight),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 2,
                      shadowColor: Colors.black38,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: cubit.wrongQuestionsIndex.length == 0
                          ? noData('لا يوجد لديك اجابات خاطئة')
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 32.0.h, bottom: 20.h),
                                  child: Text(
                                    'الاجابات الصحيحه',
                                    style: secondaryTextStyle(deviceInfo)
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                                defaultDivider(),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ListView.separated(
                                          itemCount:
                                              cubit.wrongQuestionsIndex.length,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 35.h),
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                            height: 10.h,
                                          ),
                                          itemBuilder: (context, index) {
                                            int questionIndex = cubit
                                                .wrongQuestionsIndex[index];
                                            var question =
                                                test.questions![questionIndex];
                                            return StudentAnswersBuildItem(
                                              questionNumber: questionIndex + 1,
                                              deviceInfo: deviceInfo,
                                              question: question.questionText!,
                                              wrongAnswer: addAnswer(
                                                  questionIndex,
                                                  question,
                                                  true),
                                              rightAnswer: addAnswer(
                                                  questionIndex,
                                                  question,
                                                  false),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String addAnswer(int currentIndex, Question question, bool isWrong) {
    String? answer =
        isWrong ? cubit.studentChooseAnswerList[currentIndex] : question.answer;
    if (answer == '0')
      return question.chose1Text!;
    else if (answer == '1')
      return question.chose2Text!;
    else if (answer == '2')
      return question.chose3Text!;
    else
      return question.chose4Text!;
  }
}
