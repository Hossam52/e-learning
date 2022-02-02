import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/teacher/results/results_build_item.dart';
import 'package:e_learning/modules/teacher/results/results_view/results_view_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ResultsTab extends StatefulWidget {
  ResultsTab({Key? key, required this.deviceInfo}) : super(key: key);

  final DeviceInformation deviceInfo;

  @override
  _ResultsTabState createState() => _ResultsTabState();
}

class _ResultsTabState extends State<ResultsTab> {

  @override
  void initState() {
    GroupCubit.get(context).getMyGroups(false, GroupType.Teacher);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context ,state) {},
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => state is! GroupsTeacherGetLoadingState,
          fallbackBuilder: (context) => DefaultLoader(),
          widgetBuilder: (context) => cubit.noGroupsData
              ? NoDataWidget(onPressed: () => cubit.getMyGroups(false, GroupType.Teacher))
              : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cubit.groupResponseModel!.groups!.length,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  itemBuilder: (context, index)  {
                    var group = cubit.groupResponseModel!.groups![index];
                    return ResultsBuildItem(
                      title: group.title!,
                      subtitle1: group.stage!,
                      subtitle2: group.classroom!,
                      isDismissible: false,
                      onTap: () {
                        navigateTo(context, ResultViewScreen(groupId: group.id!));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
