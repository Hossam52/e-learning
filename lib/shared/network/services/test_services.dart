import 'package:e_learning/models/student/home/general_apis/students_list_response_model.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';

class TestServices {
  static Future<StudentsListResponseModel> getAllMembers() async {
    final response = await DioHelper.getData(
      url: STUDENT_GET_ALL_INVITATIONS,
      token: studentToken,
    );
    return StudentsListResponseModel.fromJson(response.data);
  }
}
