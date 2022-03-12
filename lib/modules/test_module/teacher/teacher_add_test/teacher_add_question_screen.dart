import 'package:e_learning/models/teacher/general_teacher_add_data_model.dart';
import 'package:e_learning/models/teacher/test/test_model.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/modules/test_module/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_stepper/stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'test_componants/teacher_answer_build_item.dart';
import 'test_componants/test_image_remove_button.dart';
import 'test_teacher_review/teacher_test_review_screen.dart';

class TeacherAddQuestionScreen extends StatefulWidget {
  TeacherAddQuestionScreen({
    Key? key,
    required this.questionNumber,
    required this.testName,
    required this.generalAddTeacherDataModel,
    this.groupId,
    this.test,
  }) : super(key: key);

  final int questionNumber;
  final String testName;
  final GeneralAddTeacherDataModel generalAddTeacherDataModel;
  final int? groupId;
  final Test? test;

  @override
  _TeacherAddQuestionScreenState createState() =>
      _TeacherAddQuestionScreenState();
}

class _TeacherAddQuestionScreenState extends State<TeacherAddQuestionScreen> {
  int currentIndex = 0;

  int answerNumbers = 1;

  int? answerIndex;

  bool hasAnswer = false;

  final TextEditingController questionController = TextEditingController();

  final List<TextEditingController> chooseControllerList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final PageController pageController = PageController();

