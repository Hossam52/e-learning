import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import 'exam_tab.dart';

class StudentExamScreen extends StatefulWidget {
  const StudentExamScreen({Key? key}) : super(key: key);

  @override
  _StudentExamScreenState createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  @override
  void initState() {
    TestLayoutCubit.get(context).getMySubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestLayoutCubit, TestLayoutStates>(
      listener: (context, state) {
        if (state is StudentSubjectsLoadingState) {}
      },
      builder: (context, state) {
        TestLayoutCubit cubit = TestLayoutCubit.get(context);
        return responsiveWidget(
          responsive: (context, deviceInfo) {
            final subjects = TestLayoutCubit.get(context).studentSubjects;
            return Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  state is! StudentSubjectsLoadingState,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => subjects.length == 0
                  ? NoDataWidget(
                      text: 'عذرا لا يوجد بيانات',
                      onPressed: () {
                        cubit.getMySubjects();
                      },
                    )
                  : DefaultTabController(
                      length: subjects.length,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16.0,
                            ),
                            child: ButtonsTabBar(
                                onTap: (int index) async {
                                  log('index');
                                  if (subjects[index].tests == null) {
                                    await cubit.setTestsBySubjectIndex(index);
                                  }
                                },
                                backgroundColor: primaryColor,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                unselectedBackgroundColor:
                                    primaryColor.withOpacity(0.4),
                                height: 50,
                                duration: 3,
                                labelStyle:
                                    primaryTextStyle(deviceInfo).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                                unselectedLabelStyle:
                                    primaryTextStyle(deviceInfo).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                                tabs: subjects
                                    .map((e) => Tab(text: e.name))
                                    .toList()),
                          ),
                          Expanded(
                            child: state is StudentTestsLoadingState
                                ? DefaultLoader()
                                : TabBarView(
                                    children: subjects
                                        .map(
                                          (subject) => ExamTab(
                                            deviceInfo: deviceInfo,
                                            tests: subject.tests == null
                                                ? []
                                                : subject.tests!,
                                            isChampion: false,
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
