import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/post_build_item.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:flutter/material.dart';

class GroupStudentTab extends StatelessWidget {
  const GroupStudentTab({
    Key? key,
    required this.isQuestion,
    required this.isStudent,
    required this.deviceInfo,
    required this.cubit,
    required this.posts,
    required this.groupId,
    this.postController,
    this.isPost = false,
  }) : super(key: key);

  final bool isQuestion;
  final bool isPost;

  final bool isStudent;
  final DeviceInformation deviceInfo;
  final GroupCubit cubit;
  final List<Post> posts;
  final int groupId;
  final TextEditingController? postController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: posts.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          var post = posts[index];
          return PostBuildItem(
            ownerPostId:isStudent?post.studentId!:post.teacherId!,
            isMe: post.studentPost ?? false,
            type: isPost
                ? 'post'
                : isQuestion
                    ? 'question'
                    : 'share',
            deviceInfo: deviceInfo,
            answer: isQuestion ? post.answer : null,
            cubit: cubit,
            text: post.text!,
            isStudent: isStudent,
            groupId: groupId,
            onEdit: () async {
              cubit.changeStudentEditPost(true, post.id);
              postController!.text = post.text!;
              if (post.images!.isNotEmpty) {
                await AppCubit.get(context)
                    .addImageFromUrl('', imageUrls: post.images);
                cubit.selectedImages = AppCubit.get(context).imageFiles;
              }
            },
            postId: post.id!,
            name: post.student ?? 'student',
            image: post.studentImage ?? post.teacherImage,
            commentCount: post.comments!.length,
            likesCount: isPost
                ? cubit.postsLikeCount[post.id]!
                : isQuestion
                    ? cubit.questionLikeCount[post.id]!
                    : cubit.shareLikeCount[post.id]!,
            isLiked: isPost
                ? cubit.postsLikeBool[post.id]!
                : isQuestion
                    ? cubit.questionLikeBool[post.id]!
                    : cubit.shareLikeBool[post.id]!,
            comments: post.comments,
            date: post.date!,
            images: post.images!.isNotEmpty ? post.images : null,
          );
        },
      ),
    );
  }
}
