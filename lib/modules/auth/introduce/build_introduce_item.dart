import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BuildIntroduceItem extends StatelessWidget {
  Widget child;
  DeviceInformation deviceInformation;
  Color backgroundColorContainer;
  Function onPressed;
  BuildIntroduceItem(
      {
        required this.child,
        required this.deviceInformation,
        required this.backgroundColorContainer,
        required this.onPressed,
      }
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: deviceInformation.screenHeight * 0.02),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
        height: deviceInformation.screenHeight * 0.15,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColorContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}
