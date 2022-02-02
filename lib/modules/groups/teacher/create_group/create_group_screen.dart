import 'package:e_learning/models/teacher/groups/group_model.dart';
import 'package:e_learning/models/teacher/groups/group_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
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
                responsive: (context, deviceInfo) => Scaffold(
                  appBar: AppBar(
                    title: Text('إنشاء مجموعة'),
                    centerTitle: true,
                    leading:
                        defaultBackButton(context, deviceInfo.screenHeight),
                  ),
                  body: SingleChildScrollView(child:
                      responsiveWidget(responsive: (context, deviceInfo) {
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
                                labelText: 'عنوان المجموعة',
                                validation: (title) {
                                  if (title == null || title.isEmpty)
                                    return 'من فضلك ادخل اسم المجموعة';
                                  return null;
                                }),
                            SizedBox(height: 26.h),
                            DefaultFormField(
                                maxLines: 3,
                                controller: groupDescription,
                                type: TextInputType.multiline,
                                labelText: 'وصف المجموعة',
                                validation: (description) {
                                  if (description!.isEmpty)
                                    return 'من فضلك ادخل وصف المجموعة';
                                  return null;
                                }),
                            SizedBox(height: 26.h),
                            Row(
                              children: [
                                Expanded(
                                  child: DefaultDropDown(
                                    label: "المرحله الدراسيه",
                                    onChanged: (value) {
                                      appCubit.onChangeStage(value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'هذا الحقل مطلوب';
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
                                    label: 'الصف الدراسي',
                                    onChanged: (value) {
                                      appCubit.onChangeClass(value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'هذا الحقل مطلوب';
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
                                    label: 'الترم الدارسي',
                                    onChanged: (value) {
                                      appCubit.onTermChange(value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'هذا الحقل مطلوب';
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
                                    label: 'المادة',
                                    onChanged: (value) {
                                      appCubit.onSubjectChange(value);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'هذا الحقل مطلوب';
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
                              'نوع المجموعة',
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
                                    title: Text('عامة'),
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
                                    title: Text('خاصة'),
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
                              idleText:
                                  widget.group != null ? 'تعديل' : 'إنشاء',
                              loadingText: 'Loading',
                              failText: 'حدث خطأ',
                              successText: 'تم الاضافة بنجاح',
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
                                    text: 'من فضلك اكمل بيناتك',
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
