import 'package:e_learning/modules/following_list/teacher_view/teacher_profile_view.dart';
import 'package:e_learning/modules/following_list/teachers_build_item.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/student/cubit/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class TeachersTab extends StatefulWidget {
  const TeachersTab({Key? key, required this.controller, required this.isAdd})
      : super(key: key);

  final bool isAdd;
  final TextEditingController controller;

  @override
  _TeachersTabState createState() => _TeachersTabState();
}

class _TeachersTabState extends State<TeachersTab> {
  @override
  void initState() {
    StudentCubit.get(context).getMyFollowingList(widget.isAdd);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (_, deviceInfo) => BlocConsumer<StudentCubit, StudentStates>(
        listener: (context, state) {},
        builder: (context, state) {
          StudentCubit cubit = StudentCubit.get(context);
          return Conditional.single(
            context: context,
            conditionBuilder: (context) => state is! FollowingListLoadingState,
            fallbackBuilder: (context) => DefaultLoader(),
            widgetBuilder: (context) => state is FollowingListErrorState
                ? NoDataWidget(
                    onPressed: () => cubit.getMyFollowingList(widget.isAdd))
                : Column(
                    children: [
                      Expanded(
                        child: cubit.studentFollowingListModel!.teachers!.data!
                                .isEmpty
                            ? noData('لا يوجد معلمين')
                            : ListView.builder(
                                itemCount: widget.isAdd
                                    ? cubit.teachersInClassList.length
                                    : cubit.followingList.length,
                                padding: EdgeInsets.all(22),
                                itemBuilder: (context, index) {
                                  var teacher = widget.isAdd
                                      ? cubit.teachersInClassList[index]
                                      : cubit.followingList[index];
                                  return TeachersBuildItem(
                                    isAdd: widget.isAdd,
                                    name: teacher.name!,
                                    image: teacher.image!,
                                    country: teacher.country!,
                                    rate: teacher.authStudentRate!.toDouble(),
                                    subjects: List.generate(
                                        teacher.subjects!.length,
                                        (index) =>
                                            teacher.subjects![index].name),
                                    onTap: () {
                                      navigateTo(context, TeacherProfileView(
                                        teacher: teacher,
                                        isAdd: widget.isAdd,
                                        cubit: cubit,
                                      ));
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
