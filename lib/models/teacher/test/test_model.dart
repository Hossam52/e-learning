import 'dart:io';

class TestDataModel {
  late String name;
  late int stageId;
  late int classroomId;
  late int termId;
  late int subjectId;
  late int minuteNumber;
  late List<QuestionDataModel> questionDataModel = [];

  TestDataModel({
    required this.name,
    required this.stageId,
    required this.classroomId,
    required this.termId,
    required this.subjectId,
    required this.minuteNumber,
    required this.questionDataModel,
});
}

class QuestionDataModel {
  late String questionText;
  File? questionImage;
  List<Choose>? chooseList = [];
  late int answerIndex;

  QuestionDataModel({
    required this.questionText,
    this.questionImage,
    this.chooseList,
    required this.answerIndex,
});
}

class Choose {
  String? chooseText;
  File? chooseImage;

  Choose({
    this.chooseText,
    this.chooseImage,
});
}