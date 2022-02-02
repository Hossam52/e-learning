class StudentDataModel {
  bool? status;
  String? message;
  Student? student;
  bool? authType;
  String? token;

  StudentDataModel({this.status, this.message, this.student, this.token, this.authType});

  StudentDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    student =
        json['student'] != null ? new Student.fromJson(json['student']) : null;
    authType = json['authType'];
    token = json['token'];
  }
}

class Student {
  int? id;
  String? name;
  String? code;
  String? email;
  String? country;
  String? classroom;
  String? image;
  String? points;

  Student({
    this.id,
    this.name,
    this.code,
    this.email,
    this.country,
    this.classroom,
    this.image,
    this.points,
  });

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    email = json['email'];
    country = json['country'];
    classroom = json['classroom'];
    image = json['image'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['email'] = this.email;
    data['country'] = this.country;
    data['classroom'] = this.classroom;
    data['image'] = this.image;
    return data;
  }
}
