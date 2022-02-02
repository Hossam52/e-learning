import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/cubit.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/states.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupAddVideoScreen extends StatelessWidget {
  GroupAddVideoScreen({Key? key, required this.groupId}) : super(key: key);

  final int groupId;
  final TextEditingController videoNameController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideosCubit(),
      child: BlocConsumer<VideosCubit, VideosStates>(
        listener: (context, state) {},
        builder: (context, state) {
          VideosCubit cubit = VideosCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('اضافة'),
            ),
            body: DefaultGestureWidget(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
                child: Form(
                  key: formKey,
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30.h),
                      DefaultFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty)
                            return 'من فضلك ادخل عنوان الفيديو';
                          return null;
                        },
                        controller: videoNameController,
                        labelText: 'عنوان الفديو',
                        hintText: 'عنوان الفديو',
                        haveBackground: true,
                      ),
                      SizedBox(height: 30.h),
                      DefaultFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty)
                            return 'من فضلك ادخل رابط الفيديو';
                          else if (cubit.validateAndConvertVideoUrl(value) ==
                              null)
                            return 'خطا فى الرابط برجاء التأكد من الرابط و المحاولة مجددا';
                          else
                            return null;
                        },
                        controller: videoUrlController,
                        labelText: 'الصق الرابط',
                        hintText: 'الصق الرابط',
                        haveBackground: true,
                      ),
                      SizedBox(height: 40.h),
                      DefaultProgressButton(
                        buttonState: cubit.teacherAddVideoGroupButtonStates,
                        idleText: 'اضافة',
                        loadingText: 'Loading',
                        failText: 'حدث خطأ',
                        successText: 'تم الاضافة بنجاح',
                        onPressed: () {
                          formKey.currentState!.save();
                          if (formKey.currentState!.validate()) {
                            cubit.addTeacherGroupVideo(
                              context: context,
                              videoId: cubit.validateAndConvertVideoUrl(
                                  videoUrlController.text)!,
                              name: videoNameController.text,
                              groupId: groupId,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
