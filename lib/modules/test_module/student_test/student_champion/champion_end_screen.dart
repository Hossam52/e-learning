import 'package:e_learning/layout/student/student_layout.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChampionEndScreen extends StatelessWidget {
  const ChampionEndScreen({Key? key, required this.testName}) : super(key: key);

  final String testName;

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (_, deviceInfo) =>
          Scaffold(
            appBar: AppBar(
              elevation: 1,
              title: Text(testName),
              centerTitle: true,
              leading: Container(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 32.0.h, bottom: 20.h),
                          child: Text(
                            'انتهت!!',
                            style: secondaryTextStyle(null)
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                        defaultDivider(),
                        SizedBox(height: 25.h),
                        SvgPicture.asset(
                            'assets/images/icons/champion_end.svg'),
                        SizedBox(height: 75.h),
                        Text(
                          'يمكنك معرفه النتيجه واجباتك الصحيحه عند انتهاء جميع المستخدمين من المشاركه او انتهاء الوقت ',
                          textAlign: TextAlign.center,
                          style: thirdTextStyle(null),
                        ),
                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 75.h),
                  DefaultAppButton(
                    text: 'الرجوع',
                    textStyle: thirdTextStyle(null),
                    width: deviceInfo.screenwidth * .5,
                    onPressed: () {
                      navigateToAndFinish(context, StudentLayout());
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
