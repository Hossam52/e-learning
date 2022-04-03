import 'dart:developer';

import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/profile/student/profile_screen.dart';
import 'package:e_learning/modules/profile/student_profile_view.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SharedMethods {
  static Future<void> navigateToProfile(bool isStudent, bool displayProfile,
      BuildContext context, int profileId) async {
    final myProfileId = getMyProfileId(context: context, isStudent: isStudent);
    if (profileId == myProfileId)
      navigateTo(context, isStudent ? ProfileScreen() : TeacherProfileScreen());
    else {
      if (!displayProfile) return;

      navigateTo(
          context,
          StudentProfileView(
            isFriend: true,
            // student: student,
            id: profileId,
          ));
    }
  }

  static int? getMyProfileId(
      {required bool isStudent, required BuildContext context}) {
    if (isStudent) {
      return AuthCubit.get(context).studentProfileModel!.student!.id;
    } else
      return AuthCubit.get(context).teacherProfileModel!.teacher!.id;
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
