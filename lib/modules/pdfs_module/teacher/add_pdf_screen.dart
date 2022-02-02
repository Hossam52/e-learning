import 'package:e_learning/modules/pdfs_module/cubit/cubit.dart';
import 'package:e_learning/modules/pdfs_module/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_drop_down.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPdfScreen extends StatefulWidget {
  AddPdfScreen({
    Key? key,
    required this.title,
    required this.deviceInfo,
    required this.type,
    required this.oldContext,
  }) : super(key: key);

  final String title;
  final DeviceInformation deviceInfo;
  final String type;
  final BuildContext oldContext;

  @override
  _AddPdfScreenState createState() => _AddPdfScreenState();
}

class _AddPdfScreenState extends State<AddPdfScreen> {
  final TextEditingController fileName = TextEditingController();

  final TextEditingController url = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    AppCubit.get(context).getTeacherStages();
    AppCubit.get(context).getTeacherTerms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: FilesCubit.get(widget.oldContext),
      child: DefaultGestureWidget(
        child: Scaffold(
          appBar: AppBar(
            title: Text("اضافة ${widget.title}"),
            elevation: 1,
            centerTitle: true,
            leading: defaultBackButton(context, widget.deviceInfo.screenHeight),
          ),
          body: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              AppCubit appCubit = AppCubit.get(context);
              return BlocConsumer<FilesCubit, FilesStates>(
                listener: (context, state) {
                  if (state is FilePostSuccessState) {
                    Future.delayed(
                      Duration(milliseconds: 500),
                      () => Navigator.pop(context),
                    );
                  }
                },
                builder: (context, state) {
                  FilesCubit cubit = FilesCubit.get(context);
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 40.h),
                            DefaultFormField(
                              controller: fileName,
                              labelText: 'آسم الملف',
                              hintText: 'آسم الملف',
                              haveBackground: true,
                              validation: (value) {
                                if (value == null || value.isEmpty)
                                  return 'هذا الحقل مطلوب';
                                return null;
                              },
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
                            ),
                            SizedBox(height: 17.h),
                            DefaultFormField(
                              validation: (value) {
                                if (value == null || value.isEmpty)
                                  return 'هذا الحقل مطلوب';
                                return null;
                              },
                              controller: url,
                              labelText: 'الصق الرابط',
                              hintText: 'الصق الرابط',
                              haveBackground: true,
                            ),
                            if (cubit.hasFileError)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 10.h),
                                child: Text(
                                  'خطا فى الرابط برجاء التأكد من الرابط و المحاولة مجددا',
                                  style: TextStyle(color: errorColor),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            SizedBox(height: 50.h),
                            DefaultProgressButton(
                              buttonState: cubit.addFileButtonState,
                              idleText: 'اضافة',
                              loadingText: 'Loading',
                              failText: 'حدث خطأ',
                              successText: 'تم الاضافة بنجاح',
                              onPressed: () async {
                                formKey.currentState!.save();
                                if (formKey.currentState!.validate()) {
                                  cubit.filePostMethod(
                                    context: context,
                                    name: fileName.text,
                                    stageId: appCubit.selectedStageId!,
                                    classroomId: appCubit.selectedClassId!,
                                    termId: appCubit.selectedTermId!,
                                    subjectId: appCubit.selectedSubjectId!,
                                    url: url.text,
                                    type: widget.type,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    fileName.dispose();
    url.dispose();
    super.dispose();
  }
}
