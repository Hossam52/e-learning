import 'dart:convert';

import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';

class RecievedNotificationModel {
  String body;
  String title;
  int type;
  Post? post;
  RecievedNotificationModel({
    required this.body,
    required this.title,
    required this.type,
    this.post,
  });

  factory RecievedNotificationModel.fromMap(Map<String, dynamic> map) {
    return RecievedNotificationModel(
      body: map['body'] ?? '',
      title: map['title'] ?? '',
      type: json.decode(map['type']) as int,
      post:
          map['post'] != null ? Post.fromJson(json.decode(map['post'])) : null,
    );
  }

  factory RecievedNotificationModel.fromJson(String source) =>
      RecievedNotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RecievedNotificationModel(body: $body, title: $title, type: $type, post: $post)';
  }
}
