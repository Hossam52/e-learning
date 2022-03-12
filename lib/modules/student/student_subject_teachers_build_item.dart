import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentSubjectTeachersBuildItem extends StatelessWidget {
  const StudentSubjectTeachersBuildItem({
    Key? key,
    required this.image,
    required this.name,
    required this.subject,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final String name;
  final String subject;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 22),
          child: Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryColor,
                    ),
                    child: Text(
                      context.tr.premium_member,
                      style: thirdTextStyle(null).copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    name,
                    style: secondaryTextStyle(null),
                  ),
                  // SizedBox(height: 5.h,),
                  Text(
                    subject,
                    style: thirdTextStyle(null),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
