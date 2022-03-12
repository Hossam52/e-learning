import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/following_list/teacher_view/teacher_profile_test_build_item.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class TeacherTestsProfileTab extends StatefulWidget {
  const TeacherTestsProfileTab({Key? key, required this.teacherId})
      : super(key: key);

  final int teacherId;

  @override
  State<TeacherTestsProfileTab> createState() => _TeacherTestsProfileTabState();
}

class _TeacherTestsProfileTabState extends State<TeacherTestsProfileTab> {
  @override
  void initState() {
    GroupCubit.get(context)
        .getTeacherDataById(widget.teacherId, TeacherDataType.tests);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {},
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => cubit.isTeacherDataLoading == false,
          fallbackBuilder: (context) => DefaultLoader(),
          widgetBuilder: (context) => cubit.teacherTests.isEmpty
              ? noData(context.tr.no_tests)
              : ListView.builder(
                  itemCount: cubit.teacherTests.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    var test = cubit.teacherTests[index];
                    return TeacherProfileTestBuildItem(test: test);
                  },
                ),
        );
      },
    );
  }
}
