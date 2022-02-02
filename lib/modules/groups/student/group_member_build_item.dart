import 'package:flutter/material.dart';

class GroupMemberBuildItem extends StatelessWidget {
  const GroupMemberBuildItem({
    Key? key,
    required this.margin,
  }) : super(key: key);

  final double margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(end: margin),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(Icons.person, color: Colors.grey, size: 30),
    );
  }
}
