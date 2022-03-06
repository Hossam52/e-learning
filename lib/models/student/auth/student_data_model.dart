import 'package:e_learning/models/enums/enums.dart';

class StudentDataModel {
  bool? status;
  String? message;
  Student? student;
  bool? authType;
  String? token;

  StudentDataModel(
      {this.status, this.message, this.student, this.token, this.authType});

  StudentDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    student =
        json['student'] != null ? new Student.fromJson(json['student']) : null;
    authType = json['authType'];
    token = json['token'];
  }
}

class Student {
  int? id;
  String? name;
  String? code;
  String? email;
  String? country;
  String? classroom;
  String? image;
  String? points;
  bool? authType;
  int? friend;
  late FriendType friendType;

  Student({
    this.id,
    this.name,
    this.code,
    this.email,
    this.country,
    this.classroom,
    this.image,
    this.points,
    this.authType,
    this.friend,
  }) {
    switch (friend) {
      case 0:
        friendType = FriendType.NotFriend;
        break;
      case 1:
        friendType = FriendType.Friend;
        break;
      case 2:
        friendType = FriendType.Pending;
        break;
      default:
        friendType = FriendType.Unknown;
    }
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        email: json['email'],
        country: json['country'],
        classroom: json['classroom'],
        image: json['image'],
        points: json['points'].toString(),
        authType: json['authType'],
        friend: json['friend']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['email'] = this.email;
    data['country'] = this.country;
    data['classroom'] = this.classroom;
    data['image'] = this.image;
    data['authType'] = this.authType;
    data['friend'] = this.friend;
    return data;
  }
}
