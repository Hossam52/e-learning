import 'package:e_learning/models/pagination.dart';
import 'package:e_learning/models/teacher/videos/subject_playlists_data_model.dart';

class GroupVideosResponseModel {
  bool? status;
  String? message;
  Videos? videos;

  GroupVideosResponseModel({this.status, this.message, this.videos});

  GroupVideosResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    videos =
        json['videos'] != null ? new Videos.fromJson(json['videos']) : null;
  }
}

class Videos {
  List<VideosData>? data = [];
  Links? links;
  Meta? meta;

  Videos({this.data, this.links, this.meta});

  Videos.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(new VideosData.fromJson(v));
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
