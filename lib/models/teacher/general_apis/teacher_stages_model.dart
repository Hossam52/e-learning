class TeacherStagesModel {
  bool? status;
  List<Student>? student = [];

  TeacherStagesModel({this.status, this.student});

  TeacherStagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['student'] != null) {
      json['student'].forEach((v) {
        student!.add(new Student.fromJson(v));
      });
    }
  }
}

class Student {
  int? id;
  String? name;
  String? createdAt;
  List<Classrooms>? classrooms = [];

  Student({this.id, this.name, this.createdAt, this.classrooms});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    if (json['classrooms'] != null) {
      json['classrooms'].forEach((v) {
        classrooms!.add(new Classrooms.fromJson(v));
      });
    }
  }
}

class Classrooms {
  int? id;
  String? name;
  String? createdAt;

  Classrooms({this.id, this.name, this.createdAt});

  Classrooms.fromJson(Map<String, dynamic> json) {
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