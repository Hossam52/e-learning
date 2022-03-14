import 'dart:convert';

import 'package:e_learning/models/pagination.dart';

import '../teacher_profile_view/teacher_profile_questions.dart';

class AllPartecipationRecordsResponse {
  bool status;
  AllParticipations students;
  AllPartecipationRecordsResponse({
    required this.status,
    required this.students,
  });

  factory AllPartecipationRecordsResponse.fromMap(Map<String, dynamic> map) {
    return AllPartecipationRecordsResponse(
      status: map['status'] ?? false,
      students: AllParticipations.fromMap(map['students']),
    );
  }

  factory AllPartecipationRecordsResponse.fromJson(String source) =>
      AllPartecipationRecordsResponse.fromMap(json.decode(source));
}

class AllParticipations {
  Meta meta;
  Links links;
  List<PartecipationResult> data;
  AllParticipations({
    required this.meta,
    required this.links,
    required this.data,
  });

  factory AllParticipations.fromMap(Map<String, dynamic> map) {
    return AllParticipations(
      meta: Meta.fromJson(map['meta']),
      links: Links.fromJson(map['links']),
      data: List<PartecipationResult>.from(
          map['data']?.map((x) => PartecipationResult.fromMap(x))),
    );
  }

  factory AllParticipations.fromJson(String source) =>
      AllParticipations.fromMap(json.decode(source));
}

class PartecipationResult {
  String right_answer_num;
  String student;
  String student_image;
  String student_id;
  String date;
  PartecipationResult({
    required this.right_answer_num,
    required this.student,
    required this.student_image,
    required this.student_id,
    required this.date,
  });

  PartecipationResult copyWith({
    String? right_answer_num,
    String? student,
    String? student_image,
    String? student_id,
    String? date,
  }) {
    return PartecipationResult(
      right_answer_num: right_answer_num ?? this.right_answer_num,
      student: student ?? this.student,
      student_image: student_image ?? this.student_image,
      student_id: student_id ?? this.student_id,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'right_answer_num': right_answer_num,
      'student': student,
      'student_image': student_image,
      'student_id': student_id,
      'date': date,
    };
  }

  factory PartecipationResult.fromMap(Map<String, dynamic> map) {
    return PartecipationResult(
      right_answer_num: map['right_answer_num'] ?? '',
      student: map['student'] ?? '',
      student_image: map['student_image'] ?? '',
      student_id: map['student_id'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PartecipationResult.fromJson(String source) =>
      PartecipationResult.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PartecipationResult(right_answer_num: $right_answer_num, student: $student, student_image: $student_image, student_id: $student_id, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PartecipationResult &&
        other.right_answer_num == right_answer_num &&
        other.student == student &&
        other.student_image == student_image &&
        other.student_id == student_id &&
        other.date == date;
  }

  @override
  int get hashCode {
    return right_answer_num.hashCode ^
        student.hashCode ^
        student_image.hashCode ^
        student_id.hashCode ^
        date.hashCode;
  }
}
