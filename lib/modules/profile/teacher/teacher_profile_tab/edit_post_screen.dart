import 'package:e_learning/models/teacher/groups/in_group/group_post_model.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/default_text_field.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;
  final BuildContext groupsContext;
  final int teacherID;
  EditPostScreen(this.post, this.groupsContext, this.teacherID);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final controller = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    controller.text = widget.post.text!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: ProgressHUD(
        child: BlocProvider(
          create: (context) =>
              AppCubit()..addImageFromUrl('', imageUrls: widget.post.images),
          child: BlocBuilder<AppCubit, AppStates>(
            builder: (appCubitContext, state) {
              return state is! AppChangeState
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.lightBlueAccent,
                      ),
                    )
                  : BlocConsumer<GroupCubit, GroupStates>(
                      listener: (context, state) {
                        if (state is AddPostSuccessState) {
                          GroupCubit.get(context)
                              .getAllProfilePostsAndQuestion('post');
                          showSnackBar(context: context, text: state.message!);
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        var cubit = GroupCubit.get(context);
                        //   cubit.changeState();
                        if (widget.post.images!.isNotEmpty) {
                          cubit.selectedImages =
                              AppCubit.get(appCubitContext).imageFiles;
                          //  cubit.changeState();
                        }
                        final noImages =
                            GroupCubit.get(context).selectedImages.isEmpty;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  DefaultTextField(
                                    controller: controller,
                                    hint: '',
                                    bgColor: Colors.grey[200]!,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'text.general_validate';
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  if (cubit.selectedImages.isNotEmpty)
                                    GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: cubit.selectedImages.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 3,
                                      ),
                                      itemBuilder: (context, index) =>
                                          Image.file(
                                        cubit.selectedImages[index],
                                      ),
                                    ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: defaultMaterialIconButton(
                                          onPressed: () {
                                            formKey.currentState!.save();
                                            if (formKey.currentState!
                                                .validate()) {
                                              cubit.addPostAndQuestion(
                                                GroupPostModel(
                                                  text: controller.text,
                                                  images: noImages
                                                      ? null
                                                      : cubit.selectedImages,
                                                  groupId: -1,
                                                  type: 'post',
                                                  teacherId: widget.teacherID,
                                                  postId: widget.post.id,
                                                ),
                                                isStudent: false,
                                                isEdit: true,
                                                context: context,
                                              );
                                            }
                                          },
                                          text: 'Edit',
                                          icon: cubit.isStudentPostEdit
                                              ? Icons.edit
                                              : Icons.post_add,
                                          backgroundColor: primaryColor,
                                          textColor: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      Expanded(
                                        child: defaultMaterialIconButton(
                                          onPressed: () {
                                            if (noImages)
                                              cubit.loadImages();
                                            else
                                              cubit.clearImageList();
                                          },
                                          text: noImages ? 'add' : 'Remove',
                                          icon: noImages
                                              ? Icons.photo
                                              : Icons.close,
                                          backgroundColor: noImages
                                              ? successColor
                                              : errorColor,
                                          textColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}