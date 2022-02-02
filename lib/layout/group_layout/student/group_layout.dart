import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/student/group_view/group_info_tab/group_info_tab.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/group_home_tab.dart';
import 'package:e_learning/modules/groups/student/group_view/homework_tab/group_homework_tab.dart';
import 'package:e_learning/modules/groups/student/group_view/video_tab/group_video_tab.dart';
import 'package:e_learning/modules/groups/teacher/group_view/teacher_post_tab/teacher_post_tab.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/icons/my_icons_icons.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class GroupLayout extends StatelessWidget {
  const GroupLayout({
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
      create: (context) =>
          GroupCubit()..getAllPostsAndQuestions('post', groupId, true),
      child: responsiveWidget(
        responsive: (context, deviceInfo) {
          return DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: AppBar(
                title: Text(groupName),
                centerTitle: true,
                leading: defaultBackButton(context, deviceInfo.screenHeight),
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
                        // Tab(icon: Icon(MyIcons.add_user, size: 30,),),
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
              body: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: TabBarView(
                  children: [
                    PostTab(groupId: groupId, isStudent: true),
                    GroupHomeTab(isStudent: true, groupId: groupId),
                    GroupVideoTab(groupId: groupId, isStudent: true),
                    GroupHomeworkTab(groupId: groupId, isStudent: true),
                    GroupInfoTab(
                      groupId: groupId,
                      groupName: groupName,
                      groupDesc: groupDesc,
                      isStudent: true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
