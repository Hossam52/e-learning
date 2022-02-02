import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';

class SubjectPlaylistsDataModel {
  bool? status;
  String? message;
  List<Playlist>? playlist = [];

  SubjectPlaylistsDataModel({this.status, this.message, this.playlist});

  SubjectPlaylistsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['playlists'] != null) {
      json['playlists'].forEach((v) {
        playlist!.add(new Playlist.fromJson(v));
      });
    }
  }
}

class Playlist {
  int? id;
  String? name;
  String? stage;
  String? subject;
  String? classroom;
  String? term;
  String? videoNum;
  List<VideosData>? videos = [];

  Playlist(
      {this.id,
      this.name,
      this.stage,
      this.subject,
      this.classroom,
      this.term,
      this.videoNum,
      this.videos});

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stage = json['stage'];
    subject = json['subject'];
    classroom = json['classroom'];
    term = json['term'];
    videoNum = json['viedo_num'];
    if (json['playlist'] != null) {
      json['playlist'].forEach((v) {
        videos!.add(new VideosData.fromJson(v));
      });
    }
  }
}

class VideosData {
  int? id;
  String? videoName;
  String? videoId;
  String? createdAt;
  int? likesCount;
  bool? authLikeTeacher;
  bool? authLikeStudent;
  List<Comments>? comments = [];

  VideosData({
    this.id,
    this.videoName,
    this.videoId,
    this.createdAt,
    this.likesCount,
    this.authLikeTeacher,
    this.authLikeStudent,
    this.comments,
  });

  VideosData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoName = json['video_name'];
    videoId = json['video_id'];
    createdAt = json['created_at'];
    likesCount = json['likes_num'];
    authLikeTeacher = json['authLikeTeacher'];
    authLikeStudent = json['authLikeStudent'];
    if (json['comments'] != null) {
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }
}
