import 'dart:developer';

import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_drop_down.dart';
import 'package:flutter/material.dart';

class ClassRoomDropDown extends StatelessWidget {
  const ClassRoomDropDown({Key? key, required this.authCubit})
      : super(key: key);
  final AuthCubit authCubit;
  @override
  Widget build(BuildContext context) {
    log(authCubit.stagesNamesList.length.toString());
    return DefaultDropDown(
      // label: 'الصف الدراسي',
      label: context.tr.classroom,
      selectedValue: authCubit.selectedStageName,
      validator: (value) => value == null ? context.tr.field_required : null,
      onChanged: (value) {
        authCubit.onChangeStage(value);
      },
      items: List.generate(authCubit.stagesNamesList.length,
          (index) => authCubit.stagesNamesList[index].toString()),
    );
  }
}

class SemsterDropDown extends StatelessWidget {
  const SemsterDropDown({Key? key, required this.authCubit}) : super(key: key);
  final AuthCubit authCubit;
  @override
  Widget build(BuildContext context) {
    return DefaultDropDown(
      // label: 'الترم الدراسي',
      label: context.tr.academic_semster,
      selectedValue: authCubit.selectedClassName,
      validator: (value) => value == null ? 'field required' : null,
      onChanged: (value) {
        authCubit.onChangeClass(value);
      },
      items: authCubit.classesNameList,
    );
  }
}
