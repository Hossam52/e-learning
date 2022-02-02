import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultBuildItem extends StatelessWidget {
  const ResultBuildItem({
    Key? key,
    required this.name,
    required this.image,
    required this.result,
  }) : super(key: key);

  final String name;
  final String image;
  final String result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40.82.w,
            height: 40.82.h,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: Color(0xffE2E2E2),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/student-profile.png'),
              ),
            ),
          ),
          SizedBox(width: 13.5.w),
          Text(
            name,
            style: thirdTextStyle(null),
          ),
          Spacer(),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: result == 'لم يحل' ? errorColor : primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(result,
                  style: thirdTextStyle(null).copyWith(
                    color: Colors.white,
                  ))),
        ],
      ),
    );
  }
}
