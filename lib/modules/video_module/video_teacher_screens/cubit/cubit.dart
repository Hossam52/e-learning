import 'package:dio/dio.dart';
import 'package:e_learning/layout/teacher/teacher_layout.dart';
import 'package:e_learning/models/teacher/videos/playlist_data_model.dart';
import 'package:e_learning/models/teacher/videos/subject_playlists_data_model.dart';
import 'package:e_learning/models/teacher/videos/video_model.dart';
import 'package:bloc/bloc.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_state_button/progress_button.dart';

import 'states.dart';

class VideosCubit extends Cubit<VideosStates> {
  // Cubit Constructor
  VideosCubit() : super(AppInitialState());

  // Cubit methode
  static VideosCubit get(context) => BlocProvider.of(context);

  /// Validate and covert video url
  String? validateAndConvertVideoUrl(String url,
      {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  /// Add Videos
  List<VideoModel> videosList = [];
  Map<String, dynamic> addVideoModel = {};

  void teacherAddVideo({
    required String videoName,
    required String videoUrl,
  }) {
    String? _videoId = validateAndConvertVideoUrl(videoUrl);
    if (_videoId != null) {
      videosList.add(
        VideoModel(
          videoName: videoName,
          videoUrl: videoUrl,
          videoId: _videoId,
        ),
      );
      print(videosList.last.videoName);
      print(videosList.last.videoId);
      emit(TeacherVideoChangeState());
    }
  }

  /// Edit Video method
  void teacherEditVideo({
    required String videoName,
    required String videoUrl,
    required int index,
  }) {
    String? _videoId = validateAndConvertVideoUrl(videoUrl);
    if (_videoId != null) {
      videosList[index] = VideoModel(
        videoName: videoName,
        videoUrl: videoUrl,
        videoId: _videoId,
      );
      print(videosList[index].videoName);
      emit(TeacherVideoChangeState());
    }
  }

  void teacherDeleteVideo({
    required int index,
  }) {
    videosList.removeAt(index);
    print(videosList);
    emit(TeacherVideoChangeState());
  }

  /// Add Playlist Method
  PlaylistDataModel? playlistDataModel;
  ButtonState playlistAddButtonState = ButtonState.idle;

  void addTeacherPlaylist({
    required BuildContext context,
    required String playlistName,
    required int subjectId,
    required int termId,
    required int classId,
    required int videosCount,
    required int stageId,
  }) async {
    List<String> _videosName = [];
    List<String> _videosId = [];
    videosList.forEach((element) {
      _videosName.add(element.videoName);
      _videosId.add(element.videoId);
    });
    print(_videosName);
    print(_videosId);
    playlistAddButtonState = ButtonState.loading;
    emit(PlaylistAddLoadingState());
    await DioHelper.postFormData(
      url: TEACHER_ADD_PLAYLIST,
      token: teacherToken,
      formData: FormData.fromMap({
        'name': playlistName,
        'subject_id': subjectId,
        'term_id': termId,
        'classroom_id': classId,
        'video_num': videosCount,
        'stage_id': stageId,
        'video_name[]': _videosName,
        'video_id[]': _videosId,
      }),
    ).then((value) {
      if (value.data['status']) {
        playlistDataModel = PlaylistDataModel.fromJson(value.data);
        playlistAddButtonState = ButtonState.success;
        print(playlistDataModel!.message);
        emit(PlaylistAddSuccessState());
        Future.delayed(
          Duration(seconds: 1),
          () {
            navigateToAndFinish(context, TeacherLayout());
          },
        );
      } else {
        playlistAddButtonState = ButtonState.fail;
        print(value.data['message']);
        showSnackBar(context: context, text: value.data['message']);
        emit(PlaylistAddErrorState());
      }
    }).catchError((error) {
      playlistAddButtonState = ButtonState.fail;
      print(error.toString());
      emit(PlaylistAddErrorState());
    });
  }

  /// Get Subject Playlists
  SubjectPlaylistsDataModel? subjectPlaylistsModel;
  bool? hasSubjectPlayListData;
  bool isVideoLiked = false;

  void getSubjectPlaylists(bool isStudent, {required int subjectId, int? teacherId}) async {
    emit(SubjectPlaylistsLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isStudent ? STUDENT_GET_SUBJECT_PLAYLISTS : TEACHER_GET_SUBJECT_PLAYLISTS,
        token: isStudent ? studentToken : teacherToken,
        formData: FormData.fromMap({
          'subject_id': subjectId,
          if(isStudent)
            'teacher_id' : teacherId,
        }),
      );
      print(response.data);
      if (response.data['status']) {
        hasSubjectPlayListData = true;
        subjectPlaylistsModel = SubjectPlaylistsDataModel.fromJson(response.data);
        emit(SubjectPlaylistsSuccessState());
      } else {
        hasSubjectPlayListData = false;
        print(response.data['message']);
        emit(SubjectPlaylistsErrorState());
      }
    } catch (e) {
      hasSubjectPlayListData = false;
      emit(SubjectPlaylistsErrorState());
      throw e;
    }
  }

  /// Delete Playlist with id
  void deleteTeacherPlaylistWithId(int playlistId, BuildContext context, int subjectId) async{
    emit(PlaylistDeleteLoadingState());
    await DioHelper.postFormData(
      url: TEACHER_DELETE_PLAYLIST_WITH_ID,
      token: teacherToken,
      formData: FormData.fromMap({'playlist_id': playlistId}),
    ).then((value) {
      if (value.data['status']) {
        emit(PlaylistDeleteSuccessState());
        showSnackBar(context: context, text: value.data['message']);
      } else {
        emit(PlaylistDeleteErrorState());
        print(value.data['message']);
      }
      getSubjectPlaylists(false, subjectId: subjectId);
    }).catchError((error) {
      print(error.toString());
      emit(PlaylistDeleteErrorState());
    });
  }


  /// Teacher add group video
  ButtonState teacherAddVideoGroupButtonStates = ButtonState.idle;

  void addTeacherGroupVideo({
    required BuildContext context,
    required String videoId,
    required String name,
    required int groupId,
  }) async {
    teacherAddVideoGroupButtonStates = ButtonState.loading;
    emit(GroupAddVideoLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: TEACHER_ADD_GROUP_VIDEO,
        token: teacherToken,
        formData: FormData.fromMap({
          'video_id' : videoId,
          'name' : name,
          'group_id' : groupId,
        }),
      );
      print(response.data);
      if(response.data['status']) {
        teacherAddVideoGroupButtonStates = ButtonState.success;
        Future.delayed(Duration(milliseconds: 500), () => Navigator.pop(context));
        emit(GroupAddVideoSuccessState());
      } else {
        print(response.data['message']);
        teacherAddVideoGroupButtonStates = ButtonState.fail;
        emit(GroupAddVideoErrorState());
      }
    } on Exception catch (e) {
      teacherAddVideoGroupButtonStates = ButtonState.fail;
      emit(GroupAddVideoErrorState());
      throw e;
    }
  }
}
