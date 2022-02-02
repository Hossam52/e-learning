import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/student/group_view/group_info_tab/group_info_tab.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/group_home_tab.dart';
import 'package:e_learning/modules/groups/student/group_view/homework_tab/group_homework_tab.dart';
import 'package:e_learning/modules/groups/student/group_view/video_tab/group_video_tab.dart';
import 'package:e_learning/modules/groups/teacher/group_view/teacher_add_student/teahcer_add_student.dart';
import 'package:e_learning/modules/groups/teacher/group_view/teacher_post_tab/teacher_post_tab.dart';
import 'package:e_learning/shared/componants/icons/my_icons_icons.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class TeacherGroupLayout extends StatelessWidget {
  TeacherGroupLayout({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.groupDesc,
  }) : super(key: key);

  final int groupId;
  final String groupName;
  final String groupDesc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocProvider(
        create: (context) =>
            GroupCubit()..getAllPostsAndQuestions('post', groupId, false),
        child: DefaultTabController(
          length: 6,
          child: Scaffold(
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: true,
                  title: Text(groupName),
                  centerTitle: true,
                  leading: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size(double.infinity, 55),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          end: Alignment.bottomCenter,
                          begin: Alignment.topCenter,
                          stops: [0, 0.85, 1],
                          colors: [
                            backgroundColor,
                            Color(0xFFD6DBFB),
                            Color(0xff9DA8FC).withOpacity(0.5)
                          ],
                        ),
                      ),
                      child: TabBar(
                        labelColor: primaryColor,
                        indicatorColor: primaryColor,
                        indicatorWeight: 4,
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 15),
                        indicator: MaterialIndicator(
                          color: primaryColor,
                          topLeftRadius: 5,
                          topRightRadius: 5,
                        ),
                        tabs: [
                          Tab(
                            icon: SvgPicture.asset(
                              'assets/images/icons/post_icon.svg',
                              width: 27,
                            ),
                          ),
                          Tab(
                            icon: SvgPicture.asset(
                              'assets/images/icons/discussion.svg',
                              width: 27,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              CupertinoIcons.play_circle,
                              size: 37,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              MyIcons.add_user,
                              size: 30,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              MyIcons.outline,
                              size: 30,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.info_outline_rounded,
                              size: 37,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  PostTab(groupId: groupId, isStudent: false),
                  GroupHomeTab(isStudent: false, groupId: groupId),
                  GroupVideoTab(groupId: groupId, isStudent: false),
                  TeacherAddStudent(groupId: groupId),
                  GroupHomeworkTab(groupId: groupId, isStudent: false),
                  GroupInfoTab(
                    groupId: groupId,
                    groupName: groupName,
                    groupDesc: groupDesc,
                    isStudent: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
