import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/comment_text_field_build_item.dart';
import 'package:e_learning/modules/groups/teacher/group_view/post_comments/comment_build_item.dart';
import 'package:e_learning/modules/test_module/teacher/teacher_add_test/test_componants/test_image_remove_button.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/cubit.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({
    Key? key,
    required this.title,
    required this.videoId,
    required this.id,
    required this.subjectId,
    required this.teacherId,
    required this.comments,
    required this.commentType,
    required this.likeType,
    required this.isStudent,
    required this.likesCount,
    required this.isLiked,
    this.oldCubit,
  }) : super(key: key);

  final String title;
  final int id;
  final int subjectId;
  final int teacherId;
  final String videoId;
  final List<Comments> comments;
  final CommentType commentType;
  final LikeType likeType;
  final bool isStudent;
  final int likesCount;
  final bool isLiked;
  final VideosCubit? oldCubit;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  FocusNode focusNode = FocusNode();
  TextEditingController commentController = new TextEditingController();

  late YoutubePlayerController controller;
  GlobalKey formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: VideosCubit()..isVideoLiked = widget.isLiked,
      child: BlocConsumer<VideosCubit, VideosStates>(
        listener: (context, state) {},
        builder: (context, state) {
          VideosCubit videosCubit = VideosCubit.get(context);
          return BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              AppCubit appCubit = AppCubit.get(context);
              return BlocConsumer<GroupCubit, GroupStates>(
                listener: (context, state) {
                  if (state is GroupAddCommentSuccessState) {
                    commentController.clear();
                    appCubit.removeImage();
                    if (appCubit.isEdit == false)
                      widget.comments
                          .add(GroupCubit.get(context).commentModel!);
                    else
                      widget.comments[appCubit.index!] =
                          GroupCubit.get(context).commentModel!;
                    appCubit.isEdit = false;
                    GroupCubit.get(context).changeCubitState();
                  }
                  if (state is GroupToggleLikeSuccessState) {
                    if (widget.likeType != LikeType.groupVideo) {
                      widget.oldCubit!.getSubjectPlaylists(
                        widget.isStudent,
                        subjectId: widget.subjectId,
                        teacherId: widget.teacherId,
                      );
                    }
                  }
                  if (state is GroupToggleLikeErrorState) {
                    VideosCubit videosCubit = VideosCubit.get(context);
                    videosCubit.isVideoLiked = !videosCubit.isVideoLiked;
                  }
                },
                builder: (context, state) {
                  GroupCubit groupCubit = GroupCubit.get(context);
                  return DefaultGestureWidget(
                    child: responsiveWidget(
                      responsive: (_, deviceInfo) {
                        return Scaffold(
                          appBar: AppBar(
                            title: Text(widget.title),
                            centerTitle: true,
                            leading: defaultBackButton(
                                context, deviceInfo.screenHeight),
                          ),
                          body: Form(
                            key: formKey,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  color: Colors.white,
                                  height: deviceInfo.screenHeight,
                                  child: YoutubePlayerBuilder(
                                    player: YoutubePlayer(
                                      controller: controller,
                                      showVideoProgressIndicator: true,
                                      width: double.infinity,
                                      progressIndicatorColor: Colors.white,
                                    ),
                                    builder: (context, player) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            player,
                                            Container(
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(20),
                                                    child: Text(
                                                      widget.title,
                                                      style: thirdTextStyle(
                                                              deviceInfo)
                                                          .copyWith(),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            defaultLikeButton(
                                                          deviceInfo:
                                                              deviceInfo,
                                                          text: 'اعجاب',
                                                          icon: videosCubit
                                                                  .isVideoLiked
                                                              ? FontAwesomeIcons
                                                                  .solidThumbsUp
                                                              : FontAwesomeIcons
                                                                  .thumbsUp,
                                                          color: videosCubit
                                                                  .isVideoLiked
                                                              ? primaryColor
                                                              : Colors.grey,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12),
                                                          onPressed: () {
                                                            videosCubit
                                                                    .isVideoLiked =
                                                                !videosCubit
                                                                    .isVideoLiked;
                                                            groupCubit
                                                                .toggleLike(
                                                              id: widget.id,
                                                              likesCount: widget
                                                                  .likesCount,
                                                              type: '',
                                                              isLiked: videosCubit
                                                                  .isVideoLiked,
                                                              isStudent: widget
                                                                  .isStudent,
                                                              likeType: widget
                                                                  .likeType,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child:
                                                            defaultLikeButton(
                                                          deviceInfo:
                                                              deviceInfo,
                                                          text: 'تعليق',
                                                          icon: FontAwesomeIcons
                                                              .commentAlt,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12),
                                                          onPressed: () {
                                                            focusNode
                                                                .requestFocus();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ListView.separated(
                                                    shrinkWrap: true,
                                                    reverse: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        widget.comments.length,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    separatorBuilder: (context,
                                                            index) =>
                                                        SizedBox(height: 21),
                                                    itemBuilder:
                                                        (context, index) {
                                                      var comment = widget
                                                          .comments[index];
                                                      return CommentBuildItem(
                                                        onSelected: (value) {},
                                                        name: comment.student ??
                                                            comment.teacher ??
                                                            'user',
                                                        text: "${comment.text}",
                                                        date: "${comment.date}",
                                                        isStudent: true,
                                                        image: comment.images,
                                                        profileImage: comment
                                                            .studentImage,
                                                        isStudentComment:
                                                            comment.student !=
                                                                    null
                                                                ? true
                                                                : false,
                                                        isMe: widget.isStudent
                                                            ? comment
                                                                .studentComment!
                                                            : comment
                                                                .teacherComment!,
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          appCubit.imageFile !=
                                                                  null
                                                              ? 145.h
                                                              : 90.h),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (appCubit.imageFile != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: TestImageRemoveButton(
                                            onPressed: () {
                                              appCubit.removeImage();
                                            },
                                            image: Image.file(
                                              AppCubit.get(context).imageFile!,
                                              width: 100,
                                            ),
                                          ),
                                        ),
                                      CommentTextFieldBuildItem(
                                        appCubit: AppCubit.get(context),
                                        cubit: groupCubit,
                                        commentController: commentController,
                                        formKey: formKey,
                                        isStudent: widget.isStudent,
                                        isEdit: false,
                                        id: widget.id,
                                        type: '',
                                        groupId: 0,
                                        commentType: widget.commentType,
                                        focusNode: focusNode,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
