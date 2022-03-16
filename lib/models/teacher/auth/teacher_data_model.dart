class TeacherDataModel {
  bool? status;
  String? message;
  Teacher? teacher;
  String? token;

  TeacherDataModel({this.status, this.message, this.teacher, this.token});

  TeacherDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    teacher =
        json['teacher'] != null ? new Teacher.fromJson(json['teacher']) : null;
    token = json['token'];
  }
}

class Teacher {
  int? id;
  String? name;
  String? email;
  String? country;
  List<Subjects>? subjects = [];
  String? image;
  bool? authStudentFollow;
  int? authStudentRate;
  double? myRate;
  int? followersCount;
  String? socialId;
  bool? authType;

  Teacher({
    this.id,
    this.name,
    this.email,
    this.country,
    this.subjects,
    this.image,
    this.authStudentFollow,
    this.authStudentRate,
    this.myRate,
    this.authType,
    this.followersCount,
    this.socialId,
  });

  Teacher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    country = json['country'];
    if (json['subjects'] != null) {
      json['subjects'].forEach((v) {
        subjects!.add(new Subjects.fromJson(v));
      });
    }
    image = json['image'];
    authStudentFollow = json['AuthStudentFollow'] ?? false;
    authStudentRate = json['AuthStudentRate'] ?? false;
    myRate = double.tryParse(json['myrate'].toString()) ?? 0;
    followersCount = json['followers_num'] ?? 0;
    authType = json['authType'];
    socialId = json['social_id'];
  }
}

class Subjects {
  int? id;
  String? name;

  Subjects({this.id, this.name});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
