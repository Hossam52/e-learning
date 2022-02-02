import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class TeacherInfoColumn extends StatelessWidget {
  TeacherInfoColumn({Key? key,
    required this.title,
    required this.detail,
    this.flex = 1,
  }) : super(key: key);

  final String title;
  final Widget detail;
  int flex;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Column(
        children: [
          Text(title, style: thirdTextStyle(null).copyWith(color: Colors.white)),
          SizedBox(height: 4.h),
          detail
        ],
      ),
    );
  }
}
