import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_info_build.dart';
import 'package:e_learning/modules/profile/teacher/teacher_tab_build.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()..getProfile(false),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AuthCubit cubit = AuthCubit.get(context);
          return responsiveWidget(
            responsive: (context, deviceInfo) => Scaffold(
              body: Conditional.single(
                context: context,
                conditionBuilder: (context) => state is! GetProfileLoadingState,
                fallbackBuilder: (context) => DefaultLoader(),
                widgetBuilder: (context) => cubit.noProfileData
                    ? NoDataWidget(onPressed: () => cubit.getProfile(false))
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            /// Profile info
                            TeacherProfileInfoBuild(
                              deviceInfo: deviceInfo,
                              name: cubit.teacherProfileModel!.teacher!.name!,
                              image: cubit.teacherProfileModel!.teacher!.image!,
                              subjects: List.generate(
                                  cubit.teacherProfileModel!.teacher!.subjects!
                                      .length,
                                  (index) => cubit.teacherProfileModel!.teacher!
                                      .subjects![index].name!),
                              rate: cubit.teacherProfileModel!.teacher!
                                  .authStudentRate!
                                  .toDouble(),
                              isStudent: false,
                              isLiked: false,
                              onFollow: (_) {},
                              followCount: 2,
                            ),
                            SizedBox(height: 15),

                            /// Tabs
                            TeacherTabBuild(
                              teacher: cubit.teacherProfileModel!.teacher!,
                              isStudent: false,
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
