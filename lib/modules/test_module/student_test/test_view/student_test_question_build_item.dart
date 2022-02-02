import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';

import 'student_test_answer_build_item.dart';

class StudentTestQuestionBuildItem extends StatelessWidget {
  StudentTestQuestionBuildItem({
    Key? key,
    required this.deviceInfo,
    required this.cubit,
    required this.questionNumber,
    required this.question,
    required this.questionIndex,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final TestCubit cubit;
  final String questionNumber;
  final Question question;
  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: deviceInfo.screenHeight * 0.01),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Text(
                questionNumber,
                style: secondaryTextStyle(deviceInfo).copyWith(
                  fontSize: 16,
                ),
              ),
            ),
            defaultDivider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.questionText!,
                    style: secondaryTextStyle(null)
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 10),
                  if (question.questionImage != null)
                    Image.network(
                      question.questionImage!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, exception, stackTrace) {
                        return Container();
                      },
                    ),
                ],
              ),
            ),
            defaultDivider(),
            if (question.chose1Text != null)
              StudentTestAnswerBuildItem(
                value: '0',
                groupValue: cubit.studentChooseAnswerList[questionIndex],
                title: question.chose1Text!,
                image: question.chose1Image,
                onChanged: (value) {
                  cubit.onChangeTestAnswer(value, questionIndex);
                },
              ),
            if (question.chose2Text != null)
              StudentTestAnswerBuildItem(
                value: '1',
                groupValue: cubit.studentChooseAnswerList[questionIndex],
                title: question.chose2Text!,
                image: question.chose2Image,
                onChanged: (value) {
                  cubit.onChangeTestAnswer(value, questionIndex);
                },
              ),
            if (question.chose3Text != null)
              StudentTestAnswerBuildItem(
                value: '2',
                groupValue: cubit.studentChooseAnswerList[questionIndex],
                title: question.chose3Text!,
                image: question.chose3Image,
                onChanged: (value) {
                  cubit.onChangeTestAnswer(value, questionIndex);
                },
              ),
            if (question.chose4Text != null)
              StudentTestAnswerBuildItem(
                value: '3',
                groupValue: cubit.studentChooseAnswerList[questionIndex],
                title: question.chose4Text!,
                image: question.chose4Image,
                onChanged: (value) {
                  cubit.onChangeTestAnswer(value, questionIndex);
                },
              ),
          ],
        ),
      ),
    );
  }
}
