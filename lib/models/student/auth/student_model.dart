import 'dart:io';

class StudentModel {
  late String name;
  late String? email;
  String? password;
  String? passwordConfirmation;
  late int? countryId;
  late int? classroomId;
  File? avatar;

  StudentModel({
    required this.name,
    required this.email,
    this.password,
    this.passwordConfirmation,
    this.countryId,
    this.classroomId,
    this.avatar,
  });
}
