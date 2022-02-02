import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildSubjectsItem extends StatelessWidget {
  const BuildSubjectsItem({Key? key,
    required this.label,
    required this.color,
    required this.deviceInfo
  }) : super(key: key);

  final String label;
  final Color color;
  final DeviceInformation deviceInfo;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);
        return FilterChip(
          backgroundColor: Colors.grey[300],
          label: Text(label),
          labelStyle: thirdTextStyle(deviceInfo).copyWith(
            color: cubit.selectedSubjectsList.contains(label) ? Colors.white : Colors.black,
          ),
          disabledColor: Colors.black,
          checkmarkColor: Colors.white,
          selected: cubit.selectedSubjectsList.contains(label),
          selectedColor: secondaryColor,
          onSelected: (bool selected) {
            FocusScope.of(context).requestFocus(new FocusNode());
            cubit.onChangeSubject(label, selected);
          },
        );
      },
    );
  }
}
