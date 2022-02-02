import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timelines/timelines.dart';

class TimelineBuildItem extends StatelessWidget {
  const TimelineBuildItem({
    Key? key,
    required this.groupName,
    required this.teacherName,
    required this.homeworkName,
    required this.onTap,
  }) : super(key: key);

  final String groupName;
  final String teacherName;
  final String homeworkName;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      nodeAlign: TimelineNodeAlign.start,
      contents: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsetsDirectional.only(bottom: 15, start: 5),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      listTile(
                        title: groupName,
                        asset: 'assets/images/icons/group.svg',
                        fontSize: 16.sp,
                      ),
                      listTile(
                        title: teacherName,
                        asset: 'assets/images/icons/teacher.svg',
                        fontSize: 14.sp,
                      ),
                      listTile(
                        title: homeworkName,
                        asset: 'assets/images/icons/add_task.svg',
                        fontSize: 12.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      node: TimelineNode(
        indicatorPosition: 0.05,
        indicator: OutlinedDotIndicator(
          size: 20.r,
          color: primaryColor,
        ),
        startConnector: SolidLineConnector(color: primaryColor),
        endConnector: SolidLineConnector(color: primaryColor),
      ),
    );
  }
}
