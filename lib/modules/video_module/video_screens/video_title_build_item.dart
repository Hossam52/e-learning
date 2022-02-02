import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class VideoTitleBuildItem extends StatelessWidget {
  const VideoTitleBuildItem({
    Key? key,
    required this.videoTitle,
    required this.videoId,
    required this.onPressed,
  }) : super(key: key);

  final String videoTitle;
  final String videoId;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 160.h,
                  width: double.infinity,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://img.youtube.com/vi/$videoId/0.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.play_circle,
                    color: Colors.white,
                    size: 90,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                videoTitle,
                style: thirdTextStyle(null).copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
