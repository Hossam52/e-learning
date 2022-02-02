import 'package:flutter/material.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class OtherPlacesAvatarItem extends StatelessWidget {
  const OtherPlacesAvatarItem({Key? key,
    required this.deviceInfo,
    required this.image,
    required this.name,
    required this.points,
    required this.place,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final String image;
  final String name;
  final String points;
  final String place;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90.w,
          height: 90.h,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor, width: 1),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: thirdColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    place,
                    style: thirdTextStyle(deviceInfo).copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h,),
        Text(name, style: thirdTextStyle(deviceInfo),),
        SizedBox(height: 8.h,),
        Row(
          children: [
            Text(points, style: subTextStyle(deviceInfo).copyWith(
              color: Colors.black,
            ),),
            SvgPicture.asset(
              'assets/images/icons/points.svg',
              width: 13.5.w,
            ),
          ],
        ),
      ],
    );
  }
}
