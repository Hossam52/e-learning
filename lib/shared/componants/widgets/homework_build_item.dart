import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_dimissible_widget.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeworkBuildItem extends StatelessWidget {
  HomeworkBuildItem({
    Key? key,
    required this.deviceInfo,
    required this.title,
    required this.buttonText,
    required this.onPressed,
    required this.onDelete,
    this.result,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final String title;
  final String buttonText;
  final Function onPressed;
  final Function() onDelete;
  String? result;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: DefaultDismissibleWidget(
        name: title,
        widgetContext: context,
        hasEdit: false,
        onDelete: onDelete,
        onEdit: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: thirdTextStyle(null)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text('١٢-١٢-٢٠٢١'),
                ],
              ),
              SizedBox(height: 23.h),
              if (result != null)
                Text("النتيجة $result")
              else
                defaultElevatedButton(
                  deviceInfo: deviceInfo,
                  onPressed: onPressed,
                  title: buttonText,
                  background: primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
