import 'package:e_learning/models/teacher/test/test_response_model.dart';

class SubjectsDataModel {
  dynamic status;
  List<Subjects>? subjects = [];

  SubjectsDataModel({this.status, this.subjects});

  SubjectsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['subjects'] != null) {
      json['subjects'].forEach((v) {
        subjects!.add(new Subjects.fromJson(v));
      });
    }
  }
}

class Subjects {
  int? id;
  String? name;
  String? createdAt;
  List<Test>? tests;

  Subjects({this.id, this.name, this.createdAt, this.tests});
  void setTests(List<Test> tests) {
    this.tests = List<Test>.from(tests);
  }

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    return data;
  }
}
