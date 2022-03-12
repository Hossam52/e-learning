import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/student_lead_board_build_item.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';

class StudentTestLeaderBoard extends StatelessWidget {
  const StudentTestLeaderBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  itemCount: 10,
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) => StudentLeadBoardBuildItem(
                    deviceInfo: deviceInfo,
                    name: 'عبدالرحمن ابراهيم',
                    place: 'المركز الاول',
                    points: 'static',
                    image:
                        'https://img.freepik.com/free-photo/female-student-with-books-paperworks_1258-48204.jpg?size=626&ext=jpg',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
