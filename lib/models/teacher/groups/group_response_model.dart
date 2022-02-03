import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';

class GroupResponseModel {
  bool? status;
  String? message;
  List<Group>? groups = [];

  GroupResponseModel({this.status, this.message, this.groups});

  GroupResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['group'] != null) {
      json['group'].forEach((v) {
        groups!.add(new Group.fromJson(v));
      });
    }
  }
}

class Group {
  int? id;
  String? title;
  String? description;
  String? subject;
  String? stage;
  String? classroom;
  String? term;
  String? type;
  String? date;
  Teacher? teacher;
  bool? isJoined;
  int? studentCount;

  Group(
      {this.id,
      this.title,
      this.description,
      this.subject,
      this.stage,
      this.classroom,
      this.term,
      this.type,
      this.teacher,
      this.date,
      this.isJoined,
      this.studentCount});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    subject = json['subject'];
    stage = json['stage'];
    classroom = json['classroom'];
    term = json['term'];
    type = json['type'];
    date = json['date'];
    isJoined = json['authStJoin'];
    studentCount = json['studentCount'];
    if (json['teacher'] != null) {
      teacher = Teacher.fromJson(json['teacher']);
    }
  }
}
