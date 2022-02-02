import 'package:e_learning/modules/pdfs_module/teacher/pdfs_screen.dart';
import 'package:e_learning/modules/teacher/teacher_subject_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/home_components.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';


class TeacherSubjectsPdfScreen extends StatefulWidget {
  TeacherSubjectsPdfScreen({Key? key, required this.title, required this.type}) : super(key: key);

  final String title;
  final String type;

  @override
  _TeacherSubjectsPdfScreenState createState() =>
      _TeacherSubjectsPdfScreenState();
}

class _TeacherSubjectsPdfScreenState extends State<TeacherSubjectsPdfScreen> {
  @override
  void initState() {
    AppCubit.get(context).getTeacherAndStudentSubjects(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          leading: defaultBackButton(context, deviceInfo.screenHeight),
        ),
        body: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  AppCubit.get(context).subjectsModel != null,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child:
                        buildTitleHome(deviceInfo: deviceInfo, title: 'المواد'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: AppCubit.get(context)
                          .subjectsModel!
                          .subjects!
                          .length,
                      padding: EdgeInsets.all(22),
                      itemBuilder: (context, index) => TeacherSubjectsBuildItem(
                        title: AppCubit.get(context)
                            .subjectsModel!
                            .subjects![index]
                            .name!,
                        onPressed: () {
                          navigateTo(
                            context,
                            PdfsScreen(
                              deviceInfo: deviceInfo,
                              title: widget.title,
                              type: widget.type,
                              isStudent: false,
                              subjectId: AppCubit.get(context)
                                  .subjectsModel!
                                  .subjects![index]
                                  .id!,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
