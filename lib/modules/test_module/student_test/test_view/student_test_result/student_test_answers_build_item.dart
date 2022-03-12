import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentAnswersBuildItem extends StatelessWidget {
  const StudentAnswersBuildItem({
    Key? key,
    required this.deviceInfo,
    required this.question,
    required this.wrongAnswer,
    required this.rightAnswer,
    required this.questionNumber,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final String question;
  final String wrongAnswer;
  final String rightAnswer;
  final int questionNumber;

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
        title: Text('${context.tr.questions_num} $questionNumber'),
        subtitle: _buildRowAnswer(
            '${context.tr.your_answer_is} :', wrongAnswer, errorColor),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 5,
            ),
          ],
        ),
        childrenPadding: EdgeInsets.symmetric(vertical: 17.h),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: secondaryTextStyle(deviceInfo)
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 8.h),
                _buildRowAnswer(
                    '${context.tr.your_answer_is} :', wrongAnswer, errorColor),
                SizedBox(height: 8.h),
                _buildRowAnswer('${context.tr.right_answer_is} :', rightAnswer,
                    successColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowAnswer(String header, String value, Color color) {
    return Row(
      children: [
        Text(
          header,
          style: secondaryTextStyle(null).copyWith(color: Colors.black),
        ),
        Center(
          child: Text(
            value,
            style: secondaryTextStyle(deviceInfo).copyWith(
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
