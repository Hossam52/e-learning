import 'dart:developer';

import 'package:e_learning/layout/group_layout/student/group_layout.dart';
import 'package:e_learning/layout/group_layout/teacher/teacher_group_layout.dart';
import 'package:e_learning/models/teacher/groups/group_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/group_type_badge_build_item.dart';
import 'package:e_learning/modules/groups/teacher/teacher_public_group_screen.dart';
import 'package:e_learning/modules/student/public_group/public_grouo_home_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class GroupBuildItem extends StatelessWidget {
  GroupBuildItem({
    Key? key,
    required this.deviceInfo,
    required this.isTeacher,
    required this.groupName,
    required this.description,
    required this.isFree,
    required this.groupId,
    required this.onDelete,
    required this.onEdit,
    this.typeGroup = 0,
    this.isJoined,
    this.group,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final bool isTeacher;
  int? typeGroup;
  Group? group;
  final String groupName;
  final String description;
  final bool isFree;
  final int groupId;
  final bool? isJoined;
  final Function() onDelete;
  final Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return isTeacher && typeGroup == 0
        ? FocusedMenuHolder(
            onPressed: () {},
            animateMenuItems: true,
            menuWidth: deviceInfo.screenwidth * 0.6,
            menuItems: [
              FocusedMenuItem(
                title: Text(context.tr.edit),
                onPressed: onEdit,
                trailingIcon: Icon(Icons.edit),
              ),
              FocusedMenuItem(
                title: Text(context.tr.delete),
                onPressed: onDelete,
                trailingIcon: Icon(Icons.delete, color: errorColor),
              ),
            ],
            child: child(context),
          )
        : child(context);
  }

  Widget child(BuildContext context) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        child: InkWell(
          onTap: () {
            // if (isJoined != null)
            {
              if (isTeacher) {
                if (typeGroup == 0)
                  navigateTo(
                      context,
                      TeacherGroupLayout(
                        groupId: groupId,
                        groupName: groupName,
                        groupDesc: description,
                      ));
                else
                  navigateTo(
                      context,
                      PublicGroupTeacherHomeScreen(
                        group: group!,
                      ));
              } else {
                navigateTo(
                  context,
                  GroupLayout(
                    groupId: groupId,
                    groupName: groupName,
                    groupDesc: description,
                  ),
                );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        groupName,
                        style: thirdTextStyle(deviceInfo),
                        maxLines: 2,
                      ),
                    ),
                    GroupTypeBadgeBuildItem(isFree: isFree),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Expanded(
                  child: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: subTextStyle(deviceInfo),
                  ),
                ),
                if (isJoined != null)
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: InkWell(
                      onTap: () {
                        GroupCubit.get(context).toggleStudentJoinGroup(groupId);
                      },
                      child: GroupCubit.get(context).isJoinGroupLoading
                          ? Container(
                              child: CircularProgressIndicator(),
                            )
                          : isJoined!
                              ? Icon(Icons.logout, color: errorColor)
                              : SvgPicture.asset(
                                  'assets/images/icons/group_add.svg',
                                  width: 28,
                                ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
