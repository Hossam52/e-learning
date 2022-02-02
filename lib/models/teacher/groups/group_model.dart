class GroupModel {
  int? groupId;
  late String title;
  late int stageId;
  late int classroomId;
  late int termId;
  late int subjectId;
  late String description;
  late String type;

  GroupModel({
    this.groupId,
    required this.title,
    required this.stageId,
    required this.classroomId,
    required this.termId,
    required this.subjectId,
    required this.description,
    required this.type,
  });
}
