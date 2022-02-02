import 'package:e_learning/modules/auth/student/login/student_login_screen.dart';
import 'package:e_learning/modules/auth/student/register/student_register_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentChooseAuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      extendBodyBehindAppBar: true,
      body: responsiveWidget(responsive: (context, deviceInfo) {
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
                    onPressed: () {},
                    text: text.google,
                    isCenter: true,
                    background: Colors.white,
                    border: Colors.black,
                    height: deviceInfo.screenHeight * 0.075,
                  ),
                  SizedBox(
                    height: deviceInfo.screenHeight * 0.03,
                  ),
                  socialButton(
                    assetName: 'assets/images/facebook.png',
                    onPressed: () {},
                    text: text.facebook,
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
                      navigateTo(context, StudentLoginScreen());
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
                      navigateTo(context, StudentRegisterScreen());
                    },
                    child: Text(
                      text.new_to_app,
                      textAlign: TextAlign.center,
                      style: secondaryTextStyle(deviceInfo).copyWith(
                        fontWeight: FontWeight.w200
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
