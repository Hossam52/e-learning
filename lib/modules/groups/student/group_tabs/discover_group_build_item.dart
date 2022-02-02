import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../group_type_badge_build_item.dart';

class DiscoverGroupBuildItem extends StatelessWidget {
  const DiscoverGroupBuildItem({
    Key? key,
    required this.cubit,
    required this.groupId,
    required this.groupName,
    required this.teacherName,
    required this.subjectName,
    required this.isFree,
    required this.isJoined,
    required this.onTap,
  }) : super(key: key);

  final GroupCubit cubit;
  final int groupId;
  final String groupName;
  final String teacherName;
  final String subjectName;
  final bool isFree;
  final bool isJoined;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 10),
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
                      title: subjectName,
                      asset: 'assets/images/icons/book.svg',
                      fontSize: 12.sp,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GroupTypeBadgeBuildItem(isFree: isFree),
                      SizedBox(width: 10.w),
                      InkWell(
                        onTap: () {},
                        child: Icon(Icons.info_outlined, color: primaryColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 45.h),
                  InkWell(
                    onTap: () {
                      cubit.toggleStudentJoinGroup(groupId);
                    },
                    child: cubit.isJoinGroupLoading
                        ? Container(
                            child: CircularProgressIndicator(),
                          )
                        : isJoined
                            ? Icon(Icons.logout, color: errorColor)
                            : SvgPicture.asset(
                                'assets/images/icons/group_add.svg',
                                width: 28,
                              ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
