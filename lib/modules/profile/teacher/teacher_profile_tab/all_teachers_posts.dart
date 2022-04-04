import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/post_build_item.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_tab/edit_post_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/load_more_data.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllTeachersPosts extends StatefulWidget {
  int teacherId;
  AllTeachersPosts(this.teacherId, {Key? key}) : super(key: key);

  @override
  _AllTeachersPostsState createState() => _AllTeachersPostsState();
}

class _AllTeachersPostsState extends State<AllTeachersPosts> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    GroupCubit.get(context).getAllProfilePostsAndQuestion('post');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {
        //   if(state is GroupGeneralDeleteSuccessState)
      },
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return responsiveWidget(
          responsive: (context, deviceInfo) {
            return Conditional.single(
              context: context,
              conditionBuilder: (context) => state is! GroupGetPostLoadingState,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => cubit.noPostData
                  ? NoDataWidget(
                      onPressed: () =>
                          cubit.getAllProfilePostsAndQuestion('post'))
                  : Column(
                      children: [
                        ListView.builder(
                            itemCount: cubit.postsList.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(22.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              //posts for Teacher or what?
                              var post = cubit.postsList[index];
                              return PostBuildItem(
                                isStudentPost: post.student == null,
                                ownerPostId: post.teacherId!,
                                showProfileWhenTap: false,
                                type: 'post',
                                deviceInfo: deviceInfo,
                                isMe: post.teacherPost ?? false,
                                name: "${post.teacher}",
                                image: post.teacherImage,
                                isStudent: false,
                                cubit: cubit,
                                postId: post.id!,
                                answer: null,
                                text: post.text,
                                likesCount: cubit.postsLikeCount[post.id]!,
                                isLiked: cubit.postsLikeBool[post.id]!,
                                date: post.date!,
                                commentCount: post.comments!.length,
                                comments: post.comments,
                                groupId: 0,
                                images: post.images!.isNotEmpty
                                    ? post.images
                                    : null,
                                onEdit: () async {
                                  navigateTo(
                                      context,
                                      EditPostScreen(
                                          post, context, widget.teacherId));
                                  //controller.text = post.text!;
                                  // if (post.images!.isNotEmpty) {
                                  //   await AppCubit.get(context)
                                  //       .addImageFromUrl('', imageUrls: post.images);
                                  //   cubit.selectedImages =
                                  //       AppCubit.get(context).imageFiles;
                                  // }
                                  // cubit.changeStudentEditPost(true, post.id);
                                },
                                onDelete: () {
                                  //   cubit.deleteMethod(post.id!, GroupDeleteType.POST);
                                  GroupCubit.get(context)
                                      .getAllProfilePostsAndQuestion('post');
                                },
                              );
                            }),
                        LoadMoreData(
                            isLoading: state is MoreGroupGetPostLoadingState,
                            onLoadingMore: () {
                              cubit.getMoreAllProfilePostsAndQuestion('post');
                            })
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}
