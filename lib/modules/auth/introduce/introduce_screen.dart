import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/auth/student/choose_auth/student_choose_auth_screen.dart';
import 'package:e_learning/modules/auth/teacher/choose_auth/teacher_choose_auth_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'build_introduce_item.dart';

class IntroduceScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
          AuthCubit cubit = AuthCubit.get(context);
          return Scaffold(
            backgroundColor: backgroundColor,
            body: SafeArea(
              child: responsiveWidget(responsive: (context, deviceInfo) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: deviceInfo.screenHeight * 0.04,
                        ),
                        Image.asset(
                          'assets/images/logoSchool.png',
                          fit: BoxFit.fill,
                          height: deviceInfo.screenHeight * 0.09,
                        ),
                        SizedBox(
                          height: deviceInfo.screenHeight * 0.08,
                        ),
                        Text(
                          text!.who_you_are,
                          style: secondaryTextStyle(deviceInfo).copyWith(
                              color: Colors.black87, fontWeight: FontWeight.w500)
                        ),
                        SizedBox(
                          height: deviceInfo.screenHeight * 0.04,
                        ),
                        BuildIntroduceItem(
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/teacher.png',
                                fit: BoxFit.fill,
                                width: deviceInfo.screenwidth * 0.24,
                              ),
                              Spacer(),
                              Text(
                                text.teacher,
                                style: secondaryTextStyle(deviceInfo).copyWith(
                                  color: cubit.isTeacher ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                          deviceInformation: deviceInfo,
                          backgroundColorContainer: cubit.isTeacher
                              ? primaryColor
                              : Colors.white,
                          onPressed: () {
                            cubit.chooseTeacherType();
                          },
                        ),
                        BuildIntroduceItem(
                          child: Row(
                            children: [
                              Text(
                                text.student,
                                style: secondaryTextStyle(deviceInfo).copyWith(
                                  color: cubit.isStudent ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              Spacer(),
                              Image.asset(
                                'assets/images/student.png',
                                fit: BoxFit.fill,
                                width: deviceInfo.screenwidth * 0.3,
                              ),
                            ],
                          ),
                          deviceInformation: deviceInfo,
                          backgroundColorContainer: cubit.isStudent
                              ? primaryColor
                              : Colors.white,
                          onPressed: () {
                            cubit.chooseStudentType();
                          },
                        ),
                        SizedBox(
                          height: deviceInfo.screenHeight * 0.06,
                        ),
                        Align(
                          alignment: Alignment.topRight,

                          child: DefaultAppButton(
                            onPressed: () {
                              if(cubit.isStudent) {
                                navigateTo(context, StudentChooseAuthScreen());
                              } else {
                                navigateTo(context, TeacherChooseAuthScreen());
                              }
                            },
                            text: text.next,
                            isLoading: false,
                            textStyle: thirdTextStyle(deviceInfo),
                            isDisabled: cubit.isDisable,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
