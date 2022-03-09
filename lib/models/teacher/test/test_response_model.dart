import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';

class TestResponseModel {
  bool? status;
  String? message;
  Test? test;

  TestResponseModel({this.status, this.message, this.test});

  TestResponseModel.fromJson(Map<String, dynamic> json, bool isTeacher) {
    status = json['status'];
    message = json['message'];
    test = json['test'] != null
        ? new Test.fromJson(json['test'], isTeacher)
        : null;
  }
}

class Test {
  int? id;
  String? name;
  String? subject;
  String? stage;
  String? classroom;
  String? term;
  String? minuteNum;
  dynamic groupId;
  Teacher? teacher;
  String? result;
  List<Result>? resultTeacher = [];
  List<Question>? questions = [];

  Test({
    this.id,
    this.name,
    this.subject,
    this.stage,
    this.classroom,
    this.term,
    this.minuteNum,
    this.groupId,
    this.result,
    this.questions,
    this.teacher,
  });

  Test.fromJson(Map<String, dynamic> json, bool isTeacher) {
    id = json['id'];
    name = json['name'];
    subject = json['subject'];
    stage = json['stage'];
    classroom = json['classroom'];
    term = json['term'];
    minuteNum = json['minute_num'].toString();
    groupId = json['group_id'];
    teacher = Teacher.fromJson(json['teacher']);
    switch (isTeacher) {
      case true:
        if (json['result'] != null) {
          json['result'].forEach((v) {
            resultTeacher!.add(new Result.fromJson(v));
          });
        }
        break;
      case false:
        result = json['result'];
        break;
    }
    if (json['questions'] != null) {
      json['questions'].forEach((v) {
        questions!.add(new Question.fromJson(v));
      });
    }
  }
}

class Result {
  String? rightAnswerNum;
  String? student;
  String? date;

  Result({this.rightAnswerNum, this.student, this.date});

  Result.fromJson(Map<String, dynamic> json) {
    rightAnswerNum = json['right_answer_num'];
    student = json['student'];
    date = json['date'];
  }
}

class Question {
  int? id;
  String? questionText;
  String? questionImage;
  String? chose1Text;
  String? chose1Image;
  String? chose2Text;
  String? chose2Image;
  String? chose3Text;
  String? chose3Image;
  String? chose4Text;
  String? chose4Image;
  String? answer;

  Question(
      {this.id,
      this.questionText,
      this.questionImage,
      this.chose1Text,
      this.chose1Image,
      this.chose2Text,
      this.chose2Image,
      this.chose3Text,
      this.chose3Image,
      this.chose4Text,
      this.chose4Image,
      this.answer});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionText = json['question_text'];
    questionImage = json['question_image'];
    chose1Text = json['chose1_text'];
    chose1Image = json['chose1_image'];
    chose2Text = json['chose2_text'];
    chose2Image = json['chose2_image'];
    chose3Text = json['chose3_text'];
    chose3Image = json['chose3_image'];
    chose4Text = json['chose4_text'];
    chose4Image = json['chose4_image'];
    answer = json['answer'].toString();
  }
}
