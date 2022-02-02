import 'package:e_learning/shared/componants/widgets/default_cached_image.dart';
import 'package:e_learning/shared/componants/widgets/default_teacher_subjects_wrap.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildBestTeacherItem extends StatelessWidget {
  BuildBestTeacherItem({
    required this.text,
    required this.name,
    required this.image,
    required this.followersCount,
    required this.subjects,
    required this.onTap,
  });

  final AppLocalizations text;
  final String name;
  final String image;
  final int followersCount;
  final List subjects;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.only(top: 14, bottom: 2, start: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.2, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 77.17.w,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: DefaultCachedNetworkImage(
                      imageUrl: image,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    width: 16.5.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: thirdTextStyle(null),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          children: [
                            Text(
                              '$followersCount',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 3),
                            Text(
                              text.followers,
                              style: subTextStyle(null),
                            ),
                          ],
                        ),
                        DefaultTeacherSubjectsWrap(subjects: subjects),
                      ],
                    ),
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
