import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';

class StudentChallengeBuildItem extends StatelessWidget {
  StudentChallengeBuildItem({Key? key,
    required this.deviceInfo,
    required this.backgroundColor,
    required this.buttonText,
    required this.status,
    required this.testName,
    this.onPressed,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final String testName;
  Function()? onPressed;
  final Color backgroundColor;
  final String buttonText;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            spreadRadius: 0,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: backgroundColor,
            blurRadius: 0,
            spreadRadius: 0,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 0,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                status,
                style: secondaryTextStyle(deviceInfo).copyWith(
                  color: backgroundColor,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: deviceInfo.screenHeight * 0.015),
            defaultDivider(),
            SizedBox(height: deviceInfo.screenHeight * 0.003),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testName,
                    style: thirdTextStyle(deviceInfo),
                  ),
                  SizedBox(height: deviceInfo.screenHeight * 0.03),
                  Align(
                    alignment: Alignment.center,
                    child: DefaultAppButton(
                      onPressed: onPressed,
                      text: buttonText,
                      width: deviceInfo.screenwidth * 0.5,
                      isLoading: false,
                      textStyle: thirdTextStyle(deviceInfo),
                      isDisabled: false,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
