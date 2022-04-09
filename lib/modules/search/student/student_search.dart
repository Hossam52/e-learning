import 'package:e_learning/modules/following_list/teacher_view/teacher_profile_view.dart';
import 'package:e_learning/modules/following_list/teachers_build_item.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/student/group_info_screen.dart';
import 'package:e_learning/modules/groups/student/group_tabs/discover_group_build_item.dart';
import 'package:e_learning/modules/search/student/no_data_found_screen.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/student/cubit/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/deafult_app_search_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentSearchScreen extends StatelessWidget {
  StudentSearchScreen({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentCubit(),
      child: BlocConsumer<StudentCubit, StudentStates>(
        listener: (context, state) {},
        builder: (context, state) {
          StudentCubit cubit = StudentCubit.get(context);
          return DefaultGestureWidget(
            child: Scaffold(
              appBar: AppBar(
                title: Container(
                  height: 55,
                  child: DefaultAppSearchField(
                    controller: searchController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        cubit.searchStudent(value);
                      }
                    },
                  ),
                ),
                elevation: 2,
                toolbarHeight: 75,
              ),
              body: state is SearchStudentLoadingState
                  ? DefaultLoader()
                  : Conditional.single(
                      context: context,
                      conditionBuilder: (context) => cubit.searchModel != null,
                      fallbackBuilder: (context) => Center(
                          child: Text(context.tr.search_any_thing,
                              style: subTextStyle(null))),
                      widgetBuilder: (context) => state
                              is SearchStudentNoDataState
                          ? NoResultFoundScreen()
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(context.tr.teachers),
                                  ),
                                  SizedBox(
                                    height: 160.h,
                                    child: ListView.separated(
                                      itemCount:
                                          cubit.searchModel!.teachers!.length,
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      physics: const BouncingScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(width: 20),
                                      itemBuilder: (context, index) {
                                        var teacher =
                                            cubit.searchModel!.teachers![index];
                                        return SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: TeachersBuildItem(
                                            image: teacher.image!,
                                            name: teacher.name!,
                                            isAdd: true,
                                            subjects: List.generate(
                                                teacher.subjects!.length,
                                                (index) => teacher
                                                    .subjects![index].name),
                                            country: teacher.country!,
                                            rate: teacher.authStudentRate!
                                                .toDouble(),
                                            onTap: () async {
                                              await navigateTo(
                                                  context,
                                                  TeacherProfileView(
                                                    // teacher: teacher,
                                                    teacherId: teacher.id,
                                                    isAdd: true,
                                                    cubit: cubit,
                                                  ));
                                              cubit.searchStudent(
                                                  searchController.text);
                                              print('After navigation');
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(context.tr.groups),
                                  ),
                                  ListView.builder(
                                    itemCount: cubit.searchModel!.groups!
                                        .groupsData!.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var group = cubit.searchModel!.groups!
                                          .groupsData![index];
                                      return DiscoverGroupBuildItem(
                                        cubit: GroupCubit.get(context),
                                        groupId: group.id!,
                                        groupName: group.title!,
                                        teacherName: 'teacher',
                                        subjectName: "group.subject!",
                                        isFree:
                                            group.type == 'free' ? true : false,
                                        isJoined: group.isJoined!,
                                        onTap: () {
                                          navigateTo(context,
                                              GroupInfoScreen(group: group));
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
