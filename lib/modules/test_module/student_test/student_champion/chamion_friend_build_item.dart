import 'package:flutter/material.dart';

class ChampionFriendBuildItem extends StatelessWidget {
  ChampionFriendBuildItem({Key? key,
    required this.value,
    required this.onChanged,
    required this.studentName,
    required this.studentStage,
    this.studentImage,
  }) : super(key: key);

  final bool value;
  final Function(bool? value) onChanged;
  final String studentName;
  final String studentStage;
  String? studentImage;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: (value) {
        onChanged(value);
      },
      title: Text(studentName),
      subtitle: Text(studentStage),
      selected: value,
      secondary: studentImage != null ? Container(
        width: 40,
        height: 40,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Color(0xffE2E2E2),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(
                studentImage!),
          ),
        ),
      ) : null,
    );
  }
}
