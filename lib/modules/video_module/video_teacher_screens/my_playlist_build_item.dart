import 'package:e_learning/shared/componants/widgets/default_dimissible_widget.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPlaylistBuildItem extends StatelessWidget {
  MyPlaylistBuildItem({Key? key, required this.onPressed,
    required this.playlistName,
    required this.stage,
    required this.videoCount,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  final String playlistName;
  final String stage;
  final String videoCount;
  final Function() onPressed;
  final Function() onDelete;
  final Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 3,
      color: Color(0xffF2F3F6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
      ),
      margin: EdgeInsets.only(bottom: 19.h),
      child: DefaultDismissibleWidget(
        widgetContext: context,
        hasEdit: true,
        name: playlistName,
        onEdit: onEdit,
        onDelete: onDelete,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 16,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(playlistName, style: secondaryTextStyle(null),),
                    SizedBox(height: 7.h),
                    Text(stage, style: thirdTextStyle(null),
                    ),
                  ],
                ),
                Spacer(),
                Text("($videoCount)", style: thirdTextStyle(null).copyWith(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
