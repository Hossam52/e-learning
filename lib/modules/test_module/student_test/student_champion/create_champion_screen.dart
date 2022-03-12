import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/test_module/student_test/student_champion/champion_choose_friends_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../exam_tab.dart';

class CreateChampionScreen extends StatelessWidget {
  const CreateChampionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TestLayoutCubit()..getStudentTests(TestType.Test),
      child: BlocConsumer<TestLayoutCubit, TestLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          TestLayoutCubit cubit = TestLayoutCubit.get(context);
          return responsiveWidget(
            responsive: (_, deviceInfo) {
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(context.tr.choose_exam),
                    centerTitle: true,
                    leading:
                        defaultBackButton(context, deviceInfo.screenHeight),
                  ),
                  body: Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        state is! StudentTestsLoadingState,
                    fallbackBuilder: (context) => DefaultLoader(),
                    widgetBuilder: (context) => cubit.noStudentTestsData
                        ? NoDataWidget(
                            text: context.tr.no_data,
                            onPressed: () {
                              cubit.getStudentTests(TestType.Test);
                            },
                          )
                        : Column(
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
                                  labelStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'NeoSansArabic',
                                  ),
                                  unselectedLabelStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'NeoSansArabic',
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
                                      isChampion: true,
                                    ),
                                    ExamTab(
                                      deviceInfo: deviceInfo,
                                      tests: cubit.studentTestsList,
                                      isChampion: true,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: DefaultAppButton(
                                      text: context.tr.next,
                                      textStyle: thirdTextStyle(null),
                                      width: deviceInfo.screenwidth * 0.5,
                                      onPressed: cubit.selectedTestIndex == null
                                          ? null
                                          : () {
                                              navigateTo(
                                                  context,
                                                  ChampionChooseFriendScreen(
                                                    testId:
                                                        cubit.selectedTestId!,
                                                    test: cubit
                                                            .studentTestsList[
                                                        cubit
                                                            .selectedTestIndex!],
                                                  ));
                                            },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
