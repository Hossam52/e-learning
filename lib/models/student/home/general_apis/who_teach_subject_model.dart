import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';

class WhoTeachSubjectModel {
  bool? status;
  List<Teacher>? teachers = [];

  WhoTeachSubjectModel({this.status, this.teachers});

  WhoTeachSubjectModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['teachers'] != null) {
      json['teachers'].forEach((v) {
        teachers!.add(new Teacher.fromJson(v));
      });
    }
  }
}