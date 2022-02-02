import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_build_item.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class TeacherGroupsProfileTab extends StatefulWidget {
  const TeacherGroupsProfileTab({Key? key, required this.teacherId})
      : super(key: key);

  final int teacherId;

  @override
  _TeacherGroupsProfileTabState createState() =>
      _TeacherGroupsProfileTabState();
}

class _TeacherGroupsProfileTabState extends State<TeacherGroupsProfileTab> {
  @override
  void initState() {
    GroupCubit.get(context)
        .getTeacherDataById(widget.teacherId, TeacherDataType.groups);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {
        if (state is GroupStudentToggleJoinSuccessState) {
          GroupCubit.get(context)
              .getTeacherDataById(widget.teacherId, TeacherDataType.groups);
        }
      },
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return responsiveWidget(
          responsive: (_, deviceInfo) => Conditional.single(
            context: context,
            conditionBuilder: (context) =>
                state is! GroupsTeacherGetLoadingState,
            fallbackBuilder: (context) => DefaultLoader(),
            widgetBuilder: (context) => cubit.teacherGroupsByIdModel == null
                ? NoDataWidget(
                    onPressed: () => cubit.getTeacherDataById(
                        widget.teacherId, TeacherDataType.groups))
                : GridView.builder(
                    itemCount: cubit.teacherGroupsByIdModel!.groups!.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.7,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      var group = cubit.teacherGroupsByIdModel!.groups![index];
                      return GroupBuildItem(
                        deviceInfo: deviceInfo,
                        isTeacher: false,
                        isFree: group.type == 'free' ? true : false,
                        groupName: group.title!,
                        description: group.description!,
                        groupId: group.id!,
                        isJoined: group.isJoined,
                        onDelete: () {},
                        onEdit: () {},
                      );
                    }),
          ),
        );
      },
    );
  }
}
