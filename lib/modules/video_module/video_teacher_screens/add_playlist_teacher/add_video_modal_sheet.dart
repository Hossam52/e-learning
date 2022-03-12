import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/cubit.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddVideoModalSheet extends StatefulWidget {
  AddVideoModalSheet({
    Key? key,
    required this.deviceInfo,
    this.videoName,
    this.videoUrl,
    this.index,
    required this.cubit,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final VideosCubit cubit;
  int? index;
  String? videoName;
  String? videoUrl;

  @override
  _AddVideoModalSheetState createState() => _AddVideoModalSheetState();
}

class _AddVideoModalSheetState extends State<AddVideoModalSheet> {
  final TextEditingController videoNameController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    videoNameController.text =
        widget.videoName != null ? widget.videoName! : '';
    videoUrlController.text = widget.videoUrl != null ? widget.videoUrl! : '';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultGestureWidget(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 30.h),
                DefaultFormField(
                  validation: (value) {
                    if (value == null || value.isEmpty)
                      return context
                          .tr.enter_video_title; //'من فضلك ادخل عنوان الفيديو';
                    return null;
                  },
                  controller: videoNameController,
                  labelText: context.tr.video_title,
                  hintText: context.tr.video_title,
                  haveBackground: true,
                ),
                SizedBox(height: 20.h),
                DefaultFormField(
                  validation: (value) {
                    if (value == null || value.isEmpty)
                      return context
                          .tr.enter_video_url; // 'من فضلك ادخل رابط الفيديو';
                    else if (widget.cubit.validateAndConvertVideoUrl(value) ==
                        null)
                      return context.tr
                          .link_error_try_again; // 'خطا فى الرابط برجاء التأكد من الرابط و المحاولة مجددا';
                    else
                      return null;
                  },
                  controller: videoUrlController,
                  labelText: context.tr.paste_link,
                  hintText: context.tr.paste_link,
                  haveBackground: true,
                ),
                SizedBox(height: 20.h),
                DefaultAppButton(
                  text: widget.index != null ? context.tr.edit : context.tr.add,
                  textStyle: thirdTextStyle(widget.deviceInfo),
                  width: 120.w,
                  onPressed: () {
                    formKey.currentState!.save();
                    if (formKey.currentState!.validate()) {
                      if (widget.index != null) {
                        widget.cubit.teacherEditVideo(
                          videoName: videoNameController.text,
                          videoUrl: videoUrlController.text,
                          index: widget.index!,
                        );
                      } else {
                        widget.cubit.teacherAddVideo(
                          videoName: videoNameController.text,
                          videoUrl: videoUrlController.text,
                        );
                      }
                      Navigator.pop(context);
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
  }
}
