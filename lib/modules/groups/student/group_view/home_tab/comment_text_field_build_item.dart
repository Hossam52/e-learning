import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/teacher/groups/in_group/comment_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class CommentTextFieldBuildItem extends StatelessWidget {
  const CommentTextFieldBuildItem({
    Key? key,
    required this.appCubit,
    required this.cubit,
    required this.commentController,
    required this.formKey,
    required this.isStudent,
    required this.isEdit,
    required this.id,
    required this.type,
    required this.groupId,
    required this.commentType,
    this.focusNode,
  }) : super(key: key);

  final AppCubit appCubit;
  final GroupCubit cubit;
  final TextEditingController commentController;
  final formKey;
  final bool isStudent;
  final bool isEdit;
  final int id;
  final String type;
  final int groupId;
  final CommentType commentType;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DefaultFormField(
            validation: (value) {
              if (value == null || value.isEmpty)
                return context.tr.this_field_is_required;
              return null;
            },
            controller: commentController,
            haveBackground: true,
            hintText: context.tr.write_comment_here,
            suffix: authType ? Icons.photo : null,
            suffixPressed: () {
              alertDialogImagePicker(
                  context: context, cubit: appCubit, onTap: () {});
            },
            maxLines: 5,
            focusNode: focusNode,
          ),
        ),
        IconButton(
          onPressed: () {
            formKey.currentState!.save();
            if (formKey.currentState!.validate()) {
              cubit.addComment(
                isStudent: isStudent,
                model: CommentModel(
                  id: isEdit ? appCubit.commentId! : id,
                  text: commentController.text,
                  image: appCubit.imageFile != null
                      ? appCubit.imageFile!.path
                      : null,
                ),
                type: type,
                groupId: groupId,
                isEdit: isEdit,
                commentType: commentType,
              );
            }
          },
          icon: cubit.isAddCommentLoading
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Icon(isEdit ? Icons.edit : Icons.send),
          color: primaryColor,
        ),
      ],
    );
  }
}
