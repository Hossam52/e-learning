class PlaylistDataModel {
  bool? status;
  String? message;
  PlaylistVideos? playlist;

  PlaylistDataModel({this.status, this.message, this.playlist});

  PlaylistDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    playlist = json['playlist'] != null
        ? new PlaylistVideos.fromJson(json['playlist'])
        : null;
  }
}

class Playlist {
  int? id;
  String? name;
  String? stage;
  String? subject;
  String? classroom;
  String? term;
  String? viedoNum;
  List<PlaylistVideos>? playlist = [];

  Playlist(
      {this.id,
        this.name,
        this.stage,
        this.subject,
        this.classroom,
        this.term,
        this.viedoNum,
        this.playlist});

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stage = json['stage'];
    subject = json['subject'];
    classroom = json['classroom'];
    term = json['term'];
    viedoNum = json['viedo_num'];
    if (json['playlist'] != null) {
      json['playlist'].forEach((v) {
        playlist!.add(new PlaylistVideos.fromJson(v));
      });
    }
  }
}

class PlaylistVideos {
  int? id;
  String? videoName;
  String? videoId;
  String? playlistId;
  String? createdAt;
  String? updatedAt;

  PlaylistVideos(
      {this.id,
        this.videoName,
        this.videoId,
        this.playlistId,
        this.createdAt,
        this.updatedAt});

  PlaylistVideos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoName = json['video_name'];
    videoId = json['video_id'];
    playlistId = json['playlist_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}