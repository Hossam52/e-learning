import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
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
                          SizedBox(height: height * 0.05,),
                          Text(
                            'إعادة تعيين كلمة المرور',
                            style: TextStyle(
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: height * 0.02,),
                          Text(
                            'أدخل الرمز المرسل إلى بريدك الإلكتروني ، وقم بتغيير كلمة المرور الخاصة بك',
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
                            labelText: 'الرمز',
                            validation: (email) {
                              if (email == null || email.isEmpty)
                                return 'من فضلك ادخل الرمز';
                              return null;
                            },
                          ),
                          SizedBox(height: height * 0.05,),
                          /// password
                          DefaultFormField(
                            hintText: 'ادخل كلمة السر الجديدة',
                            labelText: 'كلمة السر الجديدة',
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            secure: cubit.isSecure,
                            suffix: cubit.suffix,
                            suffixPressed: () => cubit.changePasswordVisibility(),
                            validation: (value) {
                              if(value == null || value.isEmpty){
                                return 'هذا الحقل مطلوب';
                              } else {
                                return value.length < 6 ?
                                'يجب ان يكون 6 احرف او اكثر'
                                    : null;
                              }
                            },
                          ),
                          SizedBox(height: height * 0.05,),

                          /// password Confirmation
                          DefaultFormField(
                            hintText: 'تاكيد كلمة السر',
                            labelText: 'تاكيد كلمة السر',
                            controller: passwordConfirmation,
                            type: TextInputType.visiblePassword,
                            secure: cubit.isSecure,
                            suffix: cubit.suffix,
                            suffixPressed: () => cubit.changePasswordVisibility(),
                            validation: (value) {
                              if(value == null || value.isEmpty){
                                return 'هذا الحقل مطلوب';
                              } else {
                                return passwordConfirmation.text != passwordController.text ?
                                'كلمة التى ادخلتها غير صحيحة'
                                    : null;
                              }
                            },
                          ),
                          SizedBox(height: height * 0.08),
                          DefaultProgressButton(
                            buttonState: cubit.resetPasswordButtonState,
                            idleText: 'تغيير كلمة المرور',
                            loadingText: 'Loading',
                            failText: 'حدث خطأ',
                            successText: 'تم التسجيل',
                            onPressed: () {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                cubit.resetPassword(
                                  context: context,
                                  isStudent: isStudent,
                                  code: codeController.text,
                                  password: passwordController.text,
                                  passwordConfirmation: passwordConfirmation.text,
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
