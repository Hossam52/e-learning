import 'package:e_learning/models/teacher/groups/in_group/group_post_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/icons/my_icons_icons.dart';
import 'package:e_learning/shared/componants/shared_methods.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'default_text_field.dart';

class DefaultAddPostWidget extends StatelessWidget {
  const DefaultAddPostWidget({
    Key? key,
    required this.isStudent,
    required this.groupId,
    this.postId,
    this.teacherId,
    required this.postController,
    required this.cubit,
    required this.formKey,
    required this.noImages,
    required this.isEdit,
    this.isTeacherProfile = false,
  }) : super(key: key);

  final bool isStudent;
  final bool isTeacherProfile;
  final int groupId;
  final int? postId;
  final int? teacherId;
  final TextEditingController postController;
  final GroupCubit cubit;
  final GlobalKey<FormState> formKey;
  final bool noImages;
  final bool isEdit;

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
            Container(
              height: 250,
              child: GridView.builder(
                itemCount: cubit.selectedImages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                ),
                itemBuilder: (context, index) => Image.file(
                  cubit.selectedImages[index],
                ),
              ),
            ),
          SizedBox(
            height: 15.h,
          ),
          if (isStudent)
            generateStudentButtons(text, context)
          else
            generateTeacherButtons(text, context),
        ],
      ),
    );
  }

  Widget generateStudentButtons(AppLocalizations text, BuildContext context) => Row(
        children: [
          Expanded(
            child: defaultMaterialIconButton(
                onPressed: () {
                  formKey.currentState!.save();
                  if (formKey.currentState!.validate()) {
                    SharedMethods.unFocusTextField(context);
                    cubit.addPostAndQuestion(
                      GroupPostModel(
                        text: postController.text,
                        images: noImages ? null : cubit.selectedImages,
                        groupId: groupId,
                        type: 'question',
                        postId: postId,
                      ),
                      isStudent: true,
                      isEdit: isEdit,
                      context: context,
                    );
                  }
                },
                text: isEdit ? text.edit : text.question,
                icon: isEdit ? Icons.edit : MyIcons.question,
                textColor: Colors.white,
                backgroundColor: primaryColor),
          ),
          SizedBox(width: 23),
          if(isEdit == false)
          Expanded(
            child: defaultMaterialIconButton(
              onPressed: () {
                formKey.currentState!.save();
                if (formKey.currentState!.validate()) {
                  SharedMethods.unFocusTextField(context);
                  cubit.addPostAndQuestion(
                    GroupPostModel(
                      text: postController.text,
                      images: noImages ? null : cubit.selectedImages,
                      groupId: groupId,
                      type: 'share',
                      postId: postId,
                    ),
                    isStudent: true,
                    isEdit: isEdit,
                    context: context
                  );
                }
              },
              text: text.share,
              icon: MyIcons.share,
              textColor: Colors.white,
              backgroundColor: Color(0xff008DFF),
            ),
          ),
        ],
      );

  Widget generateTeacherButtons(AppLocalizations text, BuildContext context) => Row(
        children: [
          Expanded(
            child: defaultMaterialIconButton(
              onPressed: () {
                formKey.currentState!.save();
                if (formKey.currentState!.validate()) {
                  SharedMethods.unFocusTextField(context);
                  cubit.addPostAndQuestion(
                    GroupPostModel(
                      text: postController.text,
                      images: cubit.selectedImages,
                      groupId: groupId,
                      type: 'post',
                      postId: postId,
                      teacherId: teacherId,
                    ),
                    isStudent: false,
                    isEdit: isEdit,
                    isProfileTeacher: isTeacherProfile,
                    context: context
                  );
                }
              },
              text: isEdit ? text.edit : text.post,
              icon: isEdit ? Icons.edit : Icons.post_add,
              backgroundColor: primaryColor,
              textColor: Colors.white,
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: defaultMaterialIconButton(
              onPressed: () {
                SharedMethods.unFocusTextField(context);
                if (noImages)
                  cubit.loadImages();
                else
                  cubit.clearImageList();
              },
              text: noImages ? text.add_images : text.remove_images,
              icon: noImages ? Icons.photo : Icons.close,
              backgroundColor: noImages ? successColor : errorColor,
              textColor: Colors.white,
            ),
          ),
        ],
      );
}
