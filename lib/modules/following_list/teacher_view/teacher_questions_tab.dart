import 'dart:developer';

import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/post_build_item.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_tab/edit_post_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_add_post_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeacherQuestionsTab extends StatefulWidget {
  const TeacherQuestionsTab({Key? key, required this.teacherId})
      : super(key: key);

  final int teacherId;

  @override
  _TeacherQuestionsTabState createState() => _TeacherQuestionsTabState();
}

class _TeacherQuestionsTabState extends State<TeacherQuestionsTab> {
  final TextEditingController postController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool noImages = true;

  bool isEdit = false;

  @override
  void initState() {
    GroupCubit cubit = GroupCubit.get(context);
    getTeacherDataById();
    noImages = cubit.selectedImages.isEmpty;
    print(noImages);
    super.initState();
  }

  void getTeacherDataById() {
    GroupCubit.get(context)
        .getTeacherDataById(widget.teacherId, TeacherDataType.questions);
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {
        if (state is AddPostSuccessState) {
          getTeacherDataById();
          postController.clear();
          GroupCubit.get(context).clearImageList();
          showSnackBar(text: text.add_success, context: context);
        }
      },
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return responsiveWidget(
          responsive: (_, deviceInfo) => Conditional.single(
            context: context,
            conditionBuilder: (context) => cubit.isTeacherDataLoading == false,
            fallbackBuilder: (context) => DefaultLoader(),
            widgetBuilder: (context) => Form(
              key: formKey,
              child: Column(
                children: [
                  DefaultAddPostWidget(
                    isStudent: false,
                    isTeacherProfile: true,
                    teacherId: widget.teacherId,
                    groupId: 0,
                    postId: GroupCubit.get(context).studentPostId,
                    postController: postController,
                    cubit: cubit,
                    formKey: formKey,
                    noImages: cubit.selectedImages.isEmpty,
                    isEdit: cubit.isStudentPostEdit,
                  ),
                  _postListView(cubit, deviceInfo),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _postListView(GroupCubit cubit, DeviceInformation deviceInfo) {
    return cubit.questionsList.isEmpty
        ? NoDataWidget(onPressed: () => getTeacherDataById())
        : ListView.builder(
            itemCount: cubit.questionsList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) {
              var post = cubit.questionsList[index];
              log(cubit.questionsList.last.student.toString());
              return PostBuildItem(
                ownerPostId: post.studentId!,
                isStudentPost: post.student != null,
                deviceInfo: deviceInfo,
                type: 'question',
                isStudent: true,
                isMe: post.studentPost ?? false,
                postId: post.id!,
                answer: null, //post.answer!,
                cubit: cubit,
                likesCount: cubit.questionLikeCount[post.id]!,
                isLiked: cubit.questionLikeBool[post.id]!,
                commentCount: post.comments!.length,
                groupId: 0,
                onEdit: () async {
                  navigateTo(
                      context, EditPostScreen(post, context, widget.teacherId));
                  return;
                  postController.text = post.text!;

                  if (post.images!.isNotEmpty) {
                    await AppCubit.get(context)
                        .addImageFromUrl('', imageUrls: post.images);
                    cubit.selectedImages = AppCubit.get(context).imageFiles;
                  }
                  cubit.changeStudentEditPost(true, post.id);
                },
                onDelete: () {
                  getTeacherDataById();
                },
                date: post.date!,
                image: post.studentImage ?? "",
                text: post.text!,
                name: post.student ?? context.tr.student,
                comments: post.comments,
                images: post.images!.isNotEmpty ? post.images : null,
              );
            },
          );
  }
}
