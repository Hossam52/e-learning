class SubjectsDataModel {
  dynamic status;
  List<Subjects>? subjects = [];

  SubjectsDataModel({this.status, this.subjects});

  SubjectsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['subjects'] != null) {
      json['subjects'].forEach((v) {
        subjects!.add(new Subjects.fromJson(v));
      });
    }
  }
}

class Subjects {
  int? id;
  String? name;
  String? createdAt;

  Subjects({this.id, this.name, this.createdAt});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    return data;
  }
}