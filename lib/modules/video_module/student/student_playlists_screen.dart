import 'package:e_learning/modules/video_module/student/student_playlist_build_item.dart';
import 'package:e_learning/modules/video_module/video_screens/video_titles_screen.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/cubit.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class StudentPlaylistsScreen extends StatelessWidget {
  const StudentPlaylistsScreen({
    Key? key,
    required this.subjectId,
    required this.teacherId,
    required this.teacherName,
  }) : super(key: key);

  final int subjectId;
  final int teacherId;
  final String teacherName;

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return BlocProvider(
          create: (context) => VideosCubit()
            ..getSubjectPlaylists(
              true,
              subjectId: subjectId,
              teacherId: teacherId,
            ),
          child: BlocConsumer<VideosCubit, VideosStates>(
            listener: (context, state) {},
            builder: (context, state) {
              VideosCubit cubit = VideosCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  title: Text(context.tr.my_videos),
                  centerTitle: true,
                  leading: defaultBackButton(context, deviceInfo.screenHeight),
                ),
                body: Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      state is! SubjectPlaylistsLoadingState,
                  fallbackBuilder: (context) => DefaultLoader(),
                  widgetBuilder: (context) => cubit.hasSubjectPlayListData!
                      ? ListView.builder(
                          itemCount:
                              cubit.subjectPlaylistsModel!.playlist!.length,
                          padding: EdgeInsets.all(22),
                          itemBuilder: (context, index) {
                            var playlist =
                                cubit.subjectPlaylistsModel!.playlist![index];
                            return StudentPlaylistBuildItem(
                              onPressed: () {
                                navigateTo(
                                    context,
                                    VideoTitlesScreen(
                                      videos: playlist.videos ?? [],
                                      isStudent: true,
                                      teacherId: teacherId,
                                      subjectId: subjectId,
                                      videosCubit: cubit,
                                    ));
                              },
                              playlistName: playlist.name!,
                              teacherName: teacherName,
                              videoCount: playlist.videoNum!,
                            );
                          })
                      : noData(context.tr.no_videos),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
