class FilePostDataModel {
  bool? status;
  String? message;
  Test? test;

  FilePostDataModel({this.status, this.message, this.test});

  FilePostDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    test = json['teacher'] != null ? new Test.fromJson(json['teacher']) : null;
  }
}

class Test {
  int? id;
  String? name;
  String? subject;
  String? stage;
  String? classroom;
  String? term;
  String? fileId;
  String? type;

  Test(
      {this.id,
        this.name,
        this.subject,
        this.stage,
        this.classroom,
        this.term,
        this.fileId,
        this.type});

  Test.fromJson(Map<String, dynamic> json) {
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