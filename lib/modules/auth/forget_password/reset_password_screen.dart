import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key, required this.isStudent}) : super(key: key);

  final bool isStudent;
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmation = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.width;

    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AuthCubit cubit = AuthCubit.get(context);
            return DefaultGestureWidget(
              child: Scaffold(
                appBar: AppBar(),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Text(
                            context.tr.reset_password,
                            style: TextStyle(
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            context.tr.enter_code_to_change_password,
                            // 'أدخل الرمز المرسل إلى بريدك الإلكتروني ، وقم بتغيير كلمة المرور الخاصة بك',
                            style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                          SizedBox(height: height * 0.15),

                          /// Code
                          DefaultFormField(
                            controller: codeController,
                            type: TextInputType.text,
                            labelText: context.tr.code,
                            validation: (email) {
                              if (email == null || email.isEmpty)
                                return context.tr.enter_pin_code;
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),

                          /// password
                          DefaultFormField(
                            hintText: context.tr
                                .enter_new_password, //'ادخل كلمة السر الجديدة',
                            labelText:
                                context.tr.new_password, //'كلمة السر الجديدة',
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            secure: cubit.isSecure,
                            suffix: cubit.suffix,
                            suffixPressed: () =>
                                cubit.changePasswordVisibility(),
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return context.tr
                                    .this_field_is_required; //ذا الحقل مطلوب';
                              } else {
                                return value.length < 6
                                    ? context.tr
                                        .must_more_than // 'يجب ان يكون 6 احرف او اكثر'
                                    : null;
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),

                          /// password Confirmation
                          DefaultFormField(
                            hintText: context
                                .tr.confirm_password, //'تاكيد كلمة السر',
                            labelText: context
                                .tr.confirm_password, //'تاكيد كلمة السر',
                            controller: passwordConfirmation,
                            type: TextInputType.visiblePassword,
                            secure: cubit.isSecure,
                            suffix: cubit.suffix,
                            suffixPressed: () =>
                                cubit.changePasswordVisibility(),
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return context.tr.this_field_is_required;
                                // 'هذا الحقل مطلوب';
                              } else {
                                return passwordConfirmation.text !=
                                        passwordController.text
                                    ? context.tr
                                        .password_not_correct // 'كلمة التى ادخلتها غير صحيحة'
                                    : null;
                              }
                            },
                          ),
                          SizedBox(height: height * 0.08),
                          DefaultProgressButton(
                            buttonState: cubit.resetPasswordButtonState,
                            idleText: context
                                .tr.change_password, // 'تغيير كلمة المرور',
                            loadingText: context.tr.loading, // 'Loading',
                            failText: context.tr.error_happened, // 'حدث خطأ',
                            successText:
                                context.tr.success_register, // 'تم التسجيل',
                            onPressed: () {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                cubit.resetPassword(
                                  context: context,
                                  isStudent: isStudent,
                                  code: codeController.text,
                                  password: passwordController.text,
                                  passwordConfirmation:
                                      passwordConfirmation.text,
                                );
                              }
                            },
                          ),
                        ],
                      ),
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
