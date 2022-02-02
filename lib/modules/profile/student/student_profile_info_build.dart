import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/widgets/membership_widgets/student_star.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentProfileInfoBuild extends StatelessWidget {
  const StudentProfileInfoBuild({
    Key? key,
    required this.authType,
    required this.deviceInfo,
    required this.image,
    required this.name,
    required this.points,
    required this.code,
    this.trailing,
  }) : super(key: key);

  final bool authType;
  final DeviceInformation deviceInfo;
  final String image;
  final String name;
  final String points;
  final String code;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffE2E2E2),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: image,
                        ),
                      ),
                      if (authType)
                        Positioned.directional(
                          textDirection: lang == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          end: 5,
                          bottom: 0,
                          child: StudentStar(width: 30),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: deviceInfo.screenwidth * 0.55,
                    // color: Colors.grey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: secondaryTextStyle(deviceInfo)
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'عدد النقاط',
                              style: thirdTextStyle(deviceInfo).copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(points,
                                      style: TextStyle(color: Colors.white)),
                                  SizedBox(width: 5),
                                  Image.asset('assets/images/points.png'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: thirdColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'رقم ',
                                  ),
                                  Text(
                                    'ID',
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color(0xFF8BCAFF).withOpacity(0.65),
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  code,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: code));
                                  showToast(
                                      msg: 'تم النسخ الكود',
                                      state: ToastStates.SUCCESS);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  child: Text(
                                    'نسخ',
                                    style: thirdTextStyle(deviceInfo)
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: trailing != null ? 21.h : 0),
                        if (trailing != null) trailing!,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
