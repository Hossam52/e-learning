import 'dart:developer';

import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/modules/test_module/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/componants/widgets/student_lead_board_build_item.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentTestLeaderBoard extends StatefulWidget {
  const StudentTestLeaderBoard({Key? key, required this.testId})
      : super(key: key);
  final int testId;
  @override
  State<StudentTestLeaderBoard> createState() => _StudentTestLeaderBoardState();
}

class _StudentTestLeaderBoardState extends State<StudentTestLeaderBoard> {
  @override
  void initState() {
    TestCubit.get(context).getTopStudentAtTest(widget.testId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('Leaderboard');
    return BlocBuilder<TestCubit, TestStates>(
      builder: (context, state) {
        if (state is LeaderboardTestLoadingState) return DefaultLoader();
        if (TestCubit.get(context).allPartecipationRecordsResponse == null ||
            TestCubit.get(context)
                .allPartecipationRecordsResponse!
                .students
                .data
                .isEmpty)
          return NoDataWidget(
            onPressed: () {
              TestCubit.get(context).getTopStudentAtTest(widget.testId);
            },
            text: 'Try again',
          );
        final persons = TestCubit.get(context)
            .allPartecipationRecordsResponse!
            .students
            .data;

        return responsiveWidget(
          responsive: (_, deviceInfo) {
            return Scaffold(
              appBar: AppBar(
                elevation: 1,
                title: Text(context.tr.partecipation_order),
                centerTitle: true,
                leading: defaultBackButton(context, deviceInfo.screenHeight),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: RichText(
                      text: TextSpan(
                        text: context.tr.users_high_points,
                        style: thirdTextStyle(deviceInfo)
                            .copyWith(color: Colors.black),
                        children: const <TextSpan>[
                          TextSpan(
                              text: 'الترم الاول',
                              style: TextStyle(color: primaryColor)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: persons.length,
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) =>
                          StudentLeadBoardBuildItem(
                        deviceInfo: deviceInfo,
                        name: persons[index].student,
                        place: 'Rank ${index + 1}',
                        points: 'static',
                        image: persons[index].student_image,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
