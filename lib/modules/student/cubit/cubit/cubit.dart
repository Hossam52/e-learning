import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_learning/models/student/group/friends_response_model.dart';
import 'package:e_learning/models/student/home/general_apis/teachers_response_model.dart';
import 'package:e_learning/models/student/search/search_model.dart';
import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';
import 'package:e_learning/modules/student/cubit/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:e_learning/shared/network/services/student_services.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentCubit extends Cubit<StudentStates> {
  // Cubit Constructor
  StudentCubit() : super(AppInitialState());

  // Cubit methode
  static StudentCubit get(context) => BlocProvider.of(context);

  /// ------------------------------------
  /// Friends Module
  FriendsResponseModel? friendsRequestResponseModel;
  bool noFriendsData = false;

  void getFriend(bool isRequests) async {
    try {
      noFriendsData = false;
      emit(FriendGetLoadingState());
      Response response = await DioHelper.getData(
        url: isRequests ? STUDENT_GET_FRIEND_REQUESTS : STUDENT_GET_MY_FRIENDS,
        token: studentToken,
      );
      if (response.data['status']) {
        friendsRequestResponseModel =
            FriendsResponseModel.fromJson(response.data);
        noFriendsData = false;
        emit(FriendGetSuccessState());
      } else {
        print(response.data['message']);
        noFriendsData = true;
        emit(FriendGetErrorState());
      }
    } catch (e) {
      noFriendsData = true;
      emit(FriendGetErrorState());
      throw e;
    }
  }

  void acceptAndRejectRequest(bool isAccept, String code) async {
    emit(FriendAcceptAndRejectLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isAccept
            ? STUDENT_ACCEPT_FRIEND_REQUESTS
            : STUDENT_REJECT_FRIEND_REQUESTS,
        token: studentToken,
        formData: FormData.fromMap({'code': code}),
      );
      if (response.data['status'])
        emit(FriendAcceptAndRejectSuccessState());
      else
        emit(FriendAcceptAndRejectErrorState());
      showToast(msg: response.data['message'], state: ToastStates.SUCCESS);
    } catch (e) {
      emit(FriendAcceptAndRejectErrorState());
      throw e;
    }
  }

  ///
  bool addFriendWithCodeLoading = false;
  bool friendRemoveWithCodeLoading = false;

  void addAndRemoveFriendWithCode({
    required String code,
    required BuildContext context,
    required bool isAdd,
  }) async {
    if (isAdd)
      addFriendWithCodeLoading = true;
    else
      friendRemoveWithCodeLoading = true;
    emit(GroupFriendWithCodeLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isAdd
            ? STUDENT_ADD_FRIEND_WITH_CODE
            : STUDENT_REMOVE_FRIEND_WITH_CODE,
        token: studentToken,
        formData: FormData.fromMap({
          'code': code,
        }),
      );
      if (response.data['status']) {
        showSnackBar(
          context: context,
          text: response.data['message'],
          backgroundColor: successColor,
        );
        emit(GroupFriendWithCodeSuccessState());
      } else {
        showSnackBar(
          context: context,
          text: response.data['message'],
          backgroundColor: errorColor,
        );
        emit(GroupFriendWithCodeErrorState());
      }
    } catch (e) {
      showToast(
        msg: 'عذرا حدث خطا حاول مرة اخرى',
        state: ToastStates.ERROR,
      );
      emit(GroupFriendWithCodeErrorState());
      throw e;
    } finally {
      if (isAdd)
        addFriendWithCodeLoading = false;
      else
        friendRemoveWithCodeLoading = false;
      emit(AppChangeState());
    }
  }

  /// Teacher Follow Module
  TeachersResponseModel? studentFollowingListModel;
  List<Teacher> followingList = [];
  List<Teacher> teachersInClassList = [];

  void getMyFollowingList(bool isAdd) async {
    try {
      emit(FollowingListLoadingState());
      Response response = await DioHelper.getData(
        url: isAdd
            ? STUDENT_GET_TEACHER_IN_SAME_CLASS
            : STUDENT_GET_FOLLOWING_LIST,
        token: studentToken,
      );
      if (response.data['status']) {
        studentFollowingListModel =
            TeachersResponseModel.fromJson(response.data);
        if (isAdd)
          teachersInClassList = studentFollowingListModel!.teachers!.data!;
        else
          followingList = studentFollowingListModel!.teachers!.data!;
        emit(FollowingListSuccessState());
      } else {
        print(response.data);
        emit(FollowingListErrorState());
      }
    } catch (e) {
      emit(FollowingListErrorState());
      throw e;
    }
  }

  bool isFollowed = false;
  int followCount = 0;

  void initIsFollowed(bool value, int count) {
    isFollowed = value;
    followCount = count;
  }

  void toggleTeacherFollow(int teacherId) async {
    try {
      followCount += isFollowed ? -1 : 1;
      isFollowed = !isFollowed;
      emit(ToggleFollowLoadingState());
      Response response = await DioHelper.postFormData(
        url: STUDENT_TOGGLE_FOLLOW_TEACHER,
        token: studentToken,
        formData: FormData.fromMap({'teacher_id': teacherId}),
      );
      print(response.data);
      if (response.data['status']) {
        emit(ToggleFollowSuccessState());
      } else {
        isFollowed = !isFollowed;
        followCount += isFollowed ? -1 : 1;
        showToast(msg: 'an error has occurred', state: ToastStates.ERROR);
        emit(ToggleFollowErrorState());
      }
    } catch (e) {
      isFollowed = !isFollowed;
      followCount += isFollowed ? -1 : 1;
      showToast(msg: 'an error has occurred', state: ToastStates.ERROR);
      emit(ToggleFollowErrorState());
      throw e;
    }
  }

  TeachersResponseModel? teacherSearchModel;

  void searchInTeachers(String value) async {
    try {
      emit(SearchInTeachersLoadingState());
      Response response = await DioHelper.postFormData(
        url: STUDENT_SEARCH_IN_TEACHERS,
        formData: FormData.fromMap({'search': value}),
      );
      if(response.data['status']) {
        teacherSearchModel = TeachersResponseModel.fromJson(response.data);
        emit(SearchInTeachersSuccessState());
      } else {
        emit(SearchInTeachersErrorState());
      }
    } catch (e) {
      emit(SearchInTeachersErrorState());
      throw e;
    }
  }

  SearchModel? searchModel;
  void searchStudent(String value) async{
    try {
      emit(SearchStudentLoadingState());
      searchModel = await StudentServices.searchStudent(value);
      if(searchModel!.status!) {
        emit(SearchStudentSuccessState());
      } else {
        emit(SearchStudentNoDataState());
      }
    } catch (e) {
      emit(SearchStudentErrorState());
      throw e;
    }
  }
}
