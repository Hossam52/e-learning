import 'dart:developer';

import 'package:e_learning/models/student/tests/all_partecipation_records.dart';
import 'package:e_learning/modules/test_module/student_test/test_widgets/student_leaderboard_list.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';

class StudentChampionLeaderBoard extends StatefulWidget {
  const StudentChampionLeaderBoard({Key? key, required this.persons})
      : super(key: key);
  final List<PartecipationResult> persons;
  @override
  State<StudentChampionLeaderBoard> createState() =>
      _StudentChampionLeaderBoardState();
}

class _StudentChampionLeaderBoardState
    extends State<StudentChampionLeaderBoard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('Leaderboard');
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
                          text: '', // 'الترم الاول',
                          style: TextStyle(color: primaryColor)),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: StudentLeaderBoardList(
                deviceInfo: deviceInfo,
                persons: widget.persons,
              )),
            ],
          ),
        );
      },
    );
  }
}
