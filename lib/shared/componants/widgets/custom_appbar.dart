import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:flutter/material.dart';

import '../componants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, required this.title, required this.deviceInfo}) : super(key: key);

  final String title;
  final DeviceInformation deviceInfo;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: defaultBackButton(context, deviceInfo.screenHeight),
    );
  }
}
