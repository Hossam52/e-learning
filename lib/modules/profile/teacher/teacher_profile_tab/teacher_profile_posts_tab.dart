import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/post_build_item.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TeacherProfilePostsTab extends StatefulWidget {
  TeacherProfilePostsTab({Key? key}) : super(key: key);

  @override
  _TeacherProfilePostsTabState createState() => _TeacherProfilePostsTabState();
}

class _TeacherProfilePostsTabState extends State<TeacherProfilePostsTab> {
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
      listener: (context, state) {},
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
                  : ListView.builder(
                      itemCount: cubit.postsList.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(22.0),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        //posts for Teacher or what?
                        var post = cubit.postsList[index];
                        return PostBuildItem(
                          ownerPostId: post.teacherId!,
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
                          images: post.images!.isNotEmpty ? post.images : null,
                          onEdit: () {},
                        );
                      }),
            );
          },
        );
      },
    );
  }
}
