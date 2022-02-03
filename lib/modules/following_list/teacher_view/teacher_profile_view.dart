import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_info_build.dart';
import 'package:e_learning/modules/profile/teacher/teacher_tab_build.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/student/cubit/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherProfileView extends StatefulWidget {
  const TeacherProfileView({
    Key? key,
    required this.teacher,
    required this.isAdd,
    required this.cubit,
  }) : super(key: key);

  final Teacher teacher;
  final bool isAdd;
  final StudentCubit cubit;

  @override
  _TeacherProfileViewState createState() => _TeacherProfileViewState();
}

class _TeacherProfileViewState extends State<TeacherProfileView> {
  @override
  void initState() {
    StudentCubit.get(context).initIsFollowed(
        widget.teacher.authStudentFollow!, widget.teacher.followersCount!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                'الملف الشخصى للمعلم',
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TeacherProfileInfoBuild(
                    deviceInfo: deviceInfo,
                    name: widget.teacher.name!,
                    subjects: List.generate(widget.teacher.subjects!.length,
                        (index) => widget.teacher.subjects![index].name!),
                    image: widget.teacher.image!,
                    rate: widget.teacher.authStudentRate!.toDouble(),
                    isStudent: true,
                    isLiked: cubit.isFollowed,
                    followCount: cubit.followCount,
                    onFollow: (isFollowed) {
                      cubit.toggleTeacherFollow(widget.teacher.id!);
                    },
                  ),
                  SizedBox(height: 15),

                  /// Tabs
                  TeacherTabBuild(
                    teacher: widget.teacher,
                    isStudent: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
