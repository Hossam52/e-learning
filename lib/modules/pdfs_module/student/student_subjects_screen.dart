import 'package:e_learning/modules/student/courses_teacher_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/componants/widgets/student_default_card.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentSubjectsScreen extends StatefulWidget {
  const StudentSubjectsScreen({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  final String title;
  final String type;

  @override
  _StudentSubjectsScreenState createState() => _StudentSubjectsScreenState();
}

class _StudentSubjectsScreenState extends State<StudentSubjectsScreen> {
  @override
  void initState() {
    AppCubit.get(context).getTeacherAndStudentSubjects(true);
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
            AppCubit cubit = AppCubit.get(context);
            return Conditional.single(
              context: context,
              conditionBuilder: (context) => state is! GetSubjectsLoadingState,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => state is GetSubjectsErrorState
                  ? NoDataWidget(onPressed: () => cubit.getTeacherAndStudentSubjects(true))
                  : ListView.separated(
                      itemCount: cubit.subjectsModel!.subjects!.length,
                      padding: EdgeInsets.all(16),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) => StudentDefaultCard(
                        onTap: () {
                          navigateTo(
                              context,
                              CoursesTeacherScreen(
                                subjectId:
                                    cubit.subjectsModel!.subjects![index].id!,
                                isFiles: true,
                                type: widget.type,
                                title: widget.title,
                              ));
                        },
                        image: SvgPicture.asset(
                          'assets/images/icons/subjects.svg',
                        ),
                        text: cubit.subjectsModel!.subjects![index].name!,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
