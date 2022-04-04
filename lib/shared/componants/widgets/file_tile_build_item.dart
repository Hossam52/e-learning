import 'package:e_learning/shared/componants/widgets/default_dimissible_widget.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FileTileBuildItem extends StatelessWidget {
  const FileTileBuildItem({
    Key? key,
    required this.isStudent,
    required this.deviceInfo,
    required this.text,
    required this.fileId,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  final bool isStudent;
  final DeviceInformation deviceInfo;
  final String text;
  final String fileId;
  final Function onEdit;
  final Function onDelete;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          side: BorderSide.none, borderRadius: BorderRadius.circular(5)),
      child: isStudent
          ? ChildWidget(
              deviceInfo: deviceInfo,
              text: text,
              fileId: fileId,
              onTap: onTap,
            )
          : DefaultDismissibleWidget(
              widgetContext: context,
              hasEdit: false,
              name: text,
              onDelete: onDelete,
              onEdit: onEdit,
              child: ChildWidget(
                deviceInfo: deviceInfo,
                fileId: fileId,
                text: text,
                onTap: onTap,
              ),
            ),
    );
  }
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({
    Key? key,
    required this.deviceInfo,
    required this.text,
    required this.fileId,
    required this.onTap,
  }) : super(key: key);
  final DeviceInformation deviceInfo;
  final String text;
  final String fileId;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/pdf-icon.svg',
                semanticsLabel: 'pdf',
                width: deviceInfo.screenwidth * 0.08,
              ),
              SizedBox(width: 8),
              VerticalDivider(thickness: 1, color: secondaryColor),
              // SizedBox(width: deviceInfo.screenwidth * 0.05),
              Text(
                text,
                style: thirdTextStyle(deviceInfo).copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
