import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildTitleHome(
    {required DeviceInformation deviceInfo, required String title}) {
  return Align(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Text(
          title,
          style: thirdTextStyle(deviceInfo).copyWith(
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.end,
        ),
      ));
}

ListTile buildListItem(
    {required IconData icon, required String title, required Function onTap}) {
  return ListTile(
    leading: Icon(
      icon,
      color: Colors.black87,
    ),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w400,
      ),
    ),
    onTap: () {
      onTap();
    },
  );
}

ListTile buildListItemCustom(
    {required IconData icon, required String title, required Function onTap}) {
  return ListTile(
    leading: FaIcon(icon),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w400,
      ),
    ),
    onTap: () {
      onTap();
    },
  );
}
