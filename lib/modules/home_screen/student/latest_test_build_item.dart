import 'dart:math';

import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LatestTestBuildItem extends StatelessWidget {
  const LatestTestBuildItem({
    Key? key,
    required this.subject,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String subject;
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 10.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color:
                    Color(Random().nextInt(0xffffffff).toInt()).withAlpha(0xff),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                  child: Text(
                    subject,
                    style: thirdTextStyle(null).copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              Text(
                title,
                style: subTextStyle(null).copyWith(fontWeight: FontWeight.w400),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
