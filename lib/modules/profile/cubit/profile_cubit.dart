import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/models/student/home/general_apis/teachers_response_model.dart';
import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/modules/profile/cubit/profile_states.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(IntialProfileState());

  static ProfileCubit instance(BuildContext context) =>
      BlocProvider.of<ProfileCubit>(context);

  StudentDataModel? studentByIdModel;
  TeacherDataModel? teacherByIdModel;

  TeachersResponseModel? followingList;

  AllPostsModel? _allPostsModel;
  Response? allPostsResponse;
  List<Teacher> get getFollowingList {
    if (followingList == null || followingList!.teachers == null)
      return [];
    else
      return followingList?.teachers?.data ?? [];
  }

  List<Post> get getProfilePosts {
    return _allPostsModel?.posts ?? [];
  }

  bool get isLastPostPage {
    final meta = _allPostsModel?.meta;
    if (meta == null) return true;
    return meta.currentPage == meta.lastPage ? true : false;
  }

  void getProfile(int id, bool isStudent) async {
    log('Hello');
    try {
      emit(ProfileLoadingState());
      Response response = await DioHelper.postFormData(
        url: isStudent
            ? STUDENT_GENERAL_GET_PROFILE
            : TEACHER_GENERAL_GET_PROFILE,
        formData: FormData.fromMap(
            {if (isStudent) 'student_id': id else 'teacher_id': id}),
      );
      if (response.data['status']) {
        if (isStudent)
          studentByIdModel = StudentDataModel.fromJson(response.data);
        else
          teacherByIdModel = TeacherDataModel.fromJson(response.data);
        emit(ProfileSuccessState());
      } else
        throw 'Error';
    } catch (e) {
      emit(ProfileErrorState());
      print(e.toString());
    }
  }

  void getStudentPosts(int id) async {
    try {
      emit(ProfilePostsLoadingState());
      Response response = await DioHelper.postFormData(
          url: STUDENT_GET_ALL_POSTS_BY_ID,
          formData: FormData.fromMap({'student_id': id}),
          token: studentToken ?? teacherToken);
      log(response.data.toString());
      if (response.data['status']) {
        _allPostsModel = AllPostsModel.fromMap(response.data);
        allPostsResponse = response;
        emit(ProfilePostsSuccessState());
      } else
        throw 'Exception in profile posts';
    } catch (e) {
      emit(ProfilePostsErrorState());
      print(e.toString());
    }
  }

  void getMoreStudentPosts(int id) async {
    if (isLastPostPage) return;
    try {
      emit(ProfileMorePostsLoadingState());
      Response response = await DioHelper.postFormData(
          url: STUDENT_GET_ALL_POSTS_BY_ID,
          formData: FormData.fromMap({
            'student_id': id,
            'page': _allPostsModel!.meta!.currentPage! + 1
          }),
          token: studentToken ?? teacherToken);
      log(response.data.toString());
      if (response.data['status']) {
        final newData = AllPostsModel.fromMap(response.data);
        _allPostsModel!.posts!.addAll(newData.posts!);
        _allPostsModel!.meta = newData.meta;
        allPostsResponse = response;
        emit(ProfileMorePostsSuccessState());
      } else
        throw 'Exception in profile posts';
    } catch (e) {
      emit(ProfileMorePostsErrorState());
      print(e.toString());
    }
  }

  void getStudentFollowingList(int id) async {
    try {
      emit(ProfileFollowersLoadingState());
      Response response = await DioHelper.postFormData(
          url: STUDENT_GET_FOLLOWERS_BY_STD_ID,
          formData: FormData.fromMap({'student_id': id}),
          token: studentToken ?? teacherToken);
      log(response.data.toString());
      if (response.data['status']) {
        followingList = TeachersResponseModel.fromJson(response.data);
        log('Test length' + followingList!.teachers!.data!.length.toString());
        emit(ProfileFollowersSuccessState());
      } else
        throw 'Error on followers';
    } catch (e) {
      emit(ProfileFollowersErrorState());
      print(e.toString());
    }
  }
}
