// ignore_for_file: must_be_immutable

import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/teacher/auth/teacher_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/auth/student/register/choose_country_screen.dart';
import 'package:e_learning/modules/auth/teacher/login/teacher_login_screen.dart';
import 'package:e_learning/modules/auth/teacher/register/build_subjects_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/network/services/firebase_services/firebase_auth.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeacherRegisterScreen extends StatefulWidget {
  // ignore: empty_constructor_bodies
  TeacherRegisterScreen({Key? key, this.socialUser}) : super(key: key) {}
  SocialUser? socialUser;

  @override
  _TeacherRegisterScreenState createState() => _TeacherRegisterScreenState();
}

class _TeacherRegisterScreenState extends State<TeacherRegisterScreen> {
  bool get isOrninaryUser => widget.socialUser == null;

  final TextEditingController name = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  final TextEditingController national = TextEditingController();

  final TextEditingController classStudy = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    AuthCubit.get(context).getAllSubjectsData();
    if (!isOrninaryUser) {
      name.text = widget.socialUser!.name;
      email.text = widget.socialUser!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return DefaultGestureWidget(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            body: responsiveWidget(responsive: (_, deviceInfo) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          defaultBackButton(context, deviceInfo.screenHeight),
                          Text(
                            text!.create_account,
                            style: primaryTextStyle(deviceInfo)
                                .copyWith(color: primaryColor),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(text.have_account,
                                  style: thirdTextStyle(deviceInfo).copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  )),
                              TextButton(
                                onPressed: () {
                                  navigateTo(context, TeacherLoginScreen());
                                },
                                child: Text(
                                  text.sign_in_here,
                                  style: thirdTextStyle(deviceInfo).copyWith(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DefaultFormField(
                              controller: name,
                              type: TextInputType.name,
                              labelText: text.name,
                              validation: (name) {
                                if (name == null || name.isEmpty)
                                  return text.name_validate;
                                return null;
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          DefaultFormField(
                              isClickable: isOrninaryUser,
                              controller: email,
                              type: TextInputType.emailAddress,
                              labelText: text.email,
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return text.email_validate;
                                } else {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)
                                      ? null
                                      : text.email_validate2;
                                }
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          if (isOrninaryUser)
                            DefaultFormField(
                                suffix: cubit.suffix,
                                suffixPressed: () {
                                  cubit.changePasswordVisibility();
                                },
                                controller: password,
                                type: TextInputType.visiblePassword,
                                labelText: text.password,
                                secure: cubit.isSecure,
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return text.password_validate;
                                  } else {
                                    return value.length < 6
                                        ? text.password_validate2
                                        : null;
                                  }
                                }),
                          SizedBox(
                            height: 10,
                          ),
                          if (isOrninaryUser)
                            DefaultFormField(
                                suffix: cubit.suffix,
                                suffixPressed: () {
                                  cubit.changePasswordVisibility();
                                },
                                controller: confirmPassword,
                                type: TextInputType.visiblePassword,
                                labelText: text.password_confirmation,
                                secure: cubit.isSecure,
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return text.password_confirmation_validate;
                                  } else {
                                    return confirmPassword.text != password.text
                                        ? text.password_confirmation_validate2
                                        : null;
                                  }
                                }),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text.country,
                              ),
                              InkWell(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  navigateTo(
                                      context,
                                      ChooseCountryScreen(
                                        cubit: cubit,
                                        countries: cubit.countryNamesList,
                                      ));
                                },
                                child: DefaultFormField(
                                  validation: (value) {},
                                  controller: national,
                                  type: TextInputType.text,
                                  labelText: cubit.selectedCountryName != null
                                      ? '${cubit.selectedCountryName}'
                                      : text.choose_country,
                                  suffix: Icons.arrow_forward_ios,
                                  size: 15,
                                  isClickable: false,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      text.subject,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                Conditional.single(
                                  context: context,
                                  conditionBuilder: (context) =>
                                      state is! GetAllSubjectsLoadingState,
                                  fallbackBuilder: (context) => Container(
                                      width: 25,
                                      height: 25,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      )),
                                  widgetBuilder: (context) => Container(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Wrap(
                                        spacing: 6.0,
                                        runSpacing: 6.0,
                                        alignment: WrapAlignment.start,
                                        children: cubit.subjectsNamesList
                                            .map((item) => BuildSubjectsItem(
                                                  label: item,
                                                  color: backgroundColor,
                                                  deviceInfo: deviceInfo,
                                                ))
                                            .toList()
                                            .cast<Widget>(),
                                      ),
                                    ),
                                  ),
                                ),
                                if (cubit.selectedSubjectsList.isEmpty)
                                  Row(
                                    children: [
                                      Text(
                                        text.choose_at_least_subject,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: errorColor),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          DefaultProgressButton(
                            buttonState: cubit.teacherRegisterState,
                            idleText: text.create_account,
                            loadingText: context.tr.loading, // 'Loading',
                            failText: text.failed,
                            successText: text.success_sign,
                            onPressed: () {
                              formKey.currentState!.save();
                              if (formKey.currentState!.validate() &&
                                  cubit.selectedCountryName != null &&
                                  cubit.selectedSubjectsId.isNotEmpty) {
                                final model = TeacherModel(
                                  name: name.text,
                                  email: email.text,
                                  password: password.text,
                                  passwordConfirmation: confirmPassword.text,
                                  countryId: cubit.selectedCountryId!,
                                  subjects: cubit.selectedSubjectsId,
                                );
                                if (!isOrninaryUser) {
                                  cubit.teacherSocialRegister(
                                      context: context,
                                      model: model,
                                      socialId: widget.socialUser!.id);
                                } else
                                  cubit.teacherRegisterAndUpdate(
                                      context: context,
                                      type: AuthType.Register,
                                      model: model);
                              } else {
                                showToast(
                                    msg: text.complete_your_data,
                                    state: ToastStates.WARNING);
                              }
                            },
                          ),
                          SizedBox(height: 35),
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
  }
}
