import 'dart:io';

class TeacherModel {
  late String name;
  late String email;
  String? password;
  String? passwordConfirmation;
  late int countryId;
  late List<int> subjects;
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