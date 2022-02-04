import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/auth/forget_password/forget_password_dialog.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentLoginScreen extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    return BlocProvider.value(
      value: AuthCubit.get(context)..resetLoginButtonToIdleState(),
      child: Scaffold(
        body:
            SafeArea(child: responsiveWidget(responsive: (context, deviceInfo) {
          return BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = AuthCubit.get(context);
              return DefaultGestureWidget(
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  body: responsiveWidget(responsive: (context, deviceInfo) {
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                defaultBackButton(
                                    context, deviceInfo.screenHeight),
                                Text(
                                  text!.sign_in,
                                  style: primaryTextStyle(deviceInfo)
                                      .copyWith(color: primaryColor),
                                ),
                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.05,
                                ),
                                DefaultFormField(
                                    controller: email,
                                    type: TextInputType.name,
                                    labelText: text.email,
                                    validation: (email) {
                                      if (email == null || email.isEmpty)
                                        return text.email_validate;
                                      return null;
                                    }),
                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.03,
                                ),
                                DefaultFormField(
                                  controller: password,
                                  type: TextInputType.text,
                                  labelText: text.password,
                                  suffix: cubit.suffix,
                                  suffixPressed: () {
                                    cubit.changePasswordVisibility();
                                  },
                                  validation: (password) {
                                    if (password == null || password.isEmpty)
                                      return text.password_validate;
                                    return null;
                                  },
                                  secure: cubit.isSecure,
                                ),
                                SizedBox(
                                  height: deviceInfo.screenHeight * 0.06,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DefaultProgressButton(
                                      buttonState: cubit.loginButtonState,
                                      idleText: text.sign_in,
                                      loadingText: 'Loading',
                                      failText: text.failed,
                                      successText: text.success_sign,
                                      onPressed: () {
                                        formKey.currentState!.save();
                                        if (formKey.currentState!.validate()) {
                                          cubit.login(
                                            isStudent: true,
                                            context: context,
                                            email: email.text,
                                            password: password.text,
                                          );
                                        }
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ForgetPasswordDialog(
                                            deviceInfo: deviceInfo,
                                            isStudent: true,
                                          ),
                                        );
                                      },
                                      child: Text(text.forget_password),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          );
        })),
      ),
    );
  }
}
