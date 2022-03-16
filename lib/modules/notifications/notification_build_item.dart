import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationBuildItem extends StatelessWidget {
  const NotificationBuildItem({
    Key? key,
    required this.image,
    required this.title,
    required this.body,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final String body;
  final String date;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 0),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 50.r,
                height: 50.r,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: thirdTextStyle(null),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: subTextStyle(null),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      date,
                      style: subTextStyle(null).copyWith(color: primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              RawMaterialButton(
                onPressed: onTap,
                child: Icon(Icons.arrow_forward_ios, size: 12),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(minWidth: 0),
                padding: EdgeInsets.all(6),
                shape: CircleBorder(
                  side: BorderSide(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
