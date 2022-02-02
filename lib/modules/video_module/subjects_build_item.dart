import 'dart:math';

import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';

class SubjectsBuildItem extends StatelessWidget {
  const SubjectsBuildItem({Key? key,
    required this.deviceInfo,
    required this.title,
    required this.onPressed}) : super(key: key);

  final DeviceInformation deviceInfo;
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(Random().nextInt(0xffffffff).toInt())
          .withAlpha(0xff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Text(
          title,
          style: secondaryTextStyle(deviceInfo).copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
