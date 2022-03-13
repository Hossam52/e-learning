import 'package:e_learning/models/pagination.dart';
import 'package:e_learning/models/student/auth/student_data_model.dart';

class FriendsResponseModel {
  bool? status;
  Friends? friends;

  FriendsResponseModel({this.status, this.friends});

  FriendsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    friends =
        json['friends'] != null ? new Friends.fromJson(json['friends']) : null;
  }
}

class Friends {
  List<Student>? friendsData = [];
  Links? links;
  Meta? meta;

  Friends({this.friendsData, this.links, this.meta});

  Friends.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        friendsData!.add(new Student.fromJson(v));
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
