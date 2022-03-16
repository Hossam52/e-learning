import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/auth/teacher/login/teacher_login_screen.dart';
import 'package:e_learning/modules/auth/teacher/register/teacher_register_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeacherChooseAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      extendBodyBehindAppBar: true,
      body: responsiveWidget(responsive: (context, deviceInfo) {
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is RegisterState)
              navigateTo(
                  context,
                  TeacherRegisterScreen(
                    socialUser: state.user,
                  ));
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: deviceInfo.screenHeight * 0.04,
                      ),
                      Image.asset(
                        'assets/images/logoSchool.png',
                        fit: BoxFit.fill,
                        width: deviceInfo.screenwidth * 0.25,
                      ),
                      SizedBox(
                        height: deviceInfo.screenHeight * 0.08,
                      ),
                      Text(
                        text!.sign_in_with_social,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: deviceInfo.screenHeight * 0.04,
                      ),
                      socialButton(
                        assetName: 'assets/images/google.png',
                        onPressed: () {
                          AuthCubit.get(context).googleSignIn(context, false);
                        },
                        text: text.google,
                        isCenter: true,
                        background: Colors.white,
                        border: Colors.black,
                        height: deviceInfo.screenHeight * 0.075,
                      ),
                      SizedBox(
                        height: deviceInfo.screenHeight * 0.04,
                      ),
                      Divider(),
                      SizedBox(
                        height: deviceInfo.screenHeight * 0.04,
                      ),
                      DefaultAppButton(
                        onPressed: () {
                          navigateTo(context, TeacherLoginScreen());
                        },
                        text: text.sign_in_with_email,
                        isLoading: false,
                        textStyle: thirdTextStyle(deviceInfo),
                        isDisabled: false,
                      ),
                      SizedBox(
                        height: deviceInfo.screenHeight * 0.04,
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateTo(context, TeacherRegisterScreen());
                        },
                        child: Text(
                          text.new_to_app,
                          textAlign: TextAlign.center,
                          style: secondaryTextStyle(deviceInfo)
                              .copyWith(fontWeight: FontWeight.w200),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
