import 'package:e_learning/models/student/group/group_student_response_model.dart';
import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';

class SearchModel {
  bool? status;
  String? message;
  Groups? groups;
  List<Teacher>? teachers = [];

  SearchModel({
    this.status,
    this.message,
    this.groups,
    this.teachers,
  });

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    groups =
        json['groups'] != null ? new Groups.fromJson(json['groups']) : null;
    if (json['teachers'] != null) {
      json['teachers'].forEach((v) {
        teachers!.add(new Teacher.fromJson(v));
      });
    }
  }
}
