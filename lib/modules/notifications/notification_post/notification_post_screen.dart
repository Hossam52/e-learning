import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/post_build_item.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPostScreen extends StatefulWidget {
  const NotificationPostScreen({Key? key, required this.post})
      : super(key: key);
  final Post post;

  @override
  State<NotificationPostScreen> createState() => _NotificationPostScreenState();
}

class _NotificationPostScreenState extends State<NotificationPostScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GroupCubit.get(context).postsLikeBool.addEntries([
      MapEntry(
          widget.post.id!,
          widget.post.studentId != null
              ? widget.post.authLikeStudent ??
                  widget.post.authLikeStudent ??
                  widget.post.authLikeTeacher ??
                  false
              : false)
    ]);
    GroupCubit.get(context).postsLikeCount.addEntries(
      [MapEntry(widget.post.id!, widget.post.likesNum!)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: responsiveWidget(
        responsive: (context, deviceInfo) =>
            BlocBuilder<GroupCubit, GroupStates>(
          builder: (context, state) {
            final cubit = GroupCubit.get(context);
            return Column(children: [
              PostBuildItem(
                date: widget.post.date!,
                ownerPostId: widget.post.studentId!,
                deviceInfo: deviceInfo,
                type: 'question',
                isStudent: true,
                isMe: widget.post.studentPost ?? false,
                postId: widget.post.id!,
                answer: widget.post.answer, //post.answer!,
                cubit: GroupCubit.get(context),
                likesCount: widget.post.likesNum!,
                isLiked: widget.post.authLikeStudent ??
                    widget.post.authLikeTeacher ??
                    false,
                commentCount: widget.post.comments!.length,
                groupId: 0,
                onEdit: () {},
              )
            ]);
          },
        ),
      ),
    );
  }
}
