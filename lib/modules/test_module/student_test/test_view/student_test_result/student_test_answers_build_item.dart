import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentAnswersBuildItem extends StatelessWidget {
  const StudentAnswersBuildItem({Key? key,
    required this.deviceInfo,
    required this.question,
    required this.wrongAnswer,
    required this.rightAnswer,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final String question;
  final String wrongAnswer;
  final String rightAnswer;

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
            offset: Offset(0,4), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: ExpansionTile(
        title: Text(question),
        subtitle: Text(
          wrongAnswer,
          style: thirdTextStyle(deviceInfo).copyWith(
            color: errorColor,
          ),
        ),
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
                  style: secondaryTextStyle(deviceInfo).copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 8.h),
                Text(
                  rightAnswer,
                  style: secondaryTextStyle(deviceInfo).copyWith(
                    color: successColor,
                    fontWeight: FontWeight.w400,
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