  bool isLast = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.questionNumber <= 1) {
      isLast = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestCubit(),
      child: responsiveWidget(
        responsive: (_, deviceInfo) => DefaultGestureWidget(
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.groupId != null
                  ? context.tr.create_homework
                  : context.tr.create_test),
              elevation: 1,
              centerTitle: true,
              leading: defaultBackButton(context, deviceInfo.screenHeight),
            ),
            body: BlocConsumer<TestCubit, TestStates>(
              listener: (context, state) {},
              builder: (context, state) {
                TestCubit cubit = TestCubit.get(context);
                return Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 55,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 26.w),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  decoration: BoxDecoration(
                                    color: Color(0xff8BCAFD),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: NumberStepper(
                                    numbers: List.generate(
                                        widget.questionNumber,
                                        (index) => index + 1),
                                    scrollingDisabled: false,
                                    enableNextPreviousButtons: false,
                                    stepRadius: deviceInfo.screenwidth / 25,
                                    lineLength: 5,
                                    lineColor: Colors.transparent,
                                    activeStepBorderWidth: 0,
                                    activeStepBorderPadding: 0,
                                    stepColor: Colors.transparent,
                                    activeStepColor: primaryColor,
                                    enableStepTapping: false,
                                    activeStep: currentIndex,
                                  ),
                                ),
                              ),
                            ),
                            PageView.builder(
                              itemCount: widget.questionNumber,
                              controller: pageController,
                              physics: NeverScrollableScrollPhysics(),
                              onPageChanged: (index) {
                                if (currentIndex == widget.questionNumber - 1) {
                                  setState(() {
                                    isLast = true;
                                  });
                                } else {
                                  setState(() {
                                    isLast = false;
                                  });
                                }
                              },
                              itemBuilder: (context, index) => Card(
                                elevation: 1,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                margin: EdgeInsets.only(
                                    top: 50, bottom: 2, left: 22, right: 22),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 40.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: DefaultFormField(
                                                validation: (value) {
                                                  if (value == null ||
                                                      value.isEmpty)
                                                    return context.tr
                                                        .this_field_is_required;
                                                  return null;
                                                },
                                                controller: questionController,
                                                labelText:
                                                    context.tr.add_question,
                                                hintText:
                                                    context.tr.add_question,
                                                haveBackground: true,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16.0),
                                              child: IconButton(
                                                onPressed: () async {
                                                  await alertDialogImagePicker(
                                                    context: context,
                                                    cubit: cubit,
                                                    onTap: () => cubit
                                                        .addImageDataMethod(
                                                            true, null),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                  size: 22.w,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        if (cubit.questionImage != null)
                                          TestImageRemoveButton(
                                            onPressed: () {
                                              cubit.removeImageDataMethod(
                                                  true, index);
                                            },
                                            image: Image.file(
                                              cubit.questionImage!,
                                              width:
                                                  deviceInfo.screenwidth * 0.65,
                                            ),
                                          ),
                                        SizedBox(height: 20.h),
                                        ListView.separated(
                                          itemCount: cubit.answerNumber,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          separatorBuilder: (context, index) =>
                                              SizedBox(height: 15.h),
                                          itemBuilder: (context, index) =>
                                              TeacherAnswerBuildItem(
                                            key: ValueKey(index),
                                            cubit: cubit,
                                            index: index,
                                            borderColor:
                                                cubit.correctAnswerIndex ==
                                                        index
                                                    ? successColor
                                                    : Colors.grey,
                                            controller:
                                                chooseControllerList[index],
                                            hintText: context.tr.answer,
                                            hasAnswer: cubit.hasAnswer,
                                            image: cubit.answerImages
                                                    .asMap()
                                                    .containsKey(index)
                                                ? cubit.answerImages[index]
                                                : null,
                                            onImageTap: () async {
                                              await alertDialogImagePicker(
                                                context: context,
                                                cubit: cubit,
                                                onTap: () =>
                                                    cubit.addImageDataMethod(
                                                        false, index),
                                              );
                                            },
                                            isCorrectAnswer:
                                                cubit.correctAnswerIndex ==
                                                        index
                                                    ? true
                                                    : false,
                                            onCheck: () {
                                              cubit
                                                  .onChangeCorrectAnswer(index);
                                            },
                                          ),
                                        ),
                                        if (cubit.answerNumber < 4)
                                          ListTile(
                                            title: Text(context.tr.add_answer),
                                            trailing: Icon(Icons.add),
                                            onTap: () {
                                              cubit.addAnswer();
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: const EdgeInsets.all(22.0),
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
                                  if (currentIndex > 0) {
                                    setState(() {
                                      currentIndex--;
                                    });
                                    pageController.animateToPage(
                                      currentIndex,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeIn,
                                    );
                                    addPreviousQuestionData(
                                        cubit, currentIndex);
                                  }
                                },
                                background: Colors.transparent,
                                border: primaryColor,
                                textColor: primaryColor,
                              ),
                            ),
                            SizedBox(width: 35),
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
                                  formKey.currentState!.save();
                                  if (formKey.currentState!.validate()) {
                                    if (cubit.hasAnswer) {
                                      addQuestionData(cubit, currentIndex);
                                      if (isLast == false)
                                        nextPageFunction(cubit);
                                      if (cubit.questionList
                                          .asMap()
                                          .containsKey(currentIndex))
                                        addPreviousQuestionData(
                                            cubit, currentIndex);
                                      else if (isLast == false)
                                        clearQuestionData(cubit);
                                      if (isLast) endTest(cubit);
                                    } else {
                                      showToast(
                                          msg: context.tr.choose_right_answer,
                                          state: ToastStates.WARNING);
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    pageController.dispose();
    chooseControllerList.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  void nextPageFunction(TestCubit cubit) {
    setState(() {
      currentIndex++;
    });
    pageController.animateToPage(
      currentIndex,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    if (widget.test != null) {
      print(currentIndex);
      addPreviousQuestionData(cubit, 1);
    }
  }

  void clearQuestionData(TestCubit cubit) {
    questionController.clear();
    chooseControllerList.forEach((element) {
      element.clear();
    });
    cubit.correctAnswerIndex = null;
    cubit.hasAnswer = false;
    cubit.answerNumber = 2;
    cubit.answerImages = List.generate(4, (index) => null);
    cubit.questionImage = null;
  }

  void addQuestionData(TestCubit cubit, int currentIndex) {
    cubit.addQuestion(
      isEdit: cubit.questionList.asMap().containsKey(currentIndex),
      currentIndex: currentIndex,
      questionText: questionController.text,
      chooseList: List.generate(
          cubit.answerNumber,
          (index) => Choose(
                chooseText: chooseControllerList[index].text,
                chooseImage: cubit.answerImages[index],
              )),
      answerIndex: cubit.correctAnswerIndex!,
    );
  }

  void addPreviousQuestionData(TestCubit cubit, currentIndex) {
    questionController.text = cubit.questionList[currentIndex].questionText;
    cubit.answerNumber = cubit.questionList[currentIndex].chooseList!.length;
    cubit.correctAnswerIndex = cubit.questionList[currentIndex].answerIndex;
    cubit.hasAnswer = true;
    for (int i = 0;
        i < cubit.questionList[currentIndex].chooseList!.length;
        i++) {
      chooseControllerList[i].text =
          cubit.questionList[currentIndex].chooseList![i].chooseText!;
      cubit.answerImages[i] =
          cubit.questionList[currentIndex].chooseList![i].chooseImage;
    }
    cubit.questionImage = cubit.questionList[currentIndex].questionImage;
  }

  void endTest(TestCubit cubit) {
    navigateTo(
      context,
      TeacherTestReviewScreen(
        questionNumber: widget.questionNumber,
        testName: widget.testName,
        test: cubit.questionList,
        generalAddTeacherDataModel: widget.generalAddTeacherDataModel,
        groupId: widget.groupId,
      ),
    );
  }
}
