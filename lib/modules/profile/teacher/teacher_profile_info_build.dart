import 'dart:developer';

import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_cached_image.dart';
import 'package:e_learning/shared/componants/widgets/default_teacher_subjects_wrap.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'teacher_info_column.dart';

class TeacherProfileInfoBuild extends StatelessWidget {
  const TeacherProfileInfoBuild({
    Key? key,
    required this.deviceInfo,
    required this.isStudent,
    required this.name,
    required this.subjects,
    required this.rate,
    required this.image,
    required this.isLiked,
    required this.followCount,
    required this.onFollow,
    required this.teacherId,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final int teacherId;
  final bool isStudent;
  final String name;
  final String image;
  final double rate;
  final List<String> subjects;
  final bool isLiked;
  final int followCount;
  final Function(bool isFollowed) onFollow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE2E2E2),
                  ),
                  child: DefaultCachedNetworkImage(
                    imageUrl: image,
                  ),
                )),
                SizedBox(width: 15.w),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: deviceInfo.screenwidth * 0.55,
                    // color: Colors.grey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: thirdTextStyle(deviceInfo)
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          context.tr.free_membership,
                          style: thirdTextStyle(deviceInfo)
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 20.h),
                        DefaultTeacherSubjectsWrap(
                          subjects: subjects,
                          backgroundColor: thirdColor,
                        ),
                        if (isStudent)
                          Row(
                            children: [
                              Expanded(
                                child: FittedBox(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                    child: LikeButton(
                                      isLiked: isLiked,
                                      // size: 40,
                                      likeCount: followCount,
                                      countBuilder: (count, isLiked, text) {
                                        return Text(
                                          '$count ${context.tr.follow}',
                                          style: thirdTextStyle(null).copyWith(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600),
                                        );
                                      },
                                      likeBuilder: (isLiked) {
                                        return Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: primaryColor,
                                        );
                                      },
                                      onTap: (value) async {
                                        await onFollow(value);
                                        return !value;
                                      },
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.white,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  child: Text(
                                    context.tr.rate,
                                    style: thirdTextStyle(null).copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () async {
                                    final res = await showDialog(
                                        context: context,
                                        builder: (_) => _RateDialog());
                                    log('Res is $res');

                                    if (res != null)
                                      StudentCubit.get(context)
                                          .rateTeacher(res, teacherId);
                                  },
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  TeacherInfoColumn(
                    title: context.tr.all_followers,
                    detail: Text('$followCount',
                        style: primaryTextStyle(null)
                            .copyWith(color: Colors.white)),
                  ),
                  VerticalDivider(color: Colors.white, thickness: 1),
                  TeacherInfoColumn(
                    title: context.tr.rate,
                    detail: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBarIndicator(
                          // initialRating: rate,
                          // minRating: 1,
                          // direction: Axis.horizontal,
                          // allowHalfRating: true,
                          itemCount: 5,
                          rating: rate,
                          itemSize: 18.w,
                          // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          // onRatingUpdate: (rating) {
                          //   print(rating);
                          // },
                        ),
                        SizedBox(width: 3),
                        Text(
                          '($rate)',
                          style:
                              subTextStyle(null).copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RateDialog extends StatelessWidget {
  _RateDialog({Key? key}) : super(key: key);
  double rate = 1;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.tr.your_rate,
              style: secondaryTextStyle(null),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 25.w,
                // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  rate = rating;
                },
              ),
            ),
            Center(
              child: TextButton(
                child: Text(context.tr.done),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(0))),
                onPressed: () {
                  Navigator.pop<double>(context, rate);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
