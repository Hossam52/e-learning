import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentViewBuildItem extends StatelessWidget {
  StudentViewBuildItem({
    Key? key,
    this.studentImage,
    required this.studentName,
    this.tailing,
    this.onTap,
  }) : super(key: key);

  final String? studentImage;
  final String studentName;
  final Widget? tailing;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        studentName,
        style: thirdTextStyle(null),
      ),
      leading: Container(
        width: 40.82.w,
        height: 40.82.h,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Color(0xffE2E2E2),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(studentImage!),
            fit: BoxFit.cover,
          ),
        ),
      ),
      trailing: tailing,
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      onTap: onTap,
    );
  }
}
