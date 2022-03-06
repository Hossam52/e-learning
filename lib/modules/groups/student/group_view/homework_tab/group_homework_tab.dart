import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/teacher/results/results_view/home_work_result_screen.dart';
import 'package:e_learning/modules/test_module/student_test/test_view/student_test_quetion.dart';
import 'package:e_learning/modules/test_module/teacher/teacher_add_test/teacher_add_test_details.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/homework_build_item.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class GroupHomeworkTab extends StatefulWidget {
  const GroupHomeworkTab({
    Key? key,
    required this.groupId,
    required this.isStudent,
  }) : super(key: key);

  final int groupId;
  final bool isStudent;

  @override
  _GroupHomeworkTabState createState() => _GroupHomeworkTabState();
}

class _GroupHomeworkTabState extends State<GroupHomeworkTab> {
  @override
  void initState() {
    GroupCubit.get(context).getGroupHomework(widget.groupId, widget.isStudent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {},
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return responsiveWidget(
          responsive: (_, deviceInfo) {
            return Scaffold(
              floatingActionButton: widget.isStudent
                  ? null
                  : FloatingActionButton(
                      onPressed: () => navigateTo(
                          context,
                          TeacherAddTestDetails(
                            deviceInfo: deviceInfo,
                            groupId: widget.groupId,
                          )),
                      child: Icon(Icons.add),
                    ),
              body: Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    state is! GroupGetHomeworkLoadingState,
                fallbackBuilder: (context) => DefaultLoader(),
                widgetBuilder: (context) => cubit.noHomeworkData
                    ? NoDataWidget(
                        text: 'عذرا لا يوجد بيانات',
                        onPressed: () => cubit.getGroupHomework(
                            widget.groupId, widget.isStudent))
                    : ListView.builder(
                        itemCount:
                            cubit.homeWorkResponseModel!.homework!.length,
                        padding: EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          var homework =
                              cubit.homeWorkResponseModel!.homework![index];
                          return HomeworkBuildItem(
                            deviceInfo: deviceInfo,
                            title: homework.name!,
                            buttonText:
                                widget.isStudent ? 'حل واجب' : 'نتائج الواجب',
                            result: homework.result,
                            onPressed: () {
                              if (widget.isStudent)
                                navigateTo(context,StudentTestQuestion( test: homework, isChampion: false,));
                              else
                                navigateTo(
                                    context,
                                    HomeWorkResultScreen(
                                      results: homework.resultTeacher,
                                    ));
                            },
                            onDelete: () {
                              cubit.deleteMethod(
                                  homework.id!, GroupDeleteType.HOMEWORK);
                            },
                          );
                        }),
              ),
            );
          },
        );
      },
    );
  }
}
