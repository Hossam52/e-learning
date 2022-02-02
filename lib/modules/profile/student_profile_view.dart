import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/profile/student/student_profile_info_build.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/student/cubit/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class StudentProfileView extends StatefulWidget {
  StudentProfileView({
    Key? key,
    this.student,
    this.id,
    required this.isFriend,
  }) : super(key: key);

  final int? id;
  Student? student;
  final bool isFriend;

  @override
  State<StudentProfileView> createState() => _StudentProfileViewState();
}

class _StudentProfileViewState extends State<StudentProfileView> {
  @override
  void initState() {
    if (widget.student == null) {
      AuthCubit.get(context).getProfileById(widget.id!, true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is GetProfileSuccessState) {
          widget.student = AuthCubit.get(context).studentProfileModel!.student;
        }
      },
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return BlocConsumer<StudentCubit, StudentStates>(
          listener: (context, state) {},
          builder: (context, state) {
            StudentCubit cubit = StudentCubit.get(context);
            return responsiveWidget(
              responsive: (_, deviceInfo) {
                return Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      state is! GetProfileLoadingState,
                  fallbackBuilder: (context) => DefaultLoader(),
                  widgetBuilder: (context) => state is GetProfileErrorState
                      ? NoDataWidget(
                          onPressed: () =>
                              authCubit.getProfileById(widget.id!, true))
                      : Scaffold(
                          appBar: AppBar(
                            title: Text(
                              'الملف الشخصى',
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
                          body: Column(
                            children: [
                              StudentProfileInfoBuild(
                                deviceInfo: deviceInfo,
                                image: "${widget.student!.image}",
                                name: "${widget.student!.name}",
                                points: "${widget.student!.points}",
                                code: "${widget.student!.code}",
                                authType: authType,
                                trailing: defaultMaterialIconButton(
                                  text: widget.isFriend ? 'حذف' : 'إضافة كصديق',
                                  icon: widget.isFriend
                                      ? Icons.person_remove
                                      : Icons.person_add,
                                  backgroundColor: widget.isFriend
                                      ? errorColor
                                      : Colors.white,
                                  textColor: widget.isFriend
                                      ? Colors.white
                                      : primaryColor,
                                  isLoading: cubit.addFriendWithCodeLoading,
                                  onPressed: () {
                                    cubit.addAndRemoveFriendWithCode(
                                      code: widget.student!.code!,
                                      context: context,
                                      isAdd: !widget.isFriend,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            );
          },
        );
      },
    );
  }
}
