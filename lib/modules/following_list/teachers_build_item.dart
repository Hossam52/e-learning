import 'package:e_learning/shared/componants/widgets/default_cached_image.dart';
import 'package:e_learning/shared/componants/widgets/default_teacher_subjects_wrap.dart';
import 'package:flutter/material.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeachersBuildItem extends StatelessWidget {
  const TeachersBuildItem({
    Key? key,
    required this.isAdd,
    required this.onTap,
    required this.name,
    required this.image,
    required this.country,
    required this.subjects,
    required this.rate,
  }) : super(key: key);

  final bool isAdd;
  final Function() onTap;
  final String name;
  final String image;
  final String country;
  final List subjects;
  final double rate;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: DefaultCachedNetworkImage(
                  imageUrl: image,
                  width: 50.w,
                  height: 50.w,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: thirdTextStyle(null),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      country,
                      style: subTextStyle(null),
                    ),
                    SizedBox(height: 4.h),
                    Expanded(
                        child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        DefaultTeacherSubjectsWrap(subjects: subjects),
                      ],
                    )),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: rate,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 18.w,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                          ignoreGestures: isAdd,
                        ),
                        Text(
                          '($rate)',
                          style:
                              subTextStyle(null).copyWith(color: Colors.amber),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
