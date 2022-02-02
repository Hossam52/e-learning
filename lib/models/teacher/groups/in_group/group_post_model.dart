import 'dart:io';

class GroupPostModel {
  late String text;
  List<File>? images = [];
  late int groupId;
  late String type;
  int? postId;
  int? teacherId;

  GroupPostModel({
    required this.text,
    required this.images,
    required this.groupId,
    required this.type,
    this.postId,
    this.teacherId,
  });
}
