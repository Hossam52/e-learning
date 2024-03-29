import 'package:e_learning/models/pagination.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';

class TeacherProfileQuestions {
  bool? status;
  String? message;
  Posts? posts;

  TeacherProfileQuestions({this.status, this.message, this.posts});

  TeacherProfileQuestions.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    posts = json['posts'] != null ? new Posts.fromJson(json['posts']) : null;
  }
}

class Posts {
  List<Post>? postsData = [];
  Links? links;
  Meta? meta;

  Posts({this.postsData, this.links, this.meta});

  Posts.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        postsData!.add(new Post.fromJson(v));
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
}
