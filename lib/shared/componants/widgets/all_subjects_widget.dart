import 'dart:developer';

import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/auth/teacher/register/build_subjects_item.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class AllSubjectsWidget extends StatefulWidget {
  const AllSubjectsWidget({Key? key}) : super(key: key);

  @override
  State<AllSubjectsWidget> createState() => _AllSubjectsWidgetState();
}

class _AllSubjectsWidgetState extends State<AllSubjectsWidget> {
  @override
  void initState() {
    AuthCubit.get(context).getAllSubjectsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final teacher = AuthCubit.get(context).teacherProfileModel!.teacher!;
    return responsiveWidget(
      responsive: (_, deviceInfo) => BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is TeacherRegisterSuccessState) {
            AuthCubit.get(context).getProfile(false);
            AppCubit.get(context).imageFile = null;
          }
          if (state is GetAllSubjectsSuccessState) {
            AuthCubit.get(context).selectedSubjectsList = List.generate(
                teacher.subjects!.length,
                (index) => teacher.subjects![index].name!);
            AuthCubit.get(context).selectedSubjectsId = List.generate(
                teacher.subjects!.length,
                (index) => teacher.subjects![index].id!);
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return Container(
            width: double.infinity,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      context.tr.subject,
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        context.tr.choose_at_least_subject,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: errorColor),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
