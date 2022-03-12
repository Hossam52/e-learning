import 'package:e_learning/models/teacher/groups/group_model.dart';
import 'package:e_learning/models/teacher/groups/group_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_drop_down.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CreateGroupScreen extends StatefulWidget {
  CreateGroupScreen({this.group});

  Group? group;

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController groupTitle = TextEditingController();

  final TextEditingController groupDescription = TextEditingController();

  @override
  void initState() {
    AppCubit cubit = AppCubit.get(context);
    cubit.getTeacherStages();
    cubit.getTeacherTerms();
    cubit.getTeacherAndStudentSubjects(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupCubit(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (widget.group != null) {
          AppCubit cubit = AppCubit.get(context);
          if (state is GetStagesSuccessState) {
            groupTitle.text = widget.group!.title!;
            groupDescription.text = widget.group!.description!;
            GroupCubit.get(context).groupType = widget.group!.type!;
            cubit.onChangeStage(widget.group!.stage!);
            cubit.onChangeClass(widget.group!.classroom!);
          }
          if (state is GetTermsSuccessState) {
            cubit.onTermChange(widget.group!.term!);
          }
          if (state is GetSubjectsSuccessState) {
            cubit.onSubjectChange(widget.group!.subject!);
          }
        }
      }, builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);

        return BlocConsumer<GroupCubit, GroupStates>(
          listener: (context, state) {},
          builder: (context, state) {
            GroupCubit cubit = GroupCubit.get(context);

            return DefaultGestureWidget(
              child: responsiveWidget(
                responsive: (_, deviceInfo) => Scaffold(
                  appBar: AppBar(
                    title: Text(context.tr.create_group),
                    centerTitle: true,
                    leading:
                        defaultBackButton(context, deviceInfo.screenHeight),
                  ),
                  body: SingleChildScrollView(
                      child: responsiveWidget(responsive: (_, deviceInfo) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: deviceInfo.screenHeight * 0.02,
                            ),
                            DefaultFormField(
                                controller: groupTitle,
                                type: TextInputType.text,
                                labelText: context.tr.group_title,
                                validation: (title) {
                                  if (title == null || title.isEmpty)
                                    return context.tr.enter_group_name;
                                  return null;
                                }),
                            SizedBox(height: 26.h),
                            DefaultFormField(
                                maxLines: 3,
                                controller: groupDescription,
                                type: TextInputType.multiline,
                                labelText: context.tr.group_description,
                                validation: (description) {
                                  if (description!.isEmpty)
                                    return context.tr.enter_group_description;
                                  return null;
                                }),
                            SizedBox(height: 26.h),
                            Row(
                              children: [
                                Expanded(
                                  child: DefaultDropDown(
                                    label: context.tr.academic_year,
                                    onChanged: (value) {
                                      appCubit.onChangeStage(value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return context
                                            .tr.this_field_is_required;
                                      return null;
                                    },
                                    items: appCubit.stageNamesList,
                                    selectedValue:
                                        appCubit.teacherSelectedStage,
                                    isLoading: appCubit.isStagesLoading,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: DefaultDropDown(
                                    // label: 'الصف الدراسي',
                                    label: context.tr.classroom,
                                    onChanged: (value) {
                                      appCubit.onChangeClass(value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return context
                                            .tr.this_field_is_required;
                                      return null;
                                    },
                                    items: appCubit.classNamesList,
                                    selectedValue: appCubit.selectedClassName,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 26.h),
                            Row(
                              children: [
                                Expanded(
                                  child: DefaultDropDown(
                                    // label: 'الترم الدارسي',
                                    label: context.tr.academic_semster,
                                    onChanged: (value) {
                                      appCubit.onTermChange(value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return context
                                            .tr.this_field_is_required;
                                      return null;
                                    },
                                    items: appCubit.termNamesList,
                                    selectedValue: appCubit.selectedTermName,
                                    isLoading: appCubit.isTermsLoading,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: DefaultDropDown(
                                    label: context.tr.subject,
                                    onChanged: (value) {
                                      appCubit.onSubjectChange(value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return context
                                            .tr.this_field_is_required;
                                      return null;
                                    },
                                    items: appCubit.subjectNamesList,
                                    selectedValue: appCubit.selectedSubjectName,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 26.h),
                            Text(
                              context.tr.group_type,
                              style: thirdTextStyle(deviceInfo),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    title: Text(context.tr.public),
                                    value: 'free',
                                    groupValue: cubit.groupType,
                                    onChanged: (value) {
                                      cubit.onChangeGroupType(value);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    title: Text(context.tr.private),
                                    value: 'private',
                                    groupValue: cubit.groupType,
                                    onChanged: (value) {
                                      cubit.onChangeGroupType(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h),
                            DefaultProgressButton(
                              buttonState: cubit.createGroupButtonState,
                              idleText: widget.group != null
                                  ?
                                  //  'تعديل' : 'إنشاء',
                                  context.tr.edit
                                  : context.tr.create,
                              loadingText: context.tr.loading,
                              failText: context.tr.error_happened,
                              successText: context.tr.success_adding,
                              onPressed: () async {
                                formKey.currentState!.save();
                                if (formKey.currentState!.validate() &&
                                    cubit.groupType != null) {
                                  cubit.createGroup(
                                    isEdit: widget.group != null ? true : false,
                                    groupModel: GroupModel(
                                      title: groupTitle.text,
                                      description: groupDescription.text,
                                      stageId: appCubit.selectedStageId!,
                                      classroomId: appCubit.selectedClassId!,
                                      termId: appCubit.selectedTermId!,
                                      subjectId: appCubit.selectedSubjectId!,
                                      type: cubit.groupType!,
                                      groupId: widget.group != null
                                          ? widget.group!.id
                                          : null,
                                    ),
                                    context: context,
                                  );
                                } else {
                                  showSnackBar(
                                    context: context,
                                    text: context.tr.please_complete_your_data,
                                    backgroundColor: errorColor,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
