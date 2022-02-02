import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/models/student/auth/student_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/auth/student/register/choose_country_screen.dart';
import 'package:e_learning/modules/profile/add_avatar_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_drop_down.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileTab extends StatefulWidget {
  EditProfileTab({
    Key? key,
    required this.student,
  }) : super(key: key);

  final Student student;

  @override
  _EditProfileTabState createState() => _EditProfileTabState();
}

class _EditProfileTabState extends State<EditProfileTab> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController national = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    AuthCubit.get(context).getAllCountriesAndStages();
    name.text = widget.student.name!;
    email.text = widget.student.email!;
    national.text = widget.student.country!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is GetAllCountriesAndStagesSuccessState) {
          AuthCubit cubit = AuthCubit.get(context);
          cubit.onChangeCountry(widget.student.country);
        }
        if (state is StudentRegisterSuccessState) {
          AuthCubit.get(context).getProfile(true);
          AppCubit.get(context).imageFile = null;
        }
      },
      builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit appCubit = AppCubit.get(context);
            return responsiveWidget(
              responsive: (context, deviceInfo) => SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        AvatarBuildItem(
                          image: "${widget.student.image}",
                          appCubit: appCubit,
                        ),
                        DefaultFormField(
                            controller: name,
                            type: TextInputType.name,
                            labelText: 'الأسم',
                            validation: (name) {
                              if (name == null || name.isEmpty)
                                return 'من فضلك ادخل الاسم';
                              return null;
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        DefaultFormField(
                            controller: email,
                            type: TextInputType.emailAddress,
                            labelText: 'البريد الالكتروني',
                            readOnly: true,
                            validation: (value) {
                              if (value == null || value.isEmpty)
                                return 'من فضلك ادخل الايميل';
                              return null;
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text!.country,
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
                        Row(
                          children: [
                            Expanded(
                              child: DefaultDropDown(
                                label: 'الصف الدراسي',
                                selectedValue: cubit.selectedStageName,
                                validator: (value) =>
                                    value == null ? 'field required' : null,
                                onChanged: (value) {
                                  cubit.onChangeStage(value);
                                },
                                items: List.generate(
                                    cubit.stagesNamesList.length,
                                    (index) => cubit.stagesNamesList[index]
                                        .toString()),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: DefaultDropDown(
                                label: 'الترم الدراسي',
                                selectedValue: cubit.selectedClassName,
                                validator: (value) =>
                                    value == null ? 'field required' : null,
                                onChanged: (value) {
                                  cubit.onChangeClass(value);
                                },
                                items: cubit.classesNameList,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: DefaultProgressButton(
                            buttonState: cubit.studentRegisterState,
                            idleText: 'حفظ',
                            loadingText: 'Loading',
                            failText: text.failed,
                            successText: text.success_sign,
                            onPressed: () {
                              formKey.currentState!.save();
                              if (formKey.currentState!.validate() &&
                                  cubit.selectedCountryName != null) {
                                cubit.studentRegisterAndEdit(
                                  context: context,
                                  type: AuthType.Edit,
                                  model: StudentModel(
                                    name: name.text,
                                    email: widget.student.email!,
                                    countryId: cubit.selectedCountryId!,
                                    classroomId: cubit.selectedClassId!,
                                    avatar: appCubit.imageFile,
                                  ),
                                );
                              } else {
                                showToast(
                                    msg: text.complete_your_data,
                                    state: ToastStates.WARNING);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
