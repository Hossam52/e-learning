import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/teacher/groups/in_group/comment_model.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/comment_text_field_build_item.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/post_build_item.dart';
import 'package:e_learning/modules/groups/teacher/group_view/post_comments/comment_build_item.dart';
import 'package:e_learning/modules/groups/teacher/group_view/post_comments/comment_modal_sheet.dart';
import 'package:e_learning/modules/notifications/cubit/notification_cubit.dart';
import 'package:e_learning/modules/notifications/cubit/notification_post_cubit.dart';
import 'package:e_learning/modules/notifications/cubit/notification_post_states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
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
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (!GroupCubit.get(context).postsLikeBool.containsKey(widget.post.id!)) {
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
    }
    if (!GroupCubit.get(context).postsLikeCount.containsKey(widget.post.id!)) {
      GroupCubit.get(context).postsLikeCount.addEntries(
        [MapEntry(widget.post.id!, widget.post.likesNum ?? 0)],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.post),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              NotificationPostCubit()..getAllPostDetails(widget.post.id!),
          child: BlocConsumer<NotificationPostCubit, NotificationPostState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LoadingPostState) return DefaultLoader();
              NotificationPostCubit postCubit =
                  NotificationPostCubit.get(context);
              if (postCubit.post == null)
                return NoDataWidget(onPressed: () {
                  postCubit.getAllPostDetails(widget.post.id!);
                });
              final post = postCubit.post!;
              return responsiveWidget(
                responsive: (context, deviceInfo) =>
                    BlocBuilder<GroupCubit, GroupStates>(
                  builder: (context, state) {
                    final appCubit = AppCubit.get(context);
                    var comments = widget.post.comments!;
                    final cubit = GroupCubit.get(context);
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(children: [
                              PostBuildItem(
                                isStudentPost: post.student != null,

                                date: post.date!,
                                ownerPostId: post.studentId!,
                                deviceInfo: deviceInfo,
                                type: 'post',
                                isStudent: post.studentPost ??
                                    post.teacherPost ??
                                    true,
                                isMe: false,
                                postId: post.id!,
                                name: post.student ??
                                    post.teacher ??
                                    context.tr.unknown,
                                comments: post.comments,
                                image: post.studentImage ?? post.teacherImage,
                                text: post.text,
                                answer: post.answer, //post.answer!,
                                cubit: GroupCubit.get(context),
                                likesCount: cubit.postsLikeCount[post.id!]!,
                                isLiked: cubit.postsLikeBool[post.id!]!,
                                commentCount: post.comments!.length,
                                groupId: 0,
                                onEdit: () {},
                                onDelete: () {},
                              ),
                              // Container(
                              //   color: Colors.white,
                              //   child: ListView.separated(
                              //     shrinkWrap: true,
                              //     primary: false,
                              //     itemCount: comments.length,
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 22, vertical: 8),
                              //     separatorBuilder: (context, index) =>
                              //         SizedBox(height: 21),
                              //     itemBuilder: (context, index) {
                              //       var comment = comments[index];
                              //       return CommentBuildItem(
                              //         name: comment.teacher != null
                              //             ? comment.teacher!
                              //             : comment.student!,
                              //         image: comment.images,
                              //         profileImage: comment.teacherImage != null
                              //             ? comment.teacherImage
                              //             : comment.studentImage,
                              //         text: comment.text!,
                              //         date: comment.date!,
                              //         isStudent: true,
                              //         isMe: comment.studentComment ??
                              //             comment.teacherComment!,
                              //         isStudentComment:
                              //             comment.student != null ? true : false,
                              //         onSelected: (value) {
                              //           if (value.toString() == 'delete') {
                              //             defaultAlertDialog(
                              //               context: context,
                              //               title: context.tr.remove_post,
                              //               subTitle: context.tr
                              //                   .do_you_really_want_to_delete_this_post,
                              //               buttonConfirm: context.tr.delete,
                              //               buttonReject: context.tr.back,
                              //               onConfirm: () async {
                              //                 await cubit.deleteMethod(comment.id!,
                              //                     GroupDeleteType.COMMENT);
                              //                 comments.removeAt(index);
                              //                 Navigator.pop(context);
                              //               },
                              //               onReject: () {},
                              //             );
                              //           } else if (value.toString() == 'block') {
                              //             cubit.addStudentToGroupWithCode(
                              //               groupId: 0,
                              //               code: comment.code!,
                              //               isAdd: false,
                              //               context: context,
                              //             );
                              //           } else {
                              //             editComment(
                              //               CommentModel(
                              //                 // id: postId,
                              //                 id: comment.id!,
                              //                 text: comment.text!,
                              //                 image: comment.images,
                              //               ),
                              //               appCubit,
                              //               index: index,
                              //             );
                              //           }
                              //         },
                              //       );
                              //     },
                              //   ),
                              // ),
                            ]),
                          ),
                        ),
                        // Form(
                        //   key: formKey,
                        //   child: CommentTextFieldBuildItem(
                        //     appCubit: appCubit,
                        //     cubit: cubit,
                        //     commentController: commentController,
                        //     formKey: formKey,
                        //     isStudent: true,
                        //     isEdit: appCubit.isEdit,
                        //     id: widget.post.id!,
                        //     type: 'post',
                        //     groupId: 0,
                        //     commentType:
                        //         appCubit.isEdit ? CommentType.Edit : CommentType.Add,
                        //   ),
                        // ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void editComment(CommentModel model, AppCubit cubit, {required int index}) {
    cubit.commentId = model.id;
    cubit.index = index;
    cubit.isEdit = true;
    commentController.text = model.text;
    cubit.emit(AppChangeState());
    if (model.image != null) cubit.addImageFromUrl(model.image!);
  }
}
