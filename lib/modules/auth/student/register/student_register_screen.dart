import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/student/auth/student_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/auth/student/login/student_login_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'choose_country_screen.dart';

// ignore: must_be_immutable
class StudentRegisterScreen extends StatelessWidget {
  var name = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var national = TextEditingController();
  var classStudy = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var status = TextEditingController();

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
                                  navigateTo(context, StudentLoginScreen());
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
                          defaultDropdownButtonFormField(
                            context: context,
                            label: text.education_stage,
                            selectedValue: cubit.selectedStageName,
                            onChanged: (value) {
                              cubit.onChangeStage(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return text.general_validate;
                              return null;
                            },
                            deviceInfo: deviceInfo,
                            items: cubit.stagesNamesList
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          defaultDropdownButtonFormField(
                            context: context,
                            label: text.classroom,
                            selectedValue: cubit.selectedClassName,
                            onChanged: (value) {
                              cubit.onChangeClass(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return text.general_validate;
                              return null;
                            },
                            deviceInfo: deviceInfo,
                            items: cubit.classesNameList
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          DefaultProgressButton(
                            buttonState: cubit.studentRegisterState,
                            idleText: text.create_account,
                            loadingText: context.tr.loading, // 'Loading',
                            failText: text.failed,
                            successText: text.success_sign,
                            onPressed: () {
                              formKey.currentState!.save();
                              if (formKey.currentState!.validate() &&
                                  cubit.selectedCountryName != null) {
                                cubit.studentRegisterAndEdit(
                                  context: context,
                                  type: AuthType.Register,
                                  model: StudentModel(
                                    name: name.text,
                                    email: email.text,
                                    password: password.text,
                                    passwordConfirmation: confirmPassword.text,
                                    countryId: cubit.selectedCountryId!,
                                    classroomId: cubit.selectedClassId!,
                                  ),
                                );
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
