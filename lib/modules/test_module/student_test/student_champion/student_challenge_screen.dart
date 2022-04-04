import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/test_module/student_test/test_view/student_test_quetion.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../exam_tab.dart';
import 'create_champion_screen.dart';

class StudentChallengeScreen extends StatefulWidget {
  const StudentChallengeScreen({Key? key}) : super(key: key);

  @override
  _StudentChallengeScreenState createState() => _StudentChallengeScreenState();
}

class _StudentChallengeScreenState extends State<StudentChallengeScreen> {
  @override
  void initState() {
    TestLayoutCubit.get(context).getStudentTests(TestType.Champion);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(AuthCubit.get(context).studentProfileModel!.student!.id.toString());
    log('My challenges champion');
    return BlocConsumer<TestLayoutCubit, TestLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TestLayoutCubit cubit = TestLayoutCubit.get(context);

        return responsiveWidget(
          responsive: (_, deviceInfo) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    navigateTo(context, CreateChampionScreen());
                  },
                  label: Text(context.tr.create_competition),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                body: Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      state is! StudentTestsLoadingState,
                  fallbackBuilder: (context) => DefaultLoader(),
                  widgetBuilder: (context) {
                    if (cubit.noStudentChampionData) {
                      return NoDataWidget(
                        text: context.tr.no_data,
                        onPressed: () {
                          cubit.getStudentTests(TestType.Champion);
                        },
                      );
                    } else {
                      final champion =
                          cubit.championResponseModel!.champion!.championData!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExamTab(
                            onChampionTap: (int index) {
                              if (champion[index].results == null) {
                                //navigate to test screen
                                navigateTo(
                                  context,
                                  StudentTestQuestion(
                                    test: champion[index].test!,
                                    isChampion: true,
                                  ),
                                );
                              }
                            },
                            deviceInfo: deviceInfo,
                            tests: List.generate(champion.length,
                                (index) => champion[index].test!),
                            isChampion: true,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     top: 16.0,
                          //   ),
                          //   child: ButtonsTabBar(
                          //     backgroundColor: primaryColor,
                          //     contentPadding:
                          //         EdgeInsets.symmetric(horizontal: 15),
                          //     unselectedBackgroundColor:
                          //         primaryColor.withOpacity(0.4),
                          //     height: 50,
                          //     duration: 3,
                          //     labelStyle: TextStyle(
                          //       fontSize: 18,
                          //       color: Colors.white,
                          //       fontFamily: 'NeoSansArabic',
                          //     ),
                          //     unselectedLabelStyle: TextStyle(
                          //       fontSize: 18,
                          //       color: Colors.white,
                          //       fontFamily: 'NeoSansArabic',
                          //     ),
                          //     tabs: [
                          //       Tab(
                          //         text: 'اللغة العربية',
                          //       ),
                          //       Tab(
                          //         text: 'فيزياء',
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Expanded(
                          //   child: TabBarView(
                          //     children: [
                          //       ExamTab(
                          //         showTestWhenTapChampion: true,
                          //         deviceInfo: deviceInfo,
                          //         tests: List.generate(
                          //             cubit.championResponseModel!.champion!
                          //                 .championData!.length,
                          //             (index) => cubit
                          //                 .championResponseModel!
                          //                 .champion!
                          //                 .championData![index]
                          //                 .test!),
                          //         isChampion: true,
                          //       ),
                          //       ExamTab(
                          //         deviceInfo: deviceInfo,
                          //         tests: [],
                          //         isChampion: true,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
