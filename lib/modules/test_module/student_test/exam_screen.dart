import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/models/enums/enums.dart';
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
    TestLayoutCubit.get(context).getStudentTests(TestType.Test);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestLayoutCubit, TestLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TestLayoutCubit cubit = TestLayoutCubit.get(context);
        return responsiveWidget(
          responsive: (context, deviceInfo) {
            return Conditional.single(
              context: context,
              conditionBuilder: (context) => state is! StudentTestsLoadingState,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => cubit.noStudentTestsData
                  ? NoDataWidget(
                      text: 'عذرا لا يوجد بيانات',
                      onPressed: () {
                        cubit.getStudentTests(TestType.Test);
                      },
                    )
                  : DefaultTabController(
                      length: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16.0,
                            ),
                            child: ButtonsTabBar(
                              backgroundColor: primaryColor,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              unselectedBackgroundColor:
                                  primaryColor.withOpacity(0.4),
                              height: 50,
                              duration: 3,
                              labelStyle: primaryTextStyle(deviceInfo).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              unselectedLabelStyle:
                                  primaryTextStyle(deviceInfo).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              tabs: [
                                Tab(
                                  text: 'اللغة العربية',
                                ),
                                Tab(
                                  text: 'فيزياء',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                ExamTab(
                                  deviceInfo: deviceInfo,
                                  tests: cubit.studentTestsList,
                                  isChampion: false,
                                ),
                                ExamTab(
                                  deviceInfo: deviceInfo,
                                  tests: cubit.studentTestsList,
                                  isChampion: false,
                                ),
                              ],
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
