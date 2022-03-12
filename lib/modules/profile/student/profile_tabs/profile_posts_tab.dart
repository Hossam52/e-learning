import 'package:e_learning/models/teacher/groups/in_group/group_post_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/discuss_tab/group_question_tab.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/shared_methods.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/default_text_field.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePostsTab extends StatefulWidget {
  const ProfilePostsTab({Key? key}) : super(key: key);

  @override
  _ProfilePostsTabState createState() => _ProfilePostsTabState();
}

class _ProfilePostsTabState extends State<ProfilePostsTab> {
  @override
  void initState() {
    GroupCubit.get(context)
        .getAllPostsAndQuestions('post', 0, true, isProfile: true);
    super.initState();
  }

  final editingController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {},
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        print(cubit.isPostEdit);
        return responsiveWidget(
          responsive: (_, deviceInfo) => Conditional.single(
            context: context,
            conditionBuilder: (context) => state is! GroupGetPostLoadingState,
            fallbackBuilder: (context) => DefaultLoader(),
            widgetBuilder: (context) => cubit.noPostData
                ? NoDataWidget(
                    text: context.tr.no_posts,
                    onPressed: () => GroupCubit.get(context)
                        .getAllPostsAndQuestions('share', 0, true,
                            isProfile: true),
                  )
                : Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // if (GroupCubit.get(context).isStudentPostEdit)
                        //   _EditProfilePost(
                        //     isStudent: true,
                        //     postController: editingController,
                        //     cubit: cubit,
                        //     formKey: formKey,
                        //     noImages: cubit.selectedImages.isEmpty,
                        //     postId: cubit.studentPostId,
                        //   ),
                        GroupStudentTab(
                          deviceInfo: deviceInfo,
                          groupId: 0,
                          cubit: cubit,
                          isPost: true,
                          isQuestion: false,
                          posts: cubit.postsList,
                          isStudent: true,
                          postController: editingController,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _EditProfilePost extends StatelessWidget {
  const _EditProfilePost({
    Key? key,
    required this.isStudent,
    this.postId,
    required this.postController,
    required this.cubit,
    required this.formKey,
    required this.noImages,
    this.isTeacherProfile = false,
  }) : super(key: key);

  final bool isStudent;
  final bool isTeacherProfile;
  final int? postId;
  final TextEditingController postController;
  final GroupCubit cubit;
  final GlobalKey<FormState> formKey;
  final bool noImages;

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15.h,
          ),
          Row(
            children: [
              Expanded(
                child: DefaultTextField(
                  controller: postController,
                  hint: text.what_do_you_want_to_say,
                  bgColor: Colors.grey[200]!,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return text.general_validate;
                    return null;
                  },
                ),
              ),
              if (isStudent)
                IconButton(
                  color: primaryColor,
                  onPressed: () {
                    SharedMethods.unFocusTextField(context);
                    if (noImages)
                      cubit.loadImages();
                    else
                      cubit.clearImageList();
                  },
                  icon: Icon(noImages ? Icons.photo : Icons.close),
                ),
            ],
          ),
          if (cubit.selectedImages.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: cubit.selectedImages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3,
              ),
              itemBuilder: (context, index) => Image.file(
                cubit.selectedImages[index],
              ),
            ),

          // SizedBox(
          //   height: 15.h,
          // ),
          if (isStudent) generateStudentButtons(text, context)
        ],
      ),
    );
  }

  Widget generateStudentButtons(AppLocalizations text, BuildContext context) =>
      Row(
        children: [
          Expanded(
            child: defaultMaterialIconButton(
                onPressed: () async {
                  formKey.currentState!.save();
                  if (formKey.currentState!.validate()) {
                    SharedMethods.unFocusTextField(context);

                    await cubit.addPostAndQuestion(
                      GroupPostModel(
                        text: postController.text,
                        images: noImages ? null : cubit.selectedImages,
                        groupId: 0,
                        type: 'post',
                        postId: postId,
                      ),
                      isStudent: true,
                      isEdit: cubit.isPostEdit,
                      context: context,
                    );
                    cubit.isPostEdit = false;
                    postController.clear();
                    await GroupCubit.get(context).getAllPostsAndQuestions(
                        'post', 0, true,
                        isProfile: true);
                  }
                },
                text: cubit.isStudentPostEdit ? text.edit : text.post,
                icon: cubit.isStudentPostEdit ? Icons.edit : Icons.send,
                textColor: Colors.white,
                backgroundColor: primaryColor),
          ),
          SizedBox(width: 23),
        ],
      );
}
