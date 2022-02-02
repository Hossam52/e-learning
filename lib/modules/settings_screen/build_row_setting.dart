import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';

Row buildRowSetting(
    {required String title,
    required Widget child,
    required DeviceInformation deviceInfo}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          title,
          style: thirdTextStyle(deviceInfo).copyWith(
            color: Colors.black87,
          ),
        ),
      ),
      child,
    ],
  );
}