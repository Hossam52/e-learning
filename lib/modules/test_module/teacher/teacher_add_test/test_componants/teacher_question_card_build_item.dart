import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/modules/test_module/teacher/teacher_add_test/test_componants/teacher_answer_build_item.dart';
import 'package:e_learning/modules/test_module/teacher/teacher_add_test/test_componants/test_image_remove_button.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherQuestionCardBuildItem extends StatelessWidget {
  const TeacherQuestionCardBuildItem({
    Key? key,
    required this.cubit,
    required this.index,
    required this.questionController,
    required this.chooseControllerList,
  }) : super(key: key);

  final TestCubit cubit;
  final int index;
  final TextEditingController questionController;
  final List<TextEditingController> chooseControllerList;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.only(top: 50, bottom: 2, left: 22, right: 22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Row(
                children: [
                  Expanded(
                    child: DefaultFormField(
                      validation: (value) {
                        if (value == null || value.isEmpty)
                          return context.tr.this_field_is_required;
                        return null;
                      },
                      controller: questionController,
                      labelText: context.tr.add_question,
                      hintText: context.tr.add_question,
                      haveBackground: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: IconButton(
                      onPressed: () async {
                        await alertDialogImagePicker(
                          context: context,
                          cubit: cubit,
                          onTap: () => cubit.addImageDataMethod(true, null),
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
                    cubit.removeImageDataMethod(true, index);
                  },
                  image: Image.file(
                    cubit.questionImage!,
                    width: MediaQuery.of(context).size.width * 0.65,
                  ),
                ),
              SizedBox(height: 20.h),
              ListView.separated(
                itemCount: cubit.answerNumber,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 15.h),
                itemBuilder: (context, index) => TeacherAnswerBuildItem(
                  key: ValueKey(index),
                  cubit: cubit,
                  index: index,
                  borderColor: cubit.correctAnswerIndex == index
                      ? successColor
                      : Colors.grey,
                  controller: chooseControllerList[index],
                  hintText: context.tr.answer,
                  hasAnswer: cubit.hasAnswer,
                  image: cubit.answerImages.asMap().containsKey(index)
                      ? cubit.answerImages[index]
                      : null,
                  onImageTap: () async {
                    await alertDialogImagePicker(
                      context: context,
                      cubit: cubit,
                      onTap: () => cubit.addImageDataMethod(false, index),
                    );
                  },
                  isCorrectAnswer:
                      cubit.correctAnswerIndex == index ? true : false,
                  onCheck: () {
                    cubit.onChangeCorrectAnswer(index);
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
    );
  }
}
