import 'package:e_learning/models/student/tests/all_partecipation_records.dart';
import 'package:e_learning/shared/componants/widgets/student_lead_board_build_item.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:flutter/material.dart';

class StudentLeaderBoardList extends StatelessWidget {
  const StudentLeaderBoardList(
      {Key? key, required this.persons, required this.deviceInfo})
      : super(key: key);
  final List<PartecipationResult> persons;
  final DeviceInformation deviceInfo;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: persons.length,
      padding: EdgeInsets.symmetric(horizontal: 22),
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        // log(persons[index].)
        return StudentLeadBoardBuildItem(
          deviceInfo: deviceInfo,
          name: persons[index].student,
          place: 'Rank ${index + 1}',
          points: persons[index].right_answer_num,
          image: persons[index].student_image,
          profileId: int.parse(persons[index].student_id),
        );
      },
    );
  }
}
