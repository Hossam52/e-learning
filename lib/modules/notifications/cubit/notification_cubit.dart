import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_learning/models/general_apis/notification_response_model.dart';
import 'package:e_learning/models/pagination.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  // Cubit methode
  static NotificationCubit get(context) => BlocProvider.of(context);
  int countUnreaded = 0;

  NotificationResponseModel? notificationResponseModel;
  bool noNotifications = false;
  void deleteNotification(NotificationType type,
      {required int notificationId}) async {
    try {
      final response = await DioHelper.postData(
          url: type == NotificationType.Student
              ? STUDENT_DELETE_NOTIFICATION
              : TEACHER_DELETE_NOTIFICATION,
          token: type == NotificationType.Student ? studentToken : teacherToken,
          data: {
            'notify_id': notificationId,
          });
      if (response.data['status']) {
        emit(NotificationDeletedSuccess(response.data['notifications']));
      }
    } catch (e) {
      throw e;
    }
  }

  void getAllNotifications(NotificationType type) async {
    emit(NotificationGetLoading());
    Response response = await DioHelper.getData(
      url: type == NotificationType.Student
          ? STUDENT_GET_ALL_NOTIFICATIONS
          : TEACHER_GET_ALL_NOTIFICATIONS,
      token: type == NotificationType.Student ? studentToken : teacherToken,
    );
    print(response.data);
    if (response.data['status']) {
      notificationResponseModel =
          NotificationResponseModel.fromJson(response.data);
      countUnreaded = notificationResponseModel!.notifications!.data!.length;
    } else
      noNotifications = true;
    emit(NotificationGetSuccess());
    try {} catch (e) {
      emit(NotificationGetError());
      throw e;
    }
  }

  void getMoreAllNotifications(NotificationType type) async {
    Meta? meta = notificationResponseModel?.notifications?.meta;
    if (meta == null || meta.currentPage == meta.lastPage) return;
    log('Previous ${meta.currentPage} Next ${meta.currentPage! + 1}');
    try {
      emit(NotificationGetMoreLoading());
      Response response = await DioHelper.getData(
          url: type == NotificationType.Student
              ? STUDENT_GET_ALL_NOTIFICATIONS
              : TEACHER_GET_ALL_NOTIFICATIONS,
          token: type == NotificationType.Student ? studentToken : teacherToken,
          query: {'page': meta.currentPage! + 1});
      print(response.data);
      if (response.data['status']) {
        var model = NotificationResponseModel.fromJson(response.data);
        notificationResponseModel!.notifications!.data!
            .addAll(model.notifications!.data!);
        notificationResponseModel!.notifications!.meta =
            model.notifications!.meta;
      } else
        noNotifications = true;
      emit(NotificationGetMoreSuccess());
    } catch (e) {
      emit(NotificationGetMoreError());
      throw e;
    }
  }

  //read all notifications
  Future<void> readAllNotifications(NotificationType type) async {
    try {
      await DioHelper.getData(
        url: type == NotificationType.Student
            ? STUDENT_READ_ALL_NOTIFICATIONS
            : TEACHER_READ_ALL_NOTIFICATIONS,
        token: type == NotificationType.Student ? studentToken : teacherToken,
      );
      countUnreaded = 0;
      emit(NotificationGetSuccess());
    } catch (e) {
      throw e;
    }
  }
}

enum NotificationType { Teacher, Student }
