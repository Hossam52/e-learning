import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/post_button.dart';
import 'package:e_learning/modules/groups/teacher/group_view/post_comments/comment_modal_sheet.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/widgets/default_cached_image.dart';
import 'package:e_learning/shared/componants/widgets/default_popup_menu.dart';
import 'package:e_learning/shared/componants/widgets/membership_widgets/student_star.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PostBuildItem extends StatelessWidget {
  PostBuildItem({
    Key? key,
    required this.deviceInfo,
    required this.type,
    required this.isStudent,
    required this.isMe,
    this.text,
    this.images,
    this.comments,
    required this.postId,
    required this.answer,
    required this.cubit,
    required this.likesCount,
    required this.commentCount,
    required this.groupId,
    required this.onEdit,
    required this.isLiked,
    required this.date,
    this.name = 'محمد',
    this.image,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final bool isStudent;
  final String type;
  final bool isMe;
  String name;
  String? image;
  final GroupCubit cubit;
  String? text;
  final int postId;
  bool? answer;
  final int likesCount;
  final int commentCount;
  final int groupId;
  final Function onEdit;
  final bool isLiked;
  final String date;
  List<Comments>? comments;
  List<String>? images;

  int currentIndex = 0;
  PageController pageController = PageController();
  TextEditingController commentController = TextEditingController();
  GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var textTranslate = AppLocalizations.of(context)!;
    return Card(
      color: backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: BorderSide(
        color: answer != null
            ? answer!
                ? successColor
                : errorColor
            : primaryColor,
      )),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('Tapped');
                    // AuthCubit.get(context).getPro
                    // cubit.getTeacherDataById(teacherId, type)
                  },
                  child: Container(
                    width: deviceInfo.screenwidth * 0.13,
                    height: deviceInfo.screenwidth * 0.13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 1.5),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider('$image'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: secondaryTextStyle(deviceInfo).copyWith(
                        color: primaryColor,
                        fontSize: 17,
                      ),
                    ),
                    if (authType) StudentStar(width: 15.w),
                    SizedBox(height: 7),
                    Text(
                      cubit.convertDate(date),
                      style: subTextStyle(null).copyWith(fontSize: 12),
                    ),
                  ],
                ),
                Spacer(),
                if (answer != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        answer!
                            ? textTranslate.answered
                            : textTranslate.unanswered,
                        style: thirdTextStyle(deviceInfo)
                            .copyWith(color: primaryColor, fontSize: 12),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      CircleAvatar(
                        child: Icon(
                          answer! ? Icons.check : Icons.close,
                          size: 16,
                        ),
                        backgroundColor: answer! ? successColor : errorColor,
                        foregroundColor: Colors.white,
                        radius: 10,
                      ),
                    ],
                  ),
                SizedBox(
                  width: deviceInfo.screenwidth * 0.03,
                ),
                if (isMe)
                  DefaultPopupMenu(
                    items: [textTranslate.edit, textTranslate.delete],
                    icons: [Icons.edit, Icons.delete],
                    values: ['edit', 'delete'],
                    onSelected: (value) {
                      if (value.toString() == 'delete') {
                        defaultAlertDialog(
                          context: context,
                          title: textTranslate.delete_the_post,
                          subTitle: textTranslate
                              .do_you_really_want_to_delete_this_post,
                          buttonConfirm: textTranslate.delete,
                          buttonReject: textTranslate.back,
                          onConfirm: () async {
                            await cubit.deleteMethod(
                                postId, GroupDeleteType.POST);
                            Navigator.pop(context);
                            cubit.getAllPostsAndQuestions(
                                type, groupId, isStudent);
                          },
                          onReject: () {},
                        );
                      } else {
                        onEdit();
                      }
                    },
                  ),
              ],
            ),
          ),
          if (text != null) SizedBox(height: deviceInfo.screenHeight * 0.027),
          if (text != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Linkify(
                onOpen: (link) async {
                  print(link.url);
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: text!,
                style: thirdTextStyle(deviceInfo)
                    .copyWith(fontWeight: FontWeight.w400),
                linkStyle: TextStyle(color: Colors.blue),
                maxLines: 3,
                options: LinkifyOptions(humanize: false),
              ),
            ),
          SizedBox(height: deviceInfo.screenHeight * 0.015),
          if (images != null)
            Container(
              height: 250,
              child: PageView.builder(
                controller: pageController,
                itemCount: images!.length,
                scrollDirection: Axis.horizontal,
                physics: PageScrollPhysics(),
                itemBuilder: (context, index) => DefaultCachedNetworkImage(
                  imageUrl: images![index],
                ),
              ),
            ),
          if (images != null && images!.length > 1)
            Center(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: images!.length,
                  // activeIndex: currentIndex,
                  effect: ScrollingDotsEffect(
                    dotWidth: 6,
                    dotHeight: 6,
                    activeDotColor: primaryColor,
                  ),
                ),
              ),
            ),
          SizedBox(height: 8),
          defaultDivider(),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: PostButton(
                    svg: 'assets/images/handshake.svg',
                    text: answer != null
                        ? '$likesCount ${textTranslate.me_too}'
                        : '$likesCount ${textTranslate.like}',
                    onPressed: () {
                      cubit.toggleLike(
                        id: postId,
                        isLiked: isLiked,
                        isStudent: isStudent,
                        type: type,
                        likesCount: likesCount,
                        likeType: LikeType.post,
                      );
                    },
                    isLiked: isLiked,
                  ),
                ),
                VerticalDivider(
                  thickness: 1,
                  color: primaryColor,
                  width: 0,
                ),
                Expanded(
                  child: PostButton(
                    svg: 'assets/images/comment.svg',
                    text: answer != null
                        ? '$commentCount ${textTranslate.answer}'
                        : '$commentCount ${textTranslate.comment}',
                    isLiked: false,
                    onPressed: () {
                      showBarModalBottomSheet(
                        expand: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                        ),
                        topControl: defaultModalSheetTopControl(),
                        builder: (context) => CommentModalSheet(
                          isStudent: isStudent,
                          commentController: commentController,
                          formKey: formKey,
                          comments: comments,
                          groupId: groupId,
                          postId: postId,
                          type: type,
                          outsideCubit: cubit,
                          isMe: isMe,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
