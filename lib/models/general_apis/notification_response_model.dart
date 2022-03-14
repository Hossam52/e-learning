import 'package:e_learning/models/pagination.dart';
import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/models/student/champions/champion_response_model.dart';
import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/models/teacher/videos/subject_playlists_data_model.dart';
import 'package:intl/intl.dart';

class NotificationResponseModel {
  bool? status;
  Notifications? notifications;

  NotificationResponseModel({this.status, this.notifications});

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    notifications = json['notifications'] != null
        ? new Notifications.fromJson(json['notifications'])
        : null;
  }
}

class Notifications {
  List<NotificationData>? data = [];
  Links? links;
  Meta? meta;

  Notifications({this.data, this.links, this.meta});

  Notifications.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }
}

class NotificationData {
  int? id;
  String? title;
  String? body;
  Student? studentSender;
  Teacher? teacherSender;
  bool? read;
  String? date;
  Post? post;
  // Comments? comment;
  VideosData? video;
  Champion? champion;

  NotificationData({
    this.id,
    this.title,
    this.body,
    this.studentSender,
    this.teacherSender,
    this.date,
    this.read,
    this.post,
    this.champion,
    this.video,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    date = DateFormat('yyyy-MM-dd').format(DateTime.parse(json['date']));
    studentSender = json['studentSender'] != null
        ? new Student.fromJson(json['studentSender'])
        : null;
    teacherSender = json['TecherSender'] == null
        ? null
        : Teacher.fromJson(json['TecherSender']);
    read = json['read'];
    post = json['post'] == null ? null : Post.fromJson(json['post']);
    champion =
        json['champion'] == null ? null : Champion.fromJson(json['champion']);
    video = json['video'] == null ? null : VideosData.fromJson(json['video']);
  }
}

class Sender {
  int? id;
  String? name;
  String? code;
  String? email;
  String? country;
  String? classroom;
  String? image;

  Sender(
      {this.id,
      this.name,
      this.code,
      this.email,
      this.country,
      this.classroom,
      this.image});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    email = json['email'];
    country = json['country'];
    classroom = json['classroom'];
    image = json['image'];
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
    return data;
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
