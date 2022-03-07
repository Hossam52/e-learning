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

class TeacherProfileQuestionTab extends StatefulWidget {
  const TeacherProfileQuestionTab({Key? key}) : super(key: key);

  @override
  _TeacherProfileQuestionTabState createState() =>
      _TeacherProfileQuestionTabState();
}

class _TeacherProfileQuestionTabState extends State<TeacherProfileQuestionTab> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    GroupCubit.get(context)
        .getAllProfilePostsAndQuestion('question', isQuestion: true);
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
              widgetBuilder: (context) => cubit.noQuestionData
                  ? NoDataWidget(
                      onPressed: () => cubit.getAllProfilePostsAndQuestion(
                          'question',
                          isQuestion: true))
                  : ListView.builder(
                      itemCount: cubit.questionsList.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(22.0),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var post = cubit.questionsList[index];
                        return PostBuildItem(
                          type: 'question',
                          ownerPostId: post.studentId!,
                          deviceInfo: deviceInfo,
                          isMe: post.studentPost ?? false,
                          isStudent: false,
                          name: "${post.student}",
                          image: post.studentImage,
                          cubit: cubit,
                          postId: post.id!,
                          answer: post.answer,
                          text: post.text,
                          likesCount: cubit.questionLikeCount[post.id]!,
                          isLiked: cubit.questionLikeBool[post.id]!,
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
