import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordDialog extends StatelessWidget {
  ForgetPasswordDialog(
      {Key? key, required this.deviceInfo, required this.isStudent})
      : super(key: key);

  final DeviceInformation deviceInfo;
  final bool isStudent;
  final TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);
        return DefaultGestureWidget(
          child: AlertDialog(
            scrollable: true,
            titleTextStyle:
                secondaryTextStyle(deviceInfo).copyWith(color: Colors.black),
            title: Text(
              'ادخل البريد الالكتروني الخاص بك لكي تصلك رسالة للتأكيد  لأنشاء كلمة مرور جديدة',
            ),
            content: DefaultFormField(
                controller: email,
                type: TextInputType.emailAddress,
                labelText: 'البريد الالكتروني',
                validation: (email) {
                  if (email == null || email.isEmpty)
                    return 'من فضلك ادخل البريد الالكتروني';
                  return null;
                }),
            actions: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultAppButton(
                      onPressed: () {
                        cubit.forgetPassword(
                          isStudent: isStudent,
                          email: email.text,
                          context: context,
                        );
                      },
                      text: 'متابعة',
                      width: 100,
                      isLoading: cubit.forgetPasswordLoading,
                      textStyle: thirdTextStyle(deviceInfo),
                      isDisabled: false,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('رجوع'))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
