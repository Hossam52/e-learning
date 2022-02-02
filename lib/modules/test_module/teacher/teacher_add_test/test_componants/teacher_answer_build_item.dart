import 'dart:io';

import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

import '../question_add_image_button.dart';

class TeacherAnswerBuildItem extends StatelessWidget {
  TeacherAnswerBuildItem({
    Key? key,
    required this.controller,
    required this.borderColor,
    required this.hintText,
    required this.hasAnswer,
    required this.isCorrectAnswer,
    required this.onImageTap,
    required this.cubit,
    required this.index,
    this.onCheck,
    this.image,
  }) : super(key: key);

  final TextEditingController controller;
  final Color borderColor;
  final String hintText;
  final bool hasAnswer;
  final bool isCorrectAnswer;
  final TestCubit cubit;
  final int index;
  final Function()? onCheck;
  final File? image;
  final Function() onImageTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DefaultFormField(
                validation: (value) {
                  if (value == null || value.isEmpty) return 'هذا الحقل مطلوب';
                  return null;
                },
                controller: controller,
                hintText: hintText,
                haveBackground: true,
                borderColor: borderColor,
              ),
            ),
            if (hasAnswer == false || isCorrectAnswer)
              IconButton(
                onPressed: onCheck,
                icon: Icon(
                  Icons.check,
                  color: successColor,
                  size: 20,
                ),
              ),
          ],
        ),
        QuestionAddImageButton(
          onTap: onImageTap,
          cubit: cubit,
          image: image,
          index: index,
        ),
      ],
    );
  }
}
