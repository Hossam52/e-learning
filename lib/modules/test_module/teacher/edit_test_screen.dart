import 'package:e_learning/models/teacher/general_teacher_add_data_model.dart';
import 'package:e_learning/models/teacher/test/test_model.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/modules/test_module/cubit/states.dart';
import 'package:e_learning/modules/test_module/teacher/teacher_add_test/test_componants/teacher_question_card_build_item.dart';
import 'package:e_learning/modules/test_module/teacher/teacher_add_test/test_componants/test_stepper_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTestScreen extends StatefulWidget {
  const EditTestScreen({
    Key? key,
    required this.questionNumber,
    required this.currentIndex,
    required this.questionDataModel,
    required this.testName,
    required this.generalAddTeacherDataModel,
  }) : super(key: key);

  final int questionNumber;
  final String testName;
  final GeneralAddTeacherDataModel generalAddTeacherDataModel;
  final int currentIndex;
  final QuestionDataModel questionDataModel;

  @override
  _EditTestScreenState createState() => _EditTestScreenState();
}

class _EditTestScreenState extends State<EditTestScreen> {
  final TextEditingController questionController = TextEditingController();

  final List<TextEditingController> chooseControllerList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    TestCubit cubit = TestCubit.get(context);
    questionController.text = widget.questionDataModel.questionText;
    cubit.questionImage = widget.questionDataModel.questionImage;
    for(int index = 0; index < 4; index++) {
      if(widget.questionDataModel.chooseList!.asMap().containsKey(index)) {
        cubit.answerImages[index] = widget.questionDataModel.chooseList![index].chooseImage;
      }
    }
    cubit.hasAnswer = true;
    cubit.correctAnswerIndex = widget.questionDataModel.answerIndex;
    cubit.answerNumber = widget.questionDataModel.chooseList!.length;
    for (int index = 0;
        index < widget.questionDataModel.chooseList!.length;
        index++) {
      chooseControllerList[index].text =
          widget.questionDataModel.chooseList![index].chooseText!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) => DefaultGestureWidget(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("تعديل الاختبار"),
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
                          TestStepperBuildItem(
                            questionNumber: widget.questionNumber,
                            currentIndex: widget.currentIndex,
                          ),
                          TeacherQuestionCardBuildItem(
                            cubit: cubit,
                            index: widget.currentIndex,
                            questionController: questionController,
                            chooseControllerList: chooseControllerList,
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
                              text: 'عودة',
                              isLoading: false,
                              textStyle: thirdTextStyle(deviceInfo),
                              isDisabled: false,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              background: Colors.transparent,
                              border: primaryColor,
                              textColor: primaryColor,
                            ),
                          ),
                          SizedBox(width: 35),
                          Expanded(
                            child: DefaultAppButton(
                              text: 'تعديل',
                              isLoading: false,
                              textStyle: thirdTextStyle(deviceInfo),
                              isDisabled: false,
                              onPressed: () {
                                formKey.currentState!.save();
                                if (formKey.currentState!.validate()) {
                                  if (cubit.hasAnswer) {
                                    cubit.addQuestion(
                                      isEdit: true,
                                      questionText: questionController.text,
                                      answerIndex: cubit.correctAnswerIndex!,
                                      currentIndex: widget.currentIndex,
                                      chooseList: List.generate(
                                          cubit.answerNumber, (index) => Choose(
                                                chooseText:
                                                    chooseControllerList[index].text,
                                                chooseImage: cubit.answerImages[index],
                                              )),
                                    );
                                    Navigator.of(context).pop('update');
                                  } else {
                                    showToast(
                                        msg: 'اختر الاجابة الصحيحة',
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
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    chooseControllerList.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }
}
