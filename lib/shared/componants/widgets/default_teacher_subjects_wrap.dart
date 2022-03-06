import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class DefaultTeacherSubjectsWrap extends StatelessWidget {
//   const DefaultTeacherSubjectsWrap({
//     Key? key,
//     required this.subjects,
//     this.backgroundColor = secondaryColor,
//   }) : super(key: key);

//   final List subjects;
//   final Color backgroundColor;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       scrollDirection: Axis.horizontal,
//       shrinkWrap: true,
//       primary: false,
//       itemCount: subjects.length,
//       separatorBuilder: (_, index) => SizedBox(
//         width: 5.w,
//       ),
//       itemBuilder: (context, index) => Chip(
//         backgroundColor: backgroundColor,
//         label: Text(subjects[index]),
//         labelPadding: EdgeInsets.symmetric(horizontal: 10),
//         labelStyle: thirdTextStyle(null).copyWith(
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

class DefaultTeacherSubjectsWrap extends StatelessWidget {
  const DefaultTeacherSubjectsWrap({
    Key? key,
    required this.subjects,
    this.backgroundColor = secondaryColor,
  }) : super(key: key);

  final List subjects;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: subjects
          .map((item) => Chip(
                backgroundColor: backgroundColor,
                label: Text(item),
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                labelStyle: thirdTextStyle(null).copyWith(
                  color: Colors.white,
                ),
              ))
          .toList()
          .cast<Widget>(),
    );
  }
}
