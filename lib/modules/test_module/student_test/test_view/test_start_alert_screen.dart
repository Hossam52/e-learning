import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/membership_widgets/expired_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'student_test_quetion.dart';

class TestStartAlertScreen extends StatelessWidget {
  const TestStartAlertScreen({Key? key,
    required this.test,
  }) : super(key: key);

  final Test test;

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return Scaffold(
          appBar: AppBar(
            title: Text(test.name!),
            centerTitle: true,
            leading: defaultBackButton(context, deviceInfo.screenHeight),
          ),
          body: Conditional.single(
            context: context,
            conditionBuilder: (context) => testCounter < 10,
            fallbackBuilder: (context) => ExpiredWidget(),
            widgetBuilder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SvgPicture.asset(
                      'assets/images/exam_about_start.svg',
                      // width: 150,
                    ),
                  ),
                  Text(
                    'هل تريد بدأ هذا الاختبار الان؟',
                    style: secondaryTextStyle(deviceInfo),
                  ),
                  SizedBox(height: deviceInfo.screenHeight * 0.08),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: DefaultAppButton(
                          onPressed: () {
                            navigateTo(
                                context,
                                StudentTestQuestion(
                                  test: test,
                                  isChampion: false,
                                ));
                          },
                          text: 'بدأ',
                          isLoading: false,
                          textStyle: thirdTextStyle(deviceInfo),
                          isDisabled: false,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: DefaultAppButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: 'رجوع',
                          background: Colors.transparent,
                          border: errorColor,
                          textColor: errorColor,
                          isLoading: false,
                          textStyle: thirdTextStyle(deviceInfo),
                          isDisabled: false,
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
  }
}
