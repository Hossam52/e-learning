import 'package:e_learning/models/student/auth/student_data_model.dart';

class StudentsListResponseModel {
  bool? status;
  String? message;
  List<Student>? students = [];

  StudentsListResponseModel({this.status, this.message, this.students});

  StudentsListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['students'] != null) {
      json['students'].forEach((v) {
        students!.add(new Student.fromJson(v));
      });
    }
  }
}

class StudentsListAuthorizedResponseModel {
  bool? status;
  String? message;
  List<Student>? students = [];

  StudentsListAuthorizedResponseModel(
      {this.status, this.message, this.students});

  StudentsListAuthorizedResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['students'] != null) {
      json['students']['data'].forEach((v) {
        students!.add(new Student.fromJson(v));
      });
    }
  }
}
