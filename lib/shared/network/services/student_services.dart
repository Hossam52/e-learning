import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_learning/models/student/group/group_student_response_model.dart';
import 'package:e_learning/models/student/rate_teacher/rate_teacher.dart';
import 'package:e_learning/models/student/search/search_model.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';

import '../end_points.dart';

class StudentServices {
  static Future<SearchModel> searchStudent(String value) async {
    final response = await DioHelper.postFormData(
      url: STUDENT_SEARCH,
      token: studentToken,
      formData: FormData.fromMap({
        'text': value,
      }),
    );
    return SearchModel.fromJson(response.data);
  }

  static Future<RateTeacherModel> rateTeacher(
      double rate, int teacherId) async {
    final response = await DioHelper.postFormData(
      url: RATE_TEACHER,
      token: studentToken,
      formData: FormData.fromMap({
        'stars': rate,
        'teacher_id': teacherId,
      }),
    );
    log(response.data.toString());
    return RateTeacherModel.fromMap(response.data);
  }

  static Future<GroupsStudentResponse> filterInGroup([int? subjectId]) async {
    final response = await DioHelper.postFormData(
      url: STUDENT_FILTER_IN_GROUPS,
      token: studentToken,
      formData: FormData.fromMap({'subject_id': subjectId}),
    );
    log(response.data.toString());
    if (!response.data['status']) {
      throw '${response.data['message']}';
    }
    return GroupsStudentResponse.fromJson(response.data);
  }
}
