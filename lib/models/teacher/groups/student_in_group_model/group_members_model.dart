class StudentInGroupModel {
  bool? status;
  String? message;
  List<Students>? students = [];

  StudentInGroupModel({this.status, this.message, this.students});

  StudentInGroupModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['students'] != null) {
      json['students'].forEach((v) {
        students!.add(new Students.fromJson(v));
      });
    }
  }
}

class Students {
  int? id;
  String? name;
  String? code;
  String? email;
  String? country;
  String? classroom;
  String? image;

  Students(
      {this.id,
        this.name,
        this.code,
        this.email,
        this.country,
        this.classroom,
        this.image});

  Students.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    email = json['email'];
    country = json['country'];
    classroom = json['classroom'];
    image = json['image'];
  }
}
