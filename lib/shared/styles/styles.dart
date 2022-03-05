import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color iconColor = Colors.white;

TextStyle primaryTextStyle(DeviceInformation? deviceInfo) {
  return TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.w500, fontFamily: 'NeoSansArabic');
}

TextStyle secondaryTextStyle(DeviceInformation? deviceInfo) {
  return TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w500, fontFamily: 'NeoSansArabic');
}

TextStyle thirdTextStyle(DeviceInformation? deviceInfo) {
  return TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, fontFamily: 'NeoSansArabic');
}

TextStyle subTextStyle(DeviceInformation? deviceInfo) {
  return TextStyle(
    fontSize: 12.sp,
    color: Colors.grey,
    fontWeight: FontWeight.w500,
    fontFamily: 'NeoSansArabic',
  );
}

//decorations
final containerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(
      color: Colors.grey.shade300,
      width: 0.3,
    ));