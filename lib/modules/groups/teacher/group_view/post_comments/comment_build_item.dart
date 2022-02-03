import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/widgets/default_cached_image.dart';
import 'package:e_learning/shared/componants/widgets/default_popup_menu.dart';
import 'package:e_learning/shared/componants/widgets/membership_widgets/student_star.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentBuildItem extends StatelessWidget {
  CommentBuildItem({
    Key? key,
    required this.onSelected,
    required this.name,
    this.profileImage,
    this.image,
    required this.text,
    required this.date,
    required this.isStudent,
    required this.isStudentComment,
    required this.isMe,
  }) : super(key: key);

  final Function(Object? value) onSelected;
  final String name;
  final String? profileImage;
  final String? image;
  final String text;
  final String date;
  final bool isStudent;
  final bool isStudentComment;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: DefaultCachedNetworkImage(
              imageUrl: '$profileImage', fit: BoxFit.cover),
        ),
        SizedBox(width: 4),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          name,
                          style: secondaryTextStyle(null).copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                        ),
                        if (authType) StudentStar(width: 15.w),
                      ],
                    ),
                  ),
                  if (isMe || isStudent == false)
                    DefaultPopupMenu(
                      items: isStudent
                          ? ['تعديل', 'مسح']
                          : isStudentComment
                              ? ['حذر']
                              : ['تعديل', 'مسح'],
                      icons: isStudent
                          ? [Icons.edit, Icons.delete]
                          : isStudentComment
                              ? [Icons.block]
                              : [Icons.edit, Icons.delete],
                      values: isStudent
                          ? ['edit', 'delete']
                          : isStudentComment
                              ? ['block']
                              : ['edit', 'delete'],
                      onSelected: onSelected,
                    ),
                ],
              ),
              SizedBox(height: 10),
              Linkify(
                onOpen: (link) async {
                  print(link.url);
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: text,
                style: subTextStyle(null).copyWith(color: Colors.black54),
                linkStyle: TextStyle(color: Colors.blue),
                maxLines: 3,
                options: LinkifyOptions(humanize: false),
              ),
              SizedBox(height: 10),
              if (image != null)
                DefaultCachedNetworkImage(
                  imageUrl: image!,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    GroupCubit.get(context).convertDate(date),
                    style: subTextStyle(null),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
