import 'dart:convert';

import 'package:e_learning/models/general_apis/notification_response_model.dart';
import 'package:e_learning/models/pagination.dart';

class AllPostsModel {
  bool? status;
  String? message;
  List<Post>? posts;
  Meta? meta;
  Links? links;
  AllPostsModel({
    this.status,
    this.message,
    this.posts,
    this.meta,
    this.links,
  });
  factory AllPostsModel.fromMap(Map<String, dynamic> map) {
    return AllPostsModel(
      status: map['status'],
      message: map['message'],
      posts: map['posts'] != null
          ? List<Post>.from(map['posts']['data']?.map((x) => Post.fromJson(x)))
          : null,
      meta: map['posts']['meta'] != null
          ? Meta.fromJson(map['posts']['meta'])
          : null,
      links: map['posts']['links'] != null
          ? Links.fromJson(map['posts']['links'])
          : null,
    );
  }
}

class PostResponseModel {
  bool? status;
  String? message;
  Post? post;

  PostResponseModel({this.status, this.message, this.post});

  PostResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
  }
}

class Post {
  int? id;
  String? text;
  String? teacher;
  String? student;
  String? teacherImage;
  String? studentImage;
  bool? adminPost;
  bool? studentPost;
  bool? teacherPost;
  bool? answer;
  int? likesNum;
  bool? authLikeTeacher;
  bool? authLikeStudent;
  String? date;
  int? studentId;
  int? teacherId;
  List<Comments>? comments = [];
  List<String>? images = [];

  Post({
    this.id,
    this.text,
    this.images,
    this.teacher,
    this.student,
    this.teacherImage,
    this.studentImage,
    this.adminPost,
    this.studentPost,
    this.teacherPost,
    this.answer,
    this.likesNum,
    this.authLikeTeacher,
    this.authLikeStudent,
    this.studentId,
    this.teacherId,
    this.date,
    this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      text: json['text'],
      images: json['images'] != null ? json['images'].cast<String>() : [],
      teacher: json['teacher'],
      student: json['student'],
      teacherImage: json['teacher_image'],
      studentImage: json['student_image'],
      studentId: json['student_id'],
      teacherId: json['teacher_id'],
      adminPost: json['adminPost'],
      studentPost: json['studentPost'] ?? false,
      teacherPost: json['teacherPost'] ?? false,
      answer: json['answer'],
      likesNum: json['likes_num'],
      authLikeTeacher: json['authLikeTeacher'],
      authLikeStudent: json['authLikeStudent'],
      date: json['date'],
      comments: json['comments'] == null
          ? []
          : List<Comments>.from(
              json['comments']?.map((x) => Comments.fromJson(x))),

      //  json['comments']
      //     .forEach((v) => comments!.add(new Comments.fromJson(v))),
    );
  }

  Post.fromJsonString(String source) {
    Post.fromJson(json.decode(source));
  }

  @override
  String toString() {
    return 'Post(id: $id, text: $text, teacher: $teacher, student: $student, teacherImage: $teacherImage, studentImage: $studentImage, adminPost: $adminPost, studentPost: $studentPost, teacherPost: $teacherPost, answer: $answer, likesNum: $likesNum, authLikeTeacher: $authLikeTeacher, authLikeStudent: $authLikeStudent, date: $date, studentId: $studentId, teacherId: $teacherId, comments: $comments, images: $images)';
  }
}

class Comments {
  int? id;
  String? text;
  String? images;
  String? teacher;
  String? student;
  String? code;
  bool? adminComment;
  String? teacherImage;
  String? studentImage;
  bool? studentComment;
  bool? teacherComment;
  String? date;

  Comments({
    this.id,
    this.text,
    this.images,
    this.teacher,
    this.student,
    this.code,
    this.adminComment,
    this.teacherImage,
    this.studentImage,
    this.studentComment,
    this.teacherComment,
    this.date,
  });

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    images = json['images'];
    teacher = json['teacher'];
    student = json['student'];
    code = json['code'];
    adminComment = json['adminComment'];
    teacherImage = json['teacher_image'];
    studentImage = json['student_image'];
    studentComment = json['studentComment'];
    teacherComment = json['teacherComment'];
    date = json['date'];
  }
}
