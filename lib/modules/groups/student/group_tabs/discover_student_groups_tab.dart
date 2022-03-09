import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_info_screen.dart';
import 'package:e_learning/modules/groups/student/group_tabs/discover_group_build_item.dart';
import 'package:e_learning/modules/student/student_filter_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscoverStudentGroupsTab extends StatefulWidget {
  const DiscoverStudentGroupsTab({Key? key}) : super(key: key);

  @override
  _DiscoverStudentGroupsTabState createState() =>
      _DiscoverStudentGroupsTabState();
}

class _DiscoverStudentGroupsTabState extends State<DiscoverStudentGroupsTab> {
  @override
  void initState() {
    final appCubit = AppCubit.get(context);
    if (appCubit.subjectsModel == null) {
      appCubit.getTeacherAndStudentSubjects(true);
    }
    GroupCubit.get(context).discoverGroupsBySubjectId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {},
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return responsiveWidget(
            responsive: (context, deviceInfo) =>
                BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
                  return Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        state is! GetSubjectsLoadingState,
                    fallbackBuilder: (context) => DefaultLoader(),
                    widgetBuilder: (context) => SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: StudentFilterBuildItem(
                              defaultSelected: GroupCubit.get(context)
                                  .selectedSubjectNameToGetDiscoverGroups,
                              subjects:
                                  AppCubit.get(context).subjectsModel!.subjects,
                            ),
                          ),
                          SizedBox(height: 22.h),
                          Conditional.single(
                            context: context,
                            conditionBuilder: (context) =>
                                state is! GroupsBySubjectIDGetLoadingState,
                            fallbackBuilder: (context) => DefaultLoader(),
                            widgetBuilder: (context) => cubit
                                    .discoverGroups.isEmpty
                                ? NoDataWidget(
                                    onPressed: () {
                                      cubit.discoverGroupsBySubjectId();
                                    },
                                  )
                                : ListView.builder(
                                    itemCount: cubit.discoverGroups.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    itemBuilder: (context, index) {
                                      var group = cubit.discoverGroups[index];
                                      return DiscoverGroupBuildItem(
                                        cubit: cubit,
                                        groupId: group.id!,
                                        groupName: group.title!,
                                        teacherName:
                                            group.teacher!.name ?? 'teacher',
                                        subjectName: group.subject!,
                                        isFree:
                                            group.type == 'free' ? true : false,
                                        isJoined:
                                            cubit.joinedGroupMap[group.id!]!,
                                        onTap: () {
                                          navigateTo(context,
                                              GroupInfoScreen(group: group));
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                }));
      },
    );
  }
}
