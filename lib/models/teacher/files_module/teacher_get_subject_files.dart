class TeacherGetSubjectFilesModel {
  bool? status;
  String? message;
  List<Files>? files = [];

  TeacherGetSubjectFilesModel({this.status, this.message, this.files});

  TeacherGetSubjectFilesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['files'] != null) {
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
  }
}

class Files {
  int? id;
  String? name;
  String? subject;
  String? stage;
  String? classroom;
  String? term;
  String? fileId;
  String? type;

  Files(
      {this.id,
        this.name,
        this.subject,
        this.stage,
        this.classroom,
        this.term,
        this.fileId,
        this.type});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subject = json['subject'];
    stage = json['stage'];
    classroom = json['classroom'];
    term = json['term'];
    fileId = json['file_id'];
    type = json['type'];
  }
}