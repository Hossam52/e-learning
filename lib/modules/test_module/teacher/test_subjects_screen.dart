import 'package:e_learning/modules/teacher/teacher_subject_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/home_components.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import 'teacher_tests_screen.dart';

class TestSubjectsScreen extends StatefulWidget {
  TestSubjectsScreen({Key? key}) : super(key: key);

  @override
  _TestSubjectsScreenState createState() => _TestSubjectsScreenState();
}

class _TestSubjectsScreenState extends State<TestSubjectsScreen> {
  @override
  void initState() {
    AppCubit.get(context).getTeacherAndStudentSubjects(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (_, deviceInfo) => Scaffold(
        appBar: AppBar(
          title: Text(context.tr.tests),
          centerTitle: true,
          leading: defaultBackButton(context, deviceInfo.screenHeight),
        ),
        body: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Conditional.single(
              context: context,
              conditionBuilder: (context) => cubit.subjectsModel != null,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: buildTitleHome(
                        deviceInfo: deviceInfo, title: context.tr.subjects),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cubit.subjectsModel!.subjects!.length,
                      padding: EdgeInsets.all(22),
                      itemBuilder: (context, index) => TeacherSubjectsBuildItem(
                        title: cubit.subjectsModel!.subjects![index].name!,
                        onPressed: () {
                          navigateTo(
                            context,
                            TeacherTestsScreen(
                              deviceInfo: deviceInfo,
                              subjectId:
                                  cubit.subjectsModel!.subjects![index].id!,
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
