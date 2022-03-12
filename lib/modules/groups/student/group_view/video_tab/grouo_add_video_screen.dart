import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/cubit.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/states.dart';
import 'package:e_learning/shared/componants/extentions.dart';
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
              title: Text(context.tr.add),
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
                            return context.tr.enter_video_title;
                          return null;
                        },
                        controller: videoNameController,
                        labelText: context.tr.video_title,
                        hintText: context.tr.video_title,
                        haveBackground: true,
                      ),
                      SizedBox(height: 30.h),
                      DefaultFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty)
                            return context.tr.enter_video_url;
                          else if (cubit.validateAndConvertVideoUrl(value) ==
                              null)
                            return context.tr.link_error_try_again;
                          else
                            return null;
                        },
                        controller: videoUrlController,
                        labelText: context.tr.paste_link,
                        hintText: context.tr.paste_link,
                        haveBackground: true,
                      ),
                      SizedBox(height: 40.h),
                      DefaultProgressButton(
                        buttonState: cubit.teacherAddVideoGroupButtonStates,
                        idleText: context.tr.add,
                        loadingText: context.tr.loading,
                        failText: context.tr.error_happened,
                        successText: context.tr.success_adding,
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
