import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentTestBuildItem extends StatelessWidget {
  const StudentTestBuildItem({Key? key,
    required this.onTap,
    required this.label,
    required this.testName,
    required this.teacherName,
    required this.isSelected,
    this.labelColor = primaryColor,
  }) : super(key: key);

  final Function() onTap;
  final String label;
  final String testName;
  final String teacherName;
  final Color labelColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shadowColor: Colors.grey[200],
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? primaryColor : Colors.transparent,
        )
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: labelColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      label,
                      style: thirdTextStyle(null)
                          .copyWith(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      testName,
                      style: thirdTextStyle(null).copyWith(
                        fontWeight: FontWeight.w400,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      teacherName,
                      style: thirdTextStyle(null).copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 15.h,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
