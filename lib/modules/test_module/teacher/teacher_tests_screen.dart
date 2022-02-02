import 'package:e_learning/modules/teacher/results/results_build_item.dart';
import 'package:e_learning/modules/teacher/results/results_view/home_work_result_screen.dart';
import 'package:e_learning/modules/teacher/teacher_filter_build.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/modules/test_module/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'teacher_add_test/teacher_add_test_details.dart';

class TeacherTestsScreen extends StatelessWidget {
  TeacherTestsScreen({
    Key? key,
    required this.deviceInfo,
    required this.subjectId,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final int subjectId;
  final List<String> items = [
    'الكل',
    'المرحلة الاعدادية',
    'المرحلة الابتدأية',
  ];
  final String selectedValue = 'الكل';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestCubit()..getTeacherTestsMethod(subjectId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('اختبارات'),
          elevation: 1,
          centerTitle: true,
          leading: defaultBackButton(context, deviceInfo.screenHeight),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateTo(
                context,
                TeacherAddTestDetails(
                  deviceInfo: deviceInfo,
                ));
          },
          child: Icon(Icons.add),
        ),
        body: BlocConsumer<TestCubit, TestStates>(
          listener: (context, state) {},
          builder: (context, state) {
            TestCubit cubit = TestCubit.get(context);

            return Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  state is! GetTeacherTestsLoadingState,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => cubit.noTeacherTestsData
                  ? noData('لا يوجد لديك امتحانات حتى الان')
                  : Column(
                      children: [
                        TeacherFilterBuild(
                          classItems: items,
                          stageItems: items,
                          deviceInfo: deviceInfo,
                          selectedStage: selectedValue,
                          selectedClass: selectedValue,
                          onClassChanged: (value) {},
                          onStageChanged: (value) {},
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: cubit.teacherTestsList.length,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              var test = cubit.teacherTestsList[index];
                              return ResultsBuildItem(
                                title: test.name!,
                                subtitle1: test.subject!,
                                subtitle2: test.classroom!,
                                isDismissible: true,
                                onTap: () {
                                  navigateTo(
                                      context,
                                      HomeWorkResultScreen(
                                        results: test.resultTeacher,
                                      ));
                                },
                                onDelete: () {
                                  cubit.deleteTeacherTestWithId(
                                    testId: test.id!,
                                    context: context,
                                    subjectId: subjectId,
                                  );
                                },
                                onEdit: () {
                                  navigateTo(
                                      context,
                                      TeacherAddTestDetails(
                                        deviceInfo: deviceInfo,
                                        test: test,
                                      ));
                                },
                              );
                            },
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
