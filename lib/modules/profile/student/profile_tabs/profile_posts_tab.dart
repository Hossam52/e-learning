import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/discuss_tab/group_question_tab.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ProfilePostsTab extends StatefulWidget {
  const ProfilePostsTab({Key? key}) : super(key: key);

  @override
  _ProfilePostsTabState createState() => _ProfilePostsTabState();
}

class _ProfilePostsTabState extends State<ProfilePostsTab> {
  @override
  void initState() {
    GroupCubit.get(context)
        .getAllPostsAndQuestions('share', 0, true, isProfile: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {},
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return responsiveWidget(
          responsive: (_, deviceInfo) => Conditional.single(
            context: context,
            conditionBuilder: (context) => state is! GroupGetPostLoadingState,
            fallbackBuilder: (context) => DefaultLoader(),
            widgetBuilder: (context) => cubit.noPostData
                ? NoDataWidget(
                    text: 'عذرا لا يوجد منشورات',
                    onPressed: () => GroupCubit.get(context)
                        .getAllPostsAndQuestions('share', 0, true,
                            isProfile: true),
                  )
                : GroupStudentTab(
                    deviceInfo: deviceInfo,
                    groupId: 0,
                    cubit: cubit,
                    isQuestion: false,
                    posts: cubit.shareList,
                    isStudent: true,
                  ),
          ),
        );
      },
    );
  }
}
