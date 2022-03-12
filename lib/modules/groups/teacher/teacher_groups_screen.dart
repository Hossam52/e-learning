import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_build_item.dart';
import 'package:e_learning/modules/groups/teacher/create_group/create_group_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class TeacherGroupsScreen extends StatelessWidget {
  const TeacherGroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupCubit()..getMyGroups(false, GroupType.Teacher),
      child: BlocConsumer<GroupCubit, GroupStates>(
        listener: (context, state) {
          if (state is GroupGeneralDeleteSuccessState)
            GroupCubit.get(context).getMyGroups(false, GroupType.Teacher);
        },
        builder: (context, state) {
          GroupCubit cubit = GroupCubit.get(context);

          return responsiveWidget(
            responsive: (context, deviceInfo) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    state is! GroupsTeacherGetLoadingState,
                fallbackBuilder: (context) => DefaultLoader(),
                widgetBuilder: (context) => cubit.noGroupsData
                    ? NoDataWidget(
                        text: context.tr.no_data,
                        onPressed: () {
                          cubit.getMyGroups(false, GroupType.Teacher);
                        },
                      )
                    : GridView.builder(
                        itemCount: cubit.groupResponseModel!.groups!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.7,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          var group = cubit.groupResponseModel!.groups![index];
                          return GroupBuildItem(
                            deviceInfo: deviceInfo,
                            isTeacher: true,
                            groupName: group.title!,
                            description: group.description!,
                            isFree: group.type == 'free' ? true : false,
                            groupId: group.id!,
                            onDelete: () {
                              defaultAlertDialog(
                                context: context,
                                title: context.tr.remove_group,
                                subTitle: context
                                    .tr.do_you_really_want_to_delete_this_group,
                                buttonConfirm: context.tr.delete,
                                buttonReject: context.tr.back,
                                confirmButtonColor: errorColor,
                                onConfirm: () async {
                                  await cubit.deleteMethod(
                                      group.id!, GroupDeleteType.GROUP);
                                  Navigator.pop(context);
                                },
                                onReject: () {},
                                isLoading:
                                    state is GroupGeneralDeleteLoadingState,
                              );
                            },
                            onEdit: () {
                              navigateTo(
                                  context, CreateGroupScreen(group: group));
                            },
                          );
                        }),
              ),
            ),
          );
        },
      ),
    );
  }
}
