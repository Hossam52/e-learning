import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/profile/student/tabs_build_item.dart';
import 'package:e_learning/modules/profile/student/student_profile_info_build.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()..getProfile(true),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AuthCubit cubit = AuthCubit.get(context);
          return ProgressHUD(
            child: responsiveWidget(
              responsive: (_, deviceInfo) {
                return Scaffold(
                  body: Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        state is! GetProfileLoadingState,
                    fallbackBuilder: (context) => DefaultLoader(),
                    widgetBuilder: (context) {
                      return cubit.noProfileData
                          ? NoDataWidget(
                              text: 'عذرا لا يوجد بيانات',
                              onPressed: () {
                                cubit.getProfile(true);
                              },
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  /// Profile info
                                  StudentProfileInfoBuild(
                                    deviceInfo: deviceInfo,
                                    authType: authType,
                                    student:
                                        cubit.studentProfileModel!.student!,
                                    isMe: true,
                                  ),

                                  /// Tabs
                                  TabsBuildItem(
                                    student:
                                        cubit.studentProfileModel!.student!,
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
