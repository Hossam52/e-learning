import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentDefaultCard extends StatelessWidget {
  const StudentDefaultCard({Key? key,
    required this.onTap,
    required this.image,
    required this.text,
  }) : super(key: key);

  final Function() onTap;
  final Widget image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(5)
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: MediaQuery.of(context).size.width * 0.08, child: image),
                SizedBox(width: 8),
                VerticalDivider(thickness: 1, color: secondaryColor),
                SizedBox(width: 25.w),
                Text(
                  text,
                  style: thirdTextStyle(null).copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
