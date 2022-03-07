import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/post_build_item.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_tab/edit_post_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_add_post_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class PostTab extends StatefulWidget {
  PostTab({
    Key? key,
    required this.groupId,
    required this.isStudent,
  }) : super(key: key);

  final int groupId;
  final bool isStudent;

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  final TextEditingController postController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocConsumer<GroupCubit, GroupStates>(
          listener: (context, state) {
            if (state is AddPostSuccessState) {
              print('State changed');
              GroupCubit.get(context).getAllPostsAndQuestions(
                  'post', widget.groupId, widget.isStudent);
              postController.clear();
              GroupCubit.get(context).clearImageList();
              GroupCubit.get(context).isPostEdit = false;
              GroupCubit.get(context).postId = null;
              showSnackBar(text: text.add_success, context: context);
            }
            if (state is GroupGetPostSuccessState) {
              refreshController.refreshCompleted();
            } else if (state is GroupGetPostErrorState)
              refreshController.refreshFailed();
          },
          builder: (context, state) {
            GroupCubit cubit = GroupCubit.get(context);
            bool noImages = cubit.selectedImages.isEmpty;
            return ProgressHUD(
              child: DefaultGestureWidget(
                child: SmartRefresher(
                  controller: refreshController,
                  enablePullDown: true,
                  header: WaterDropHeader(),
                  onRefresh: () {
                    cubit.getAllPostsAndQuestions(
                        'post', widget.groupId, widget.isStudent);
                  },
                  child: Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        state is! GroupGetPostLoadingState,
                    fallbackBuilder: (context) => DefaultLoader(),
                    widgetBuilder: (context) => SingleChildScrollView(
                      child: responsiveWidget(
                        responsive: (_, deviceInfo) {
                          return Form(
                            key: formKey,
                            child: Column(
                              children: [
                                if (widget.isStudent == false)
                                  DefaultAddPostWidget(
                                    isStudent: false,
                                    groupId: widget.groupId,
                                    postId: cubit.postId,
                                    postController: postController,
                                    cubit: cubit,
                                    formKey: formKey,
                                    noImages: noImages,
                                    isEdit: cubit.isPostEdit,
                                  ),
                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.015,
                                ),
                                Conditional.single(
                                  context: context,
                                  conditionBuilder: (context) =>
                                      cubit.noPostData == false,
                                  fallbackBuilder: (context) => NoDataWidget(
                                      text: text.no_posts,
                                      onPressed: () =>
                                          cubit.getAllPostsAndQuestions(
                                              'post',
                                              widget.groupId,
                                              widget.isStudent)),
                                  widgetBuilder: (context) => ListView.builder(
                                      itemCount: cubit.postsList.length,
                                      shrinkWrap: true,
                                      reverse: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.all(16),
                                      itemBuilder: (listViewContext, index) {
                                        var post = cubit.postsList[index];
                                        return PostBuildItem(
                                          type: 'post',
                                          ownerPostId: widget.isStudent
                                              ? post.studentId!
                                              : post.teacherId!,
                                          isMe: widget.isStudent
                                              ? post.studentPost!
                                              : post.teacherPost!,
                                          deviceInfo: deviceInfo,
                                          isStudent: widget.isStudent,
                                          name: post.teacher ?? 'admin',
                                          image: post.teacherImage ??
                                              post.studentImage,
                                          date: post.date!,
                                          cubit: cubit,
                                          postId: post.id!,
                                          answer: null,
                                          text: post.text,
                                          likesCount:
                                              cubit.postsLikeCount[post.id]!,
                                          isLiked:
                                              cubit.postsLikeBool[post.id]!,
                                          commentCount: post.comments!.length,
                                          comments: post.comments,
                                          groupId: widget.groupId,
                                          images: post.images!.isNotEmpty
                                              ? post.images
                                              : null,
                                          onEdit: () async {
                                            navigateTo(
                                              context,
                                              EditPostScreen(
                                                post,
                                                context,
                                                3,
                                                groupId: widget.groupId,
                                              ),
                                            );
                                            // cubit.changeEditPost(true, post.id);
                                            // postController.text = post.text!;
                                            // if (post.images!.isNotEmpty) {
                                            //   await AppCubit.get(context)
                                            //       .addImageFromUrl('',
                                            //           imageUrls: post.images);
                                            //   cubit.selectedImages =
                                            //       AppCubit.get(context)
                                            //           .imageFiles;
                                            // }
                                          },
                                        );
                                      }),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
