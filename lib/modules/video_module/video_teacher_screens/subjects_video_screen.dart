import 'package:e_learning/modules/student/courses_teacher_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../subjects_build_item.dart';
import 'my_videos_teacher_screen.dart';

class SubjectsVideoScreen extends StatefulWidget {
  SubjectsVideoScreen({Key? key, required this.isStudent}) : super(key: key);

  final bool isStudent;
  @override
  _SubjectsVideoScreenState createState() =>
      _SubjectsVideoScreenState();
}

class _SubjectsVideoScreenState
    extends State<SubjectsVideoScreen> {
  @override
  void initState() {
    AppCubit.get(context).getTeacherAndStudentSubjects(widget.isStudent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return Scaffold(
          appBar: AppBar(
            title: Text('المواد'),
            centerTitle: true,
            leading: defaultBackButton(context, deviceInfo.screenHeight),
          ),
          body: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              AppCubit appCubit = AppCubit.get(context);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Conditional.single(
                        context: context,
                        conditionBuilder: (context) =>
                            appCubit.subjectsModel != null,
                        fallbackBuilder: (context) => DefaultLoader(),
                        widgetBuilder: (context) => GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          shrinkWrap: true,
                          itemCount:
                              appCubit.subjectsModel!.subjects!.length,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 15, //horizontal,
                            mainAxisSpacing: 15,
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 1.4,
                          ),
                          itemBuilder: (context, index) {
                            return SubjectsBuildItem(
                              deviceInfo: deviceInfo,
                              title: appCubit
                                  .subjectsModel!.subjects![index].name!,
                              onPressed: () {
                                if(widget.isStudent) {
                                  navigateTo(context, CoursesTeacherScreen(
                                    subjectId: appCubit
                                        .subjectsModel!.subjects![index].id!,
                                    isFiles: false,
                                    title: 'فديوهاتي',
                                  ));
                                } else {
                                  navigateTo(context, MyVideosTeacherScreen(
                                    index: appCubit
                                        .subjectsModel!.subjects![index].id!,
                                  ));
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
