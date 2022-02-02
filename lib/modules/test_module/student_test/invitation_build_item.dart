import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvitationChallengeBuildItem extends StatelessWidget {
  const InvitationChallengeBuildItem({
    Key? key,
    required this.name,
    required this.image,
  }) : super(key: key);

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.73),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(image),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: thirdTextStyle(null),
                ),
                SizedBox(height: 5),
                Text(
                  'لقد دعاك الي مسابقه',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
