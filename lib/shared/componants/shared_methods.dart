import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/following_list/teacher_view/teacher_profile_view.dart';
import 'package:e_learning/modules/profile/student/profile_screen.dart';
import 'package:e_learning/modules/profile/student_profile_view.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_screen.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SharedMethods {
  static Future<void> navigateToProfile(bool isCurrentLoggedInIsStudent,
      bool isStudentItem, BuildContext context, int profileId) async {
    final myProfileId = getMyProfileId(
        context: context,
        isCurrentLoggedInIsStudent: isCurrentLoggedInIsStudent);
    if (profileId == myProfileId && isCurrentLoggedInIsStudent == isStudentItem)
      navigateTo(
          context,
          isCurrentLoggedInIsStudent
              ? ProfileScreen()
              : TeacherProfileScreen());
    else {
      if (isCurrentLoggedInIsStudent) {
        if (isStudentItem) {
          navigateTo(
            context,
            StudentProfileView(
              id: profileId,
            ),
          );
        } else {
          navigateTo(
              context,
              TeacherProfileView(
                // teacher: teacher,
                teacherId: profileId, isAdd: false,
                cubit: StudentCubit.get(context),
              ));
        }
      } else {
        if (isStudentItem)
          navigateTo(
            context,
            StudentProfileView(
              isTeacher: true,
              id: profileId,
            ),
          );
      }
    }
  }

  static int? getMyProfileId(
      {required bool isCurrentLoggedInIsStudent,
      required BuildContext context}) {
    if (isCurrentLoggedInIsStudent) {
      return AuthCubit.get(context).studentProfileModel!.student!.id;
    } else
      return AuthCubit.get(context).teacherProfileModel!.teacher!.id;
  }

  static Future<String> get getDeviceSerial async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    log('Serial number is ${androidInfo.androidId}');
    return androidInfo.androidId!;
  }

  static String? defaultValidation(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'this field is required';
    } else {
      return null;
    }
  }

  static String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "برجاء إدخال عنوان البريد الإلكتروني الخاص بك";
    } else {
      return RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)
          ? null
          : 'برجاء تحقق من بريدك الالكتروني';
    }
  }

  static String? defaultCheckboxValidation(bool? value, {String? message}) {
    if (value == false) {
      return message ?? 'this field is required';
    } else {
      return null;
    }
  }

  static void unFocusTextField(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static Future<String> getToken() async {
    return (await FirebaseMessaging.instance.getToken())!;
  }
}
