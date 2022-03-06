import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/cubit.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'add_video_modal_sheet.dart';

class TeacherAddVideos extends StatelessWidget {
  TeacherAddVideos({Key? key,
    required this.deviceInfo,
    required this.playlistName,
    required this.subjectId,
    required this.termId,
    required this.classId,
    required this.stageId,
  }) : super(key: key);

  final DeviceInformation deviceInfo;

  final String playlistName;
  final int subjectId;
  final int stageId;
  final int termId;
  final int classId;

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
              title: Text("اضافة"),
              elevation: 1,
              centerTitle: true,
              leading: defaultBackButton(context, deviceInfo.screenHeight),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  enableDrag: true,
                  builder: (context) => AddVideoModalSheet(
                    deviceInfo: deviceInfo,
                    cubit: cubit,
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
            body: Padding(
              padding: EdgeInsets.all(22),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: EdgeInsets.zero,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadowColor: Colors.black38,
                        child: Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                              cubit.videosList.isNotEmpty,
                          fallbackBuilder: (context) => Center(
                            child: Text('لا يوجد فيديوهات حتى الان'),
                          ),
                          widgetBuilder: (context) => ListView.builder(
                            itemCount: cubit.videosList.length,
                            padding: EdgeInsets.symmetric(vertical: 30.h),
                            // separatorBuilder: (context, index) => defaultDivider(),
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(bottom: 10.h),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: ListTile(
                                title:
                                    Text(cubit.videosList[index].videoName),
                                contentPadding: EdgeInsets.zero,
                                trailing: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      enableDrag: true,
                                      builder: (context) => AddVideoModalSheet(
                                        deviceInfo: deviceInfo,
                                        videoName: cubit.videosList[index].videoName,
                                        videoUrl: cubit.videosList[index].videoUrl,
                                        index: index,
                                        cubit: cubit,
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: primaryColor,
                                  ),
                                ),
                                leading: IconButton(
                                  onPressed: () {
                                    cubit.teacherDeleteVideo(index: index);
                                  },
                                  icon: Icon(
                                    Icons.close_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  DefaultProgressButton(
                    buttonState: cubit.playlistAddButtonState,
                    idleText: 'انهاء',
                    loadingText: 'Loading',
                    failText: 'حدث خطأ',
                    successText: 'تم الاضافة بنجاح',
                    onPressed: cubit.videosList.isEmpty
                        ? null
                        : () {
                            cubit.addTeacherPlaylist(
                              context: context,
                              playlistName: playlistName,
                              subjectId: subjectId,
                              termId: termId,
                              classId: classId,
                              stageId: stageId,
                              videosCount: cubit.videosList.length,
                            );
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
