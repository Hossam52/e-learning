import 'dart:convert';

import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';

class SocialRegisterResponse {
  bool status;
  String type;
  String? message;
  Student? student;
  Teacher? teacher;
  String? token;
  late SocialRegisterType registerType;
  SocialRegisterResponse({
    required this.status,
    required this.type,
    this.message,
    this.student,
    this.token,
    this.teacher,
  }) {
    switch (type) {
      case 'login':
        registerType = SocialRegisterType.Login;
        break;
      case 'register':
        registerType = SocialRegisterType.Register;
        break;
      default:
        registerType = SocialRegisterType.Login;
    }
  }

  factory SocialRegisterResponse.fromMap(Map<String, dynamic> map) {
    return SocialRegisterResponse(
        status: map['status'] ?? false,
        type: map['type'] ?? '',
        message: map['message'],
        student:
            map['student'] != null ? Student.fromJson(map['student']) : null,
        token: map['token'] ?? '',
        teacher:
            map['teacher'] != null ? Teacher.fromJson(map['teacher']) : null);
  }

  factory SocialRegisterResponse.fromJson(String source) =>
      SocialRegisterResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SocialRegisterResponse(status: $status, type: $type, message: $message, student: $student, teacher: $teacher, token: $token, registerType: $registerType)';
  }
}
