import 'package:duration_picker/duration_picker.dart';
import 'package:e_learning/models/teacher/general_teacher_add_data_model.dart';
import 'package:e_learning/models/teacher/test/test_model.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/modules/test_module/cubit/states.dart';
import 'package:e_learning/modules/test_module/teacher/edit_test_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_state_button/progress_button.dart';

import 'teacher_question_review_build.dart';

// ignore: must_be_immutable
class TeacherTestReviewScreen extends StatefulWidget {
  TeacherTestReviewScreen({
    Key? key,
    required this.questionNumber,
    required this.testName,
    required this.test,
    required this.generalAddTeacherDataModel,
    this.isEdit = false,
    this.duration = const Duration(minutes: 20),
    this.groupId,
    this.testId,
  }) : super(key: key);

  final int questionNumber;
  final String testName;
  List<QuestionDataModel> test;
  final GeneralAddTeacherDataModel generalAddTeacherDataModel;
  final int? groupId;
  final int? testId;
  final bool isEdit;
  Duration duration;

  @override
  State<TeacherTestReviewScreen> createState() =>
      _TeacherTestReviewScreenState();
}

class _TeacherTestReviewScreenState extends State<TeacherTestReviewScreen> {
  @override
  void initState() {
    if (widget.isEdit) {
      TestCubit.get(context).questionList = widget.test;
    }
    TestCubit.get(context).uploadTestButtonState = ButtonState.idle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (_, deviceInfo) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(widget.testName),
          centerTitle: true,
          leading: defaultBackButton(context, deviceInfo.screenHeight),
        ),
        body: BlocConsumer<TestCubit, TestStates>(
          listener: (context, state) {},
          builder: (context, state) {
            TestCubit cubit = TestCubit.get(context);
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Card(
                        elevation: 2,
                        shadowColor: Colors.black38,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 32.0.h, bottom: 20.h),
                              child: Text(
                                widget.groupId != null
                                    ? 'اسألة الواجب'
                                    : 'اسألة الاختبار',
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
                                      itemCount: widget.test.length,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.h),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: 10.h,
                                      ),
                                      itemBuilder: (context, index) =>
                                          TeacherQuestionReviewBuild(
                                        questionNumber:
                                            widget.test[index].questionText,
                                        question:
                                            widget.test[index].questionText,
                                        questionImage:
                                            widget.test[index].questionImage,
                                        chooseList:
                                            widget.test[index].chooseList!,
                                        correctAnswerIndex:
                                            widget.test[index].answerIndex,
                                        isEdit: widget.isEdit,
                                        onEdit: widget.isEdit
                                            ? () async {
                                                final newValue =
                                                    await Navigator.of(context)
                                                        .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditTestScreen(
                                                      questionNumber:
                                                          widget.questionNumber,
                                                      currentIndex: index,
                                                      questionDataModel:
                                                          widget.test[index],
                                                      generalAddTeacherDataModel:
                                                          widget
                                                              .generalAddTeacherDataModel,
                                                      testName: widget.testName,
                                                    ),
                                                  ),
                                                );
                                                if (newValue == 'update') {
                                                  widget.test =
                                                      cubit.questionList;
                                                  cubit.emit(TestChangeState());
                                                }
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 30),
                              child: Row(
                                children: [
                                  Text(
                                    widget.groupId != null
                                        ? 'تحديد وقت الواجب'
                                        : 'تحديد وقت الاختبار',
                                    style: secondaryTextStyle(deviceInfo)
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      widget.duration =
                                          (await showDurationPicker(
                                        context: context,
                                        initialTime: widget.duration,
                                        snapToMins: 5,
                                      ))!;
                                      cubit.changeTestDuration();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: thirdColor, width: 1.5),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_outlined,
                                            color: primaryColor,
                                          ),
                                          SizedBox(width: 11.w),
                                          Text(
                                            "${widget.duration.inMinutes} دقيقه",
                                            style:
                                                secondaryTextStyle(deviceInfo)
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400),
                                          ),
                                        ],
                                      ),
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
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      if (widget.isEdit == false)
                        Expanded(
                          child: DefaultAppButton(
                            text: 'تعديل',
                            textStyle: thirdTextStyle(deviceInfo),
                            width: 140.w,
                            background: thirdColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 2,
                        child: DefaultProgressButton(
                          buttonState: cubit.uploadTestButtonState,
                          idleText: 'انهاء',
                          loadingText: 'Loading',
                          failText: 'حدث خطأ',
                          successText: 'تم الاضافة بنجاح',
                          borderRadius: 12.0,
                          onPressed: () async {
                            cubit.addTestMethod(
                              testDataModel: generateTestModel(),
                              context: context,
                              groupId: widget.groupId,
                              isEdit: widget.isEdit,
                              testId: widget.testId,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  TestDataModel generateTestModel() => TestDataModel(
      name: widget.testName,
      stageId:
      widget.generalAddTeacherDataModel.stageId,
      classroomId: widget
          .generalAddTeacherDataModel.classroomId,
      termId:
      widget.generalAddTeacherDataModel.termId,
      subjectId:
      widget.generalAddTeacherDataModel.subjectId,
      minuteNumber: widget.duration.inMinutes,
      questionDataModel: widget.test,
    );
}
