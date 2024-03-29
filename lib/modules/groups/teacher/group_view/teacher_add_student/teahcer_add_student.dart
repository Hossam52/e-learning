import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/default_text_field.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/componants/widgets/student_view_build_item.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherAddStudent extends StatefulWidget {
  TeacherAddStudent({Key? key, required this.groupId}) : super(key: key);

  final int groupId;

  @override
  _TeacherAddStudentState createState() => _TeacherAddStudentState();
}

class _TeacherAddStudentState extends State<TeacherAddStudent> {
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  void getMembers() {
    GroupCubit.get(context).getGroupVideosAndStudent(widget.groupId,
        isStudent: false, isMembers: true);
  }

  final TextEditingController codeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (_, deviceInfo) {
        return BlocConsumer<GroupCubit, GroupStates>(
          listener: (context, state) {
            if (state is GroupAddStudentWithCodeSuccessState) getMembers();
          },
          builder: (context, state) {
            GroupCubit cubit = GroupCubit.get(context);
            return Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: DefaultTextField(
                            controller: codeController,
                            hint: context.tr.enter_id,
                            bgColor: Color(0xffDDDDDD).withOpacity(0.4),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return context.tr.this_field_is_required;
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          flex: 1,
                          child: DefaultAppButton(
                            onPressed: () {
                              formKey.currentState!.save();
                              if (formKey.currentState!.validate()) {
                                cubit.addStudentToGroupWithCode(
                                  groupId: widget.groupId,
                                  code: codeController.text,
                                  isAdd: true,
                                  context: context,
                                );
                              }
                            },
                            text: context.tr.add,
                            textStyle: thirdTextStyle(deviceInfo),
                            background: primaryColor,
                            isLoading: cubit.groupAddStudentWithCodeLoading,
                            // height: 30.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Conditional.single(
                      context: context,
                      conditionBuilder: (context) =>
                          state is! GroupGetVideoAndMembersLoadingState,
                      fallbackBuilder: (context) => DefaultLoader(),
                      widgetBuilder: (context) => cubit.noGroupMemberData
                          ? NoDataWidget(
                              text: context.tr.no_data, onPressed: getMembers)
                          : ListView.builder(
                              itemCount:
                                  cubit.studentInGroupModel!.students!.length,
                              padding: EdgeInsets.symmetric(horizontal: 22),
                              itemBuilder: (context, index) {
                                var member =
                                    cubit.studentInGroupModel!.students![index];
                                return StudentViewBuildItem(
                                  studentImage: member.image,
                                  studentName: member.name!,
                                  tailing: DefaultAppButton(
                                    width: 90.w,
                                    onPressed: () {
                                      cubit.addStudentToGroupWithCode(
                                        groupId: widget.groupId,
                                        code: member.code!,
                                        isAdd: false,
                                        context: context,
                                      );
                                    },
                                    text: context.tr.remove,
                                    textStyle: thirdTextStyle(deviceInfo),
                                    background: errorColor,
                                    height: 40.h,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
