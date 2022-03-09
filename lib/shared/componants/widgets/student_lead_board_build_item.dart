import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StudentLeadBoardBuildItem extends StatelessWidget {
  const StudentLeadBoardBuildItem({
    Key? key,
    required this.deviceInfo,
    required this.name,
    required this.place,
    required this.image,
    required this.points,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final String name;
  final String place;
  final String image;
  final String points;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 45.w,
              height: 45.h,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(image),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place,
                  style: thirdTextStyle(deviceInfo),
                ),
                SizedBox(height: 5.h),
                Text(
                  name,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Text(
                  points,
                  style: subTextStyle(deviceInfo).copyWith(
                    color: Colors.black,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/icons/points.svg',
                  width: 13.5.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
