import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildTopStudent extends StatelessWidget {
  BuildTopStudent({
    required this.deviceInfo,
    required this.text,
    required this.name,
    required this.image,
    required this.pointsCount,
    required this.onTap,
  });

  final DeviceInformation deviceInfo;
  final AppLocalizations text;
  final String name;
  final String image;
  final String pointsCount;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding:  EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          width: 260.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: Colors.grey.shade300, width: 0.3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E2E2),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(image,),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: thirdTextStyle(deviceInfo).copyWith(
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          text.points_count,
                          style: subTextStyle(deviceInfo),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 2.5.h),
                          decoration: BoxDecoration(
                            color: Color(0xff9DA8FC),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(pointsCount,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(width: 5.w),
                              Image.asset('assets/images/points.png'),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
