import 'dart:io';

import 'package:e_learning/models/teacher/test/test_model.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherQuestionReviewBuild extends StatelessWidget {
  TeacherQuestionReviewBuild({
    Key? key,
    required this.questionNumber,
    required this.question,
    this.questionImage,
    required this.chooseList,
    required this.correctAnswerIndex,
    required this.isEdit,
    this.onEdit,
  }) : super(key: key);

  final String questionNumber;
  final String question;
  final File? questionImage;
  final List<Choose> chooseList;
  final int correctAnswerIndex;
  final bool isEdit;
  final Function()? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: ExpansionTile(
        title: Text(questionNumber),
        leading: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: primaryColor,
                radius: 5,
              ),
            ],
          ),
        ),
        trailing: isEdit
            ? IconButton(
                icon: Icon(Icons.edit, size: 20),
                onPressed: onEdit,
              )
            : null,
        childrenPadding: EdgeInsets.symmetric(vertical: 17.h),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style:
                secondaryTextStyle(null).copyWith(fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 8.h),
          if (questionImage != null)
            Image.file(
              questionImage!,
            ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 1.5,
          ),
          SizedBox(height: 8.h),
          ListView.separated(
            itemCount: chooseList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chooseList[index].chooseText!,
                  style: secondaryTextStyle(null).copyWith(
                    color: correctAnswerIndex == index ? successColor : null,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                if (chooseList[index].chooseImage != null)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: correctAnswerIndex == index
                              ? successColor
                              : Colors.transparent),
                    ),
                    child: Image.file(
                      chooseList[index].chooseImage!,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
