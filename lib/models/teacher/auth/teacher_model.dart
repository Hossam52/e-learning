import 'dart:io';

class TeacherModel {
  String? name;
  String? email;
  String? password;
  String? passwordConfirmation;
  int? countryId;
  List<int>? subjects;
  File? avatar;

  TeacherModel({
    required this.name,
    required this.email,
    this.password,
    this.passwordConfirmation,
    required this.countryId,
    required this.subjects,
    this.avatar,
  });
}
