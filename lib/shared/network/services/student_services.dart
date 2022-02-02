import 'package:dio/dio.dart';
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
        'text' : value,
      }),
    );
    return SearchModel.fromJson(response.data);
  }
}