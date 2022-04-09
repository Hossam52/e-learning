import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';
import 'package:e_learning/modules/profile/cubit/profile_cubit.dart';
import 'package:e_learning/modules/profile/cubit/profile_states.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_info_build.dart';
import 'package:e_learning/modules/profile/teacher/teacher_tab_build.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/student/cubit/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class TeacherProfileView extends StatefulWidget {
  const TeacherProfileView({
    Key? key,
    // required this.teacher,
    required this.isAdd,
    required this.cubit,
    this.teacherId,
  }) : super(key: key);

  // final Teacher teacher;
  final bool isAdd;
  final int? teacherId;
  final StudentCubit cubit;

  @override
  _TeacherProfileViewState createState() => _TeacherProfileViewState();
}

class _TeacherProfileViewState extends State<TeacherProfileView> {
  TeacherDataModel? teacherDataModel;
  @override
  void initState() {
    // getTeacherById();
    // if (widget.teacher != null)
    //   StudentCubit.get(context).initIsFollowed(
    //       widget.teacher.authStudentFollow!, widget.teacher.followersCount!);
    super.initState();
  }

  // Teacher get teacher {
  //   if (widget.teacher != null)
  //     return widget.teacher;
  //   else {
  //     if (teacherDataModel != null) return teacherDataModel!.teacher!;

  //   }
  // }

  // void getTeacherById() async {
  //   await ProfileCubit.instance(context).getProfile(widget.teacherId!, false);

  //   teacherDataModel = ProfileCubit.instance(context).teacherByIdModel;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfile(widget.teacherId!, false),
      child: Builder(builder: (context) {
        return BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (oldState, state) {
            if (state is ProfileSuccessState) {
              final teacher =
                  ProfileCubit.instance(context).teacherByIdModel!.teacher!;
              StudentCubit.get(context).initIsFollowed(
                  teacher.authStudentFollow!, teacher.followersCount!);
            }
          },
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return DefaultLoader();
            }
            if (state is ProfileErrorState) return noData('No data found');
            final teacher =
                ProfileCubit.instance(context).teacherByIdModel!.teacher!;

            return BlocConsumer<StudentCubit, StudentStates>(
              listener: (context, state) {
                if (state is ToggleFollowSuccessState) {
                  widget.cubit.getMyFollowingList(widget.isAdd);
                }
              },
              builder: (context, state) {
                print('From teacher profiloe view');
                StudentCubit cubit = StudentCubit.get(context);
                return responsiveWidget(
                  responsive: (_, deviceInfo) => Scaffold(
                    appBar: AppBar(
                      title: Text(
                        context.tr.personal_profile_teacher,
                        style: TextStyle(color: Colors.white),
                      ),
                      centerTitle: true,
                      backgroundColor: primaryColor,
                      leading: defaultBackButton(
                        context,
                        deviceInfo.screenHeight,
                        color: Colors.white,
                      ),
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: Brightness.light,
                        statusBarIconBrightness: Brightness.light,
                      ),
                    ),
                    body: ProgressHUD(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TeacherProfileInfoBuild(
                              teacherId: teacher.id!,
                              deviceInfo: deviceInfo,
                              name: teacher.name!,
                              subjects: List.generate(teacher.subjects!.length,
                                  (index) => teacher.subjects![index].name!),
                              image: teacher.image!,
                              rate: teacher.authStudentRate!.toDouble(),
                              isStudent: true,
                              isLiked: cubit.isFollowed,
                              followCount: cubit.followCount,
                              onFollow: (isFollowed) {
                                cubit.toggleTeacherFollow(context, teacher.id!);
                                AppCubit.get(context)
                                    .getHighRateTeachersList(true);
                              },
                            ),
                            SizedBox(height: 15),

                            /// Tabs
                            TeacherTabBuild(
                              teacher: teacher,
                              isStudent: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
