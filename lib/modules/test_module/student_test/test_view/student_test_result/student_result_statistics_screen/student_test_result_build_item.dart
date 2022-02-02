import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';

class StudentTestResultBuildItem extends StatelessWidget {
  const StudentTestResultBuildItem({
    Key? key,
    required this.deviceInfo,
    required this.icon,
    required this.color,
    required this.title,
    required this.result,
    this.textColor = Colors.black,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final Widget icon;
  final Color color;
  final String title;
  final String result;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: icon),
            ),
            VerticalDivider(
              thickness: 1,
              color: primaryColor,
            ),
            SizedBox(width: deviceInfo.screenwidth * 0.04),
            Text(
              title,
              style: thirdTextStyle(deviceInfo).copyWith(color: textColor),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Text(
                result,
                style: thirdTextStyle(deviceInfo).copyWith(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
