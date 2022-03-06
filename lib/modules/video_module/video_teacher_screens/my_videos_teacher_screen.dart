import 'package:e_learning/modules/teacher/teacher_filter_build.dart';
import 'package:e_learning/modules/video_module/video_screens/video_titles_screen.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import 'add_playlist_teacher/teacher_add_playlist.dart';
import 'cubit/cubit.dart';
import 'my_playlist_build_item.dart';

class MyVideosTeacherScreen extends StatelessWidget {
  MyVideosTeacherScreen({Key? key, required this.index}) : super(key: key);

  final int index;
  final List<String> items = [
    'الكل',
    'المرحلة الاعدادية',
    'المرحلة الابتدأية',
  ];
  String selectedValue = 'الكل';

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return BlocProvider(
          create: (context) =>
              VideosCubit()..getSubjectPlaylists(false, subjectId: index),
          child: BlocConsumer<VideosCubit, VideosStates>(
            listener: (context, state) {},
            builder: (context, state) {
              VideosCubit cubit = VideosCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  title: Text('فديوهاتي'),
                  centerTitle: true,
                  leading: defaultBackButton(context, deviceInfo.screenHeight),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    navigateTo(
                        context,
                        TeacherAddPlaylist(
                          deviceInfo: deviceInfo,
                        ));
                  },
                  child: Icon(Icons.add),
                ),
                body: Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      state is! SubjectPlaylistsLoadingState,
                  fallbackBuilder: (context) => DefaultLoader(),
                  widgetBuilder: (context) => cubit.hasSubjectPlayListData!
                      ? Column(
                          children: [
                            TeacherFilterBuild(
                              classItems: items,
                              stageItems: items,
                              deviceInfo: deviceInfo,
                              selectedStage: selectedValue,
                              selectedClass: selectedValue,
                              onClassChanged: (value) {},
                              onStageChanged: (value) {},
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: cubit
                                      .subjectPlaylistsModel!.playlist!.length,
                                  padding: EdgeInsets.all(22),
                                  itemBuilder: (context, index) {
                                    var playlist = cubit.subjectPlaylistsModel!
                                        .playlist![index];
                                    return MyPlaylistBuildItem(
                                      onPressed: () {
                                        navigateTo(
                                            context,
                                            VideoTitlesScreen(
                                              videos: playlist.videos?? [],
                                              isStudent: false,
                                              teacherId: index,
                                              subjectId: index,
                                              videosCubit: cubit,
                                            ));
                                      },
                                      playlistName: playlist.name!,
                                      stage: playlist.stage!,
                                      videoCount: playlist.videoNum!,
                                      onEdit: () {},
                                      onDelete: () {
                                        cubit.deleteTeacherPlaylistWithId(
                                          playlist.id!,
                                          context,
                                          index,
                                        );
                                      },
                                    );
                                  }),
                            ),
                          ],
                        )
                      : noData('لا يوجد فيديوهات'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
