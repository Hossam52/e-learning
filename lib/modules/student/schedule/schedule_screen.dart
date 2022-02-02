import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/modules/student/schedule/timeline_build_item.dart';
import 'package:e_learning/modules/test_module/student_test/test_view/student_test_quetion.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

class ScheduleScreen extends StatelessWidget {
  ScheduleScreen({Key? key}) : super(key: key);

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestLayoutCubit()
        ..getScheduleHomework(DateFormat("yyyy-MM-dd").format(date)),
      child: BlocConsumer<TestLayoutCubit, TestLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          TestLayoutCubit cubit = TestLayoutCubit.get(context);
          return responsiveWidget(
            responsive: (_, deviceInfo) {
              return Column(
                children: <Widget>[
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: DatePicker(
                        DateTime.now(),
                        initialSelectedDate: DateTime.now(),
                        daysCount: 30,
                        selectionColor: primaryColor,
                        selectedTextColor: Colors.white,
                        locale: lang ?? 'ar',
                        onDateChange: (value) {
                          date = value;
                          cubit.getScheduleHomework(
                              DateFormat("yyyy-MM-dd").format(date));
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Conditional.single(
                      context: context,
                      conditionBuilder: (context) =>
                          state is! ScheduleHomeworkLoadingState,
                      fallbackBuilder: (context) => DefaultLoader(),
                      widgetBuilder: (context) => state
                              is ScheduleHomeworkErrorState
                          ? NoDataWidget(
                              onPressed: () => cubit.getScheduleHomework(
                                  DateFormat("yyyy-MM-dd").format(date)))
                          : Timeline.builder(
                              padding: const EdgeInsets.all(22),
                              itemCount:
                                  cubit.homeworkResponseModel!.homework!.length,
                              itemBuilder: (context, index) {
                                var homework = cubit
                                    .homeworkResponseModel!.homework![index];
                                return TimelineBuildItem(
                                  groupName: homework.name!,
                                  teacherName: homework.classroom!,
                                  homeworkName: homework.name!,
                                  onTap: () {
                                    navigateTo(
                                        context,
                                        StudentTestQuestion(
                                          test: homework,
                                          isChampion: false,
                                        ));
                                  },
                                );
                              }),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
