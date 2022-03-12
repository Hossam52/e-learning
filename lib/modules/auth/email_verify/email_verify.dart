import 'dart:async';

import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class EmailVerifyScreen extends StatelessWidget {
  EmailVerifyScreen({Key? key, required this.email, required this.isStudent})
      : super(key: key);
  final String email;
  final bool isStudent;

  TextEditingController codeController = TextEditingController();

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is VerifySuccessState) {
              if (AuthCubit.get(context).hasVerifyError) {
                errorController.add(ErrorAnimationType.shake);
              }
            }
          },
          builder: (context, state) {
            AuthCubit cubit = AuthCubit.get(context);

            return Scaffold(
              body: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.08),
                        Container(
                          width: double.infinity,
                          child: SvgPicture.asset(
                            'assets/images/mail-sent.svg',
                            semanticsLabel: 'home work',
                            height: height * 0.3,
                          ),
                        ),
                        SizedBox(height: height * 0.035),
                        Text(
                          context.tr.confirm_email,
                          // 'تأكيد البريد الالكتروني',
                          style: TextStyle(
                            fontSize: width * 0.074,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'أدخل الرمز المرسل إلى ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: width * 0.04)),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.075),

                        /// Form
                        Form(
                          key: formKey,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 30),
                              child: PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: TextStyle(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 6,
                                animationType: AnimationType.fade,
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return context.tr.enter_pin_code;
                                    //  "الرجاء إدخال الرمز الذي تلقيته";
                                  } else {
                                    return null;
                                  }
                                },
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeFillColor: Colors.grey[300],
                                  activeColor: secondaryColor,
                                  inactiveColor: Colors.grey[300],
                                  disabledColor: Colors.grey,
                                  errorBorderColor: errorColor,
                                  inactiveFillColor: Colors.grey[300],
                                  selectedColor: secondaryColor,
                                  selectedFillColor: Colors.grey[300],
                                ),
                                cursorColor: Colors.black,
                                autoDismissKeyboard: true,
                                animationDuration: Duration(milliseconds: 300),
                                enableActiveFill: true,
                                errorAnimationController: errorController,
                                controller: codeController,
                                keyboardType: TextInputType.visiblePassword,
                                boxShadows: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 10,
                                  )
                                ],
                                onCompleted: (value) {
                                  formKey.currentState!.save();
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    cubit.codeVerification(
                                        code: codeController.text,
                                        isStudent: isStudent,
                                        context: context,
                                        deviceInfo: deviceInfo);
                                  }
                                },
                                onChanged: (value) {},
                                beforeTextPaste: (text) {
                                  print("السماح باللصق $text");
                                  return true;
                                },
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            cubit.hasVerifyError
                                ? context.tr.please_enter_correct_code
                                : "",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(height: height * 0.027),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr.code_not_sent,
                              // "لم يصلك الرمز؟ ",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 15),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  context.tr.resend_code,
                                  style: TextStyle(
                                      color: Color(0xFF91D3B3),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: DefaultAppButton(
                            onPressed: () {
                              formKey.currentState!.save();
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                cubit.codeVerification(
                                    code: codeController.text,
                                    isStudent: isStudent,
                                    context: context,
                                    deviceInfo: deviceInfo);
                              }
                            },
                            text: context.tr.verify,
                            background: secondaryColor,
                            isLoading: cubit.isVerifyLoading,
                            width: double.infinity,
                            textStyle: thirdTextStyle(deviceInfo),
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
