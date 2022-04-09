import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';
import 'package:e_learning/modules/following_list/teacher_view/teacher_all_posts.dart';
import 'package:e_learning/modules/following_list/teacher_view/teacher_groups_profile_view.dart';
import 'package:e_learning/modules/following_list/teacher_view/teacher_questions_tab.dart';
import 'package:e_learning/modules/following_list/teacher_view/teachers_tests_profile_tab.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_tab/teacher_edit_profile_tab.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_tab/teacher_profile_posts_tab.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_tab/teacher_profile_question_tab.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherTabBuild extends StatefulWidget {
  const TeacherTabBuild(
      {Key? key, required this.teacher, required this.isStudent})
      : super(key: key);

  final Teacher teacher;
  final bool isStudent;

  @override
  _TabsBuildItemState createState() => _TabsBuildItemState();
}

class _TabsBuildItemState extends State<TeacherTabBuild>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  int index = 0;
  @override
  void initState() {
    _tabController =
        new TabController(length: widget.isStudent ? 4 : 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black54),
                  )),
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.black,
                onTap: (value) {
                  index = value;
                  cubit.emit(AppChangeState());
                },
                indicator: BoxDecoration(
                  color: secondaryColor,
                ),
                tabs: widget.isStudent
                    ? [
                        Tab(text: context.tr.ask_teacher),
                        Tab(text: context.tr.groups),
                        Tab(text: context.tr.tests),
                        Tab(text: context.tr.all_posts),
                      ]
                    : [
                        Tab(text: context.tr.my_account),
                        Tab(text: context.tr.posts),
                        Tab(text: context.tr.ask_teacher),
                      ],
              ),
            ),
            generateBody(index, widget.isStudent, widget.teacher),
          ],
        );
      },
    );
  }

  Widget generateBody(int index, bool isStudent, Teacher teacher) {
    List<Widget> widgets = isStudent
        ? [
            TeacherQuestionsTab(teacherId: teacher.id!),
            TeacherGroupsProfileTab(teacherId: teacher.id!),
            TeacherTestsProfileTab(teacherId: teacher.id!),
            TeacherAllPostsTabForStudent(teacher.id!),
          ]
        : [
            TeacherEditProfileTab(teacher: teacher),
            TeacherProfilePostsTab(teacher.id!),
            TeacherProfileQuestionTab(),
          ];

    return widgets[index];
  }
}
