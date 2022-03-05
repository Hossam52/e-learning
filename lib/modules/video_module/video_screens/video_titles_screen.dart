import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/teacher/videos/subject_playlists_data_model.dart';
import 'package:e_learning/modules/video_module/video_screens/video_player_screen.dart';
import 'package:e_learning/modules/video_module/video_screens/video_title_build_item.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';

class VideoTitlesScreen extends StatelessWidget {
  const VideoTitlesScreen({Key? key,
    required this.videos,
    required this.isStudent,
    required this.teacherId,
    required this.subjectId,
    required this.videosCubit,
  }) : super(key: key);

  final List<VideosData> videos;
  final bool isStudent;
  final int teacherId;
  final int subjectId;
  final VideosCubit videosCubit;

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return Scaffold(
          appBar: AppBar(
            title: Text('الفيديوهات'),
            centerTitle: true,
            leading: defaultBackButton(context, deviceInfo.screenHeight),
          ),
          body: ListView.separated(
            itemCount: videos.length,
            padding: EdgeInsets.all(16),
            physics: BouncingScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 15,),
            itemBuilder: (context, index) {
              var video = videos[index];
              return VideoTitleBuildItem(
                videoTitle: video.videoName!,
                videoId: video.videoId!,
                onPressed: () {
                  navigateTo(
                      context,
                      VideoPlayerScreen(
                        title: video.videoName!,
                        videoId: video.videoId!,
                        comments: video.comments!,
                        commentType: CommentType.playlistVideo,
                        id: video.id!,
                        subjectId: subjectId,
                        teacherId: teacherId,
                        isStudent: isStudent,
                        likeType: LikeType.playlistVideo,
                        likesCount: video.likesCount!,
                        isLiked: isStudent
                            ? video.authLikeStudent!
                            : video.authLikeTeacher?? false,
                        oldCubit: videosCubit,
                      ));
                },
              );
            },
          ),
        );
      },
    );
  }
}
