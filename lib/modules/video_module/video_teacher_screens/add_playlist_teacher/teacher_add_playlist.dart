import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_drop_down.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'teacher_add_videos.dart';

class TeacherAddPlaylist extends StatefulWidget {
  TeacherAddPlaylist({Key? key, required this.deviceInfo}) : super(key: key);

  final DeviceInformation deviceInfo;

  @override
  _TeacherAddPlaylistState createState() => _TeacherAddPlaylistState();
}

class _TeacherAddPlaylistState extends State<TeacherAddPlaylist> {
  final TextEditingController playlistNameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    AppCubit.get(context).getTeacherStages();
    AppCubit.get(context).getTeacherTerms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('فديوهاتي'),
        centerTitle: true,
        leading: defaultBackButton(context, widget.deviceInfo.screenHeight),
      ),
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    DefaultFormField(
                      validation: (value) {
                        if (value == null || value.isEmpty)
                          return 'هذا الحقل مطلوب';
                        return null;
                      },
                      controller: playlistNameController,
                      labelText: 'اسم قائمه التشغيل',
                      hintText: 'اسم قائمه التشغيل',
                      haveBackground: true,
                    ),
                    SizedBox(height: 17.h),
                    DefaultDropDown(
                      label: 'المرحله',
                      hint: 'المرحله',
                      haveBackground: true,
                      onChanged: (value) {
                        appCubit.onChangeStage(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'هذا الحقل مطلوب';
                        return null;
                      },
                      items: appCubit.stageNamesList,
                      selectedValue: appCubit.teacherSelectedStage,
                      isLoading: appCubit.isStagesLoading,
                    ),
                    SizedBox(height: 17.h),
                    DefaultDropDown(
                      label: 'السنه',
                      hint: 'السنه',
                      haveBackground: true,
                      onChanged: (value) {
                        appCubit.onChangeClass(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'هذا الحقل مطلوب';
                        return null;
                      },
                      items: appCubit.classNamesList,
                      selectedValue: appCubit.selectedClassName,
                    ),
                    SizedBox(height: 17.h),
                    DefaultDropDown(
                      label: 'الترم',
                      hint: 'الترم',
                      haveBackground: true,
                      onChanged: (value) {
                        appCubit.onTermChange(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'هذا الحقل مطلوب';
                        return null;
                      },
                      items: appCubit.termNamesList,
                      selectedValue: appCubit.selectedTermName,
                      isLoading: appCubit.isTermsLoading,
                    ),
                    SizedBox(height: 17.h),
                    DefaultDropDown(
                      label: 'الماده',
                      hint: 'الماده',
                      haveBackground: true,
                      onChanged: (value) {
                        appCubit.onSubjectChange(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'هذا الحقل مطلوب';
                        return null;
                      },
                      items: appCubit.subjectNamesList,
                      selectedValue: appCubit.selectedSubjectName,
                      isLoading: false,
                    ),
                    SizedBox(height: 30.h),
                    DefaultAppButton(
                      text: 'اضافة',
                      textStyle: thirdTextStyle(widget.deviceInfo),
                      onPressed: () {
                        formKey.currentState!.save();
                        if (formKey.currentState!.validate()) {
                          navigateTo(context,
                              TeacherAddVideos(
                                deviceInfo: widget.deviceInfo,
                                playlistName: playlistNameController.text,
                                stageId: appCubit.selectedStageId!,
                                classId: appCubit.selectedClassId!,
                                termId: appCubit.selectedTermId!,
                                subjectId: appCubit.selectedSubjectId!,
                              ));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    playlistNameController.dispose();
    super.dispose();
  }
}
