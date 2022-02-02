import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/teacher/groups/in_group/comment_model.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/comment_text_field_build_item.dart';
import 'package:e_learning/modules/groups/teacher/group_view/post_comments/comment_build_item.dart';
import 'package:e_learning/modules/test_module/teacher/teacher_add_test/test_componants/test_image_remove_button.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

// ignore: must_be_immutable
class CommentModalSheet extends StatelessWidget {
  CommentModalSheet({
    Key? key,
    required this.isStudent,
    required this.isMe,
    required this.commentController,
    required this.outsideCubit,
    required this.formKey,
    required this.postId,
    required this.groupId,
    required this.type,
    this.comments,
  }) : super(key: key);

  final bool isStudent;
  final bool isMe;
  final formKey;
  final GroupCubit outsideCubit;
  final TextEditingController commentController;
  final int postId;
  final int groupId;
  final String type;
  List<Comments>? comments;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);
          return BlocConsumer<GroupCubit, GroupStates>(
            listener: (context, state) {
              if (state is GroupAddCommentSuccessState) {
                outsideCubit.getAllPostsAndQuestions(type, groupId, isStudent);
                commentController.clear();
                appCubit.removeImage();
                if (appCubit.isEdit == false)
                  comments!.add(GroupCubit.get(context).commentModel!);
                else
                  comments![appCubit.index!] =
                      GroupCubit.get(context).commentModel!;
                appCubit.isEdit = false;
                GroupCubit.get(context).changeCubitState();
              }
              if (state is GroupGeneralDeleteSuccessState) {
                outsideCubit.getAllPostsAndQuestions(type, groupId, isStudent);
              }
              if (state is GroupAddStudentWithCodeSuccessState) {
                showSnackBar(context: context, text: 'تم حذر هذا العضو');
                outsideCubit.getAllPostsAndQuestions(type, groupId, isStudent);
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              GroupCubit cubit = GroupCubit.get(context);
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: DefaultGestureWidget(
                  child: Form(
                    key: formKey,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 12),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                defaultBackButton(context,
                                    MediaQuery.of(context).size.height),
                                Text(
                                  'التعليقات',
                                  style: secondaryTextStyle(null),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Conditional.single(
                              context: context,
                              conditionBuilder: (context) =>
                                  comments!.isNotEmpty,
                              fallbackBuilder: (context) =>
                                  noData('لا يوجد تعليقات حتى الان'),
                              widgetBuilder: (context) => ListView.separated(
                                  itemCount: comments!.length,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 8),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 21),
                                  itemBuilder: (context, index) {
                                    var comment = comments![index];
                                    return CommentBuildItem(
                                      name: comment.teacher != null
                                          ? comment.teacher!
                                          : comment.student!,
                                      image: comment.images,
                                      profileImage: comment.teacherImage != null
                                          ? comment.teacherImage
                                          : comment.studentImage,
                                      text: comment.text!,
                                      date: comment.date!,
                                      isStudent: isStudent,
                                      isMe: isStudent ? comment.studentComment! : comment.teacherComment!,
                                      isStudentComment: comment.student != null ? true : false,
                                      onSelected: (value) {
                                        if (value.toString() == 'delete') {
                                          defaultAlertDialog(
                                            context: context,
                                            title: 'مسح المنشور',
                                            subTitle:
                                                'هل تريد حقا مسح هذا المنشور',
                                            buttonConfirm: "مسح",
                                            buttonReject: "عوده",
                                            onConfirm: () async {
                                              await cubit.deleteMethod(
                                                  comment.id!,
                                                  GroupDeleteType.COMMENT);
                                              comments!.removeAt(index);
                                              Navigator.pop(context);
                                            },
                                            onReject: () {},
                                          );
                                        } else if (value.toString() ==
                                            'block') {
                                          cubit.addStudentToGroupWithCode(
                                            groupId: groupId,
                                            code: comment.code!,
                                            isAdd: false,
                                            context: context,
                                          );
                                        } else {
                                          editComment(
                                            CommentModel(
                                              id: postId,
                                              text: comment.text!,
                                              image: comment.images,
                                            ),
                                            appCubit,
                                            index: index,
                                          );
                                        }
                                      },
                                    );
                                  }),
                            ),
                          ),
                          Container(
                            color: backgroundColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (AppCubit.get(context).imageFile != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
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
                                  appCubit: appCubit,
                                  cubit: cubit,
                                  commentController: commentController,
                                  formKey: formKey,
                                  isStudent: isStudent,
                                  isEdit: appCubit.isEdit,
                                  id: postId,
                                  type: type,
                                  groupId: groupId,
                                  commentType: appCubit.isEdit
                                      ? CommentType.Edit
                                      : CommentType.Add,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
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
