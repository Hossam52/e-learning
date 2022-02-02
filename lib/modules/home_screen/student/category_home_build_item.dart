import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryHomeBuildItem extends StatelessWidget {
  const CategoryHomeBuildItem({Key? key,
    required this.deviceInfo,
    required this.image,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final String image;
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      margin: EdgeInsets.all(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            children: [
              Expanded(
                  child: Image.asset(
                    image,
                    fit: BoxFit.fill,
                  )),
              SizedBox(
                height: 4.h,
              ),
              Text(
                title,
                style: thirdTextStyle(deviceInfo).copyWith(
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
