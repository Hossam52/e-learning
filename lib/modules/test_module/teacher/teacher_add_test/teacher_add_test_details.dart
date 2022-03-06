import 'package:e_learning/models/teacher/general_teacher_add_data_model.dart';
import 'package:e_learning/models/teacher/test/test_model.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/teacher/teacher_add_test/test_teacher_review/teacher_test_review_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_drop_down.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'teacher_add_question_screen.dart';

class TeacherAddTestDetails extends StatefulWidget {
  const TeacherAddTestDetails({
    Key? key,
    required this.deviceInfo,
    this.groupId,
    this.test,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final Test? test;
  final int? groupId;

  @override
  _TeacherAddTestDetailsState createState() => _TeacherAddTestDetailsState();
}

class _TeacherAddTestDetailsState extends State<TeacherAddTestDetails> {
  final TextEditingController testNameController = TextEditingController();

  final TextEditingController questionsNumberController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    AppCubit.get(context).getTeacherStages();
    AppCubit.get(context).getTeacherTerms();
    if (widget.groupId != null) {
      AppCubit.get(context).getTeacherAndStudentSubjects(false);
    }
    if (widget.test != null) {
      testNameController.text = widget.test!.name!;
      questionsNumberController.text =
          widget.test!.questions!.length.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultGestureWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.groupId != null ? 'انشاء واجب' : "انشاء اختبار"),
          elevation: 1,
          centerTitle: true,
          leading: defaultBackButton(context, widget.deviceInfo.screenHeight),
        ),
        body: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is GetStagesSuccessState) {
              if (widget.test != null) {
                AppCubit cubit = AppCubit.get(context);
                cubit.onChangeStage(widget.test!.stage!);
                cubit.onChangeClass(widget.test!.classroom!);
                cubit.onTermChange(widget.test!.term!);
                cubit.onSubjectChange(widget.test!.subject!);
              }
            }
          },
          builder: (context, state) {
            AppCubit appCubit = AppCubit.get(context);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      DefaultFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty)
                            return 'هذا الحقل مطلوب';
                          return null;
                        },
                        controller: testNameController,
                        labelText: widget.groupId != null
                            ? 'اسم الواجب'
                            : 'اسم الامتحان',
                        hintText: widget.groupId != null
                            ? 'اسم الواجب'
                            : 'اسم الامتحان',
                        haveBackground: true,
                      ),
                      SizedBox(height: 17.h),
                      DefaultDropDown(
                        label: 'المرحله',
                        hint: 'المرحله',
                        haveBackground: true,
                        onChanged: (value) {
                          appCubit.onChangeStage(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'هذا الحقل مطلوب';
                          return null;
                        },
                        items: appCubit.stageNamesList,
                        selectedValue: appCubit.teacherSelectedStage,
                        isLoading: appCubit.isStagesLoading,
                      ),
                      SizedBox(height: 17.h),
                      DefaultDropDown(
                        label: 'السنه',
                        hint: 'السنه',
                        haveBackground: true,
                        onChanged: (value) {
                          appCubit.onChangeClass(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'هذا الحقل مطلوب';
                          return null;
                        },
                        items: appCubit.classNamesList,
                        selectedValue: appCubit.selectedClassName,
                      ),
                      SizedBox(height: 17.h),
                      DefaultDropDown(
                        label: 'الترم',
                        hint: 'الترم',
                        haveBackground: true,
                        onChanged: (value) {
                          appCubit.onTermChange(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'هذا الحقل مطلوب';
                          return null;
                        },
                        items: appCubit.termNamesList,
                        selectedValue: appCubit.selectedTermName,
                        isLoading: appCubit.isTermsLoading,
                      ),
                      SizedBox(height: 17.h),
                      SizedBox(height: 17.h),
                      DefaultFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty)
                            return 'هذا الحقل مطلوب';
                          return null;
                        },
                        controller: questionsNumberController,
                        labelText: 'عدد الاسئلة',
                        hintText: 'عدد الاسئلة',
                        haveBackground: true,
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      SizedBox(height: 50.h),
                      DefaultAppButton(
                        text: widget.test != null ? 'تعديل' : 'اضافة',
                        textStyle: thirdTextStyle(widget.deviceInfo),
                        isLoading: isLoading,
                        onPressed: () async {
                          formKey.currentState!.save();
                          if (formKey.currentState!.validate()) {
                            if (widget.test == null) {
                              navigateTo(
                                  context,
                                  TeacherAddQuestionScreen(
                                    questionNumber: int.parse(
                                        questionsNumberController.text),
                                    testName: testNameController.text,
                                    groupId: widget.groupId,
                                    generalAddTeacherDataModel:
                                        GeneralAddTeacherDataModel(
                                      stageId: appCubit.selectedStageId!,
                                      classroomId: appCubit.selectedClassId!,
                                      termId: appCubit.selectedTermId!,
                                      subjectId: appCubit.selectedSubjectId!,
                                    ),
                                    test: widget.test,
                                  ));
                            } else {
                              isLoading = true;
                              appCubit.emit(AppChangeState());
                              List<QuestionDataModel> questions =
                                  await addTestDataForEdit(
                                      widget.test!, appCubit);
                              isLoading = false;
                              appCubit.emit(AppChangeState());
                              navigateTo(
                                context,
                                TeacherTestReviewScreen(
                                  questionNumber:
                                      int.parse(questionsNumberController.text),
                                  testName: testNameController.text,
                                  groupId: widget.groupId,
                                  generalAddTeacherDataModel:
                                      GeneralAddTeacherDataModel(
                                    stageId: appCubit.selectedStageId!,
                                    classroomId: appCubit.selectedClassId!,
                                    termId: appCubit.selectedTermId!,
                                    subjectId: appCubit.selectedSubjectId!,
                                  ),
                                  test: questions,
                                  duration: Duration(
                                      minutes:
                                          int.parse(widget.test!.minuteNum!)),
                                  isEdit: true,
                                  testId: widget.test!.id!,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<QuestionDataModel>> addTestDataForEdit(
      Test test, AppCubit appCubit) async {
    List<QuestionDataModel> questions = [];
    for (var question in test.questions!) {
      questions.add(
        QuestionDataModel(
          questionText: question.questionText!,
          answerIndex: int.parse(question.answer!),
          questionImage: question.questionImage!.split('.').last != 'txt'
              ? await appCubit.urlToFile(question.questionImage!)
              : null,
          chooseList: [
            if (question.chose1Text != null)
              Choose(
                  chooseText: question.chose1Text,
                  chooseImage: question.chose1Image!.split('.').last != 'txt'
                      ? await appCubit.urlToFile(question.chose1Image!)
                      : null),
            if (question.chose2Text != null)
              Choose(
                  chooseText: question.chose2Text,
                  chooseImage: question.chose2Image!.split('.').last != 'txt'
                      ? await appCubit.urlToFile(question.chose2Image!)
                      : null),
            if (question.chose3Text != null)
              Choose(
                  chooseText: question.chose3Text,
                  chooseImage: question.chose3Image!.split('.').last != 'txt'
                      ? await appCubit.urlToFile(question.chose3Image!)
                      : null),
            if (question.chose4Text != null)
              Choose(
                  chooseText: question.chose4Text,
                  chooseImage: question.chose4Image!.split('.').last != 'txt'
                      ? await appCubit.urlToFile(question.chose4Image!)
                      : null),
          ],
        ),
      );
    }
    return questions;
  }

  @override
  void dispose() {
    testNameController.dispose();
    questionsNumberController.dispose();
    super.dispose();
  }
}
