import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';
import 'package:e_learning/models/teacher/auth/teacher_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/auth/student/register/choose_country_screen.dart';
import 'package:e_learning/modules/auth/teacher/register/build_subjects_item.dart';
import 'package:e_learning/modules/profile/add_avatar_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeacherEditProfileTab extends StatefulWidget {
  const TeacherEditProfileTab({Key? key, required this.teacher})
      : super(key: key);

  final Teacher teacher;

  @override
  _TeacherEditProfileTabState createState() => _TeacherEditProfileTabState();
}

class _TeacherEditProfileTabState extends State<TeacherEditProfileTab> {
  final TextEditingController name = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController national = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    AuthCubit.get(context).getAllSubjectsData();
    AuthCubit.get(context).getAllCountriesAndStages();
    name.text = widget.teacher.name!;
    email.text = widget.teacher.email!;
    national.text = widget.teacher.country!;
    AuthCubit.get(context).selectedSubjectsList = List.generate(
        widget.teacher.subjects!.length,
        (index) => widget.teacher.subjects![index].name!);
    AuthCubit.get(context).selectedSubjectsId = List.generate(
        widget.teacher.subjects!.length,
        (index) => widget.teacher.subjects![index].id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is TeacherRegisterSuccessState) {
              AuthCubit.get(context).getProfile(false);
              appCubit.imageFile = null;
            }
            if (state is GetAllCountriesAndStagesSuccessState)
              AuthCubit.get(context).onChangeCountry(widget.teacher.country);
          },
          builder: (context, state) {
            var cubit = AuthCubit.get(context);
            return DefaultGestureWidget(
              child: responsiveWidget(responsive: (context, deviceInfo) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AvatarBuildItem(
                            image: '${widget.teacher.image}',
                            appCubit: appCubit,
                          ),
                          DefaultFormField(
                              controller: name,
                              type: TextInputType.name,
                              labelText: text!.name,
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
                              readOnly: true,
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
                            idleText: 'حفظ',
                            loadingText: 'Loading',
                            failText: text.failed,
                            successText: text.success_sign,
                            onPressed: () {
                              formKey.currentState!.save();
                              if (formKey.currentState!.validate() &&
                                  cubit.selectedCountryName != null &&
                                  cubit.selectedSubjectsId.isNotEmpty) {
                                cubit.teacherRegisterAndUpdate(
                                  context: context,
                                  model: TeacherModel(
                                    name: name.text,
                                    email: email.text,
                                    countryId: cubit.selectedCountryId!,
                                    subjects: cubit.selectedSubjectsId,
                                    avatar: appCubit.imageFile,
                                  ),
                                  type: AuthType.Edit,
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
                );
              }),
            );
          },
        );
      },
    );
  }
}
