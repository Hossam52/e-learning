import 'package:e_learning/models/pagination.dart';
import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';

class TeachersResponseModel {
  bool? status;
  Teachers? teachers;

  TeachersResponseModel({this.status, this.teachers});

  TeachersResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    teachers = json['teachers'] != null
        ? new Teachers.fromJson(json['teachers'])
        : null;
  }
}

class Teachers {
  List<Teacher>? data = [];
  Links? links;
  Meta? meta;

  Teachers({this.data, this.links, this.meta});

  Teachers.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(new Teacher.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }
}

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}
