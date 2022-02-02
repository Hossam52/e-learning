import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../group_build_item.dart';

class MyGroupsTab extends StatefulWidget {
  const MyGroupsTab({Key? key}) : super(key: key);

  @override
  _MyGroupsTabState createState() => _MyGroupsTabState();
}

class _MyGroupsTabState extends State<MyGroupsTab> {
  @override
  void initState() {
    GroupCubit.get(context).getMyGroups(true, GroupType.Student);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {},
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return responsiveWidget(
          responsive: (context, deviceInfo) => Conditional.single(
            context: context,
            conditionBuilder: (context) => state is! GroupsTeacherGetLoadingState,
            fallbackBuilder: (context) => DefaultLoader(),
            widgetBuilder: (context) => cubit.myGroups.isEmpty
                ? NoDataWidget(
                    onPressed: () {
                      cubit.getMyGroups(true, GroupType.Student);
                    },
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                            itemCount: cubit.myGroups.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.7,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              var group = cubit.myGroups[index];
                              return GroupBuildItem(
                                deviceInfo: deviceInfo,
                                isTeacher: false,
                                isFree: group.type == 'free' ? true : false,
                                groupName: group.title!,
                                description: group.description!,
                                groupId: group.id!,
                                onDelete: () {},
                                onEdit: () {},
                              );
                            }),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
