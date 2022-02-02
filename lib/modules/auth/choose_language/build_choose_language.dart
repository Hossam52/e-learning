import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:flutter/material.dart';

Expanded buildChooseLanguage(
    DeviceInformation deviceInfo, {
      required Function choose,
      required String label,
      required String text,
      required Color colorContainer,
      required Color colorLabel,
      required Color colorText,
    }) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        choose();
      },
      child: Container(
        alignment: Alignment.center,
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: colorContainer,
          border: Border.all(color: Colors.black12, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: deviceInfo.screenHeight * 0.035,
                  color: colorLabel),
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: deviceInfo.screenHeight * 0.03, color: colorText),
            )
          ],
        ),
      ),
    ),
  );
}