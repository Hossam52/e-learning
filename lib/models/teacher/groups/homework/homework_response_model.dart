import 'package:e_learning/models/teacher/test/test_response_model.dart';

class HomeworkResponseModel {
  bool? status;
  String? message;
  List<Test>? homework = [];

  HomeworkResponseModel({this.status, this.message, this.homework});

  HomeworkResponseModel.fromJson(Map<String, dynamic> json, bool isStudent) {
    status = json['status'];
    message = json['message'];
    if (json['homework'] != null) {
      json['homework'].forEach((v) {
        homework!.add(new Test.fromJson(v, !isStudent));
      });
    }
  }
}