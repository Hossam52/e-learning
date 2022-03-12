import 'package:e_learning/modules/pdfs_module/teacher/pdfs_screen.dart';
import 'package:e_learning/modules/student/student_subject_teachers_build_item.dart';
import 'package:e_learning/modules/video_module/student/student_playlists_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

// ignore: must_be_immutable
class CoursesTeacherScreen extends StatefulWidget {
  CoursesTeacherScreen({
    Key? key,
    required this.subjectId,
    required this.isFiles,
    required this.title,
    this.type,
  }) : super(key: key);

  final bool isFiles;
  final String title;
  String? type;
  final int subjectId;

  @override
  _CoursesTeacherScreenState createState() => _CoursesTeacherScreenState();
}

class _CoursesTeacherScreenState extends State<CoursesTeacherScreen> {
  @override
  void initState() {
    AppCubit.get(context).getAllSubjectTeachers(
      widget.isFiles,
      subjectId: widget.subjectId,
      type: widget.type,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (_, deviceInfo) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr.teachers),
            centerTitle: true,
            leading: defaultBackButton(context, deviceInfo.screenHeight),
          ),
          body: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              AppCubit cubit = AppCubit.get(context);
              return Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    state is! SubjectTeachersLoadingState,
                fallbackBuilder: (context) => DefaultLoader(),
                widgetBuilder: (context) => cubit.noSubjectTeachersData
                    ? noData(context.tr.no_teachers_up_till_now)
                    : Container(
                        color: Colors.white,
                        child: ListView.separated(
                            itemCount:
                                cubit.whoTeachSubjectModel!.teachers!.length,
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (context, index) {
                              var teacher =
                                  cubit.whoTeachSubjectModel!.teachers![index];
                              return StudentSubjectTeachersBuildItem(
                                image: teacher.image!,
                                name: teacher.name!,
                                subject: 'رياضيات',
                                onTap: () {
                                  if (widget.type != null) {
                                    navigateTo(
                                        context,
                                        PdfsScreen(
                                          isStudent: true,
                                          deviceInfo: deviceInfo,
                                          title: widget.title,
                                          type: widget.type!,
                                          subjectId: widget.subjectId,
                                          teacherId: teacher.id!,
                                        ));
                                  } else {
                                    navigateTo(
                                        context,
                                        StudentPlaylistsScreen(
                                          subjectId: widget.subjectId,
                                          teacherId: teacher.id!,
                                          teacherName: teacher.name!,
                                        ));
                                  }
                                },
                              );
                            }),
                      ),
              );
            },
          ),
        );
      },
    );
  }
}
