import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_learning/models/general_apis/notification_response_model.dart';
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

  NotificationResponseModel? notificationResponseModel;
  bool noNotifications = false;
  void getAllNotifications(NotificationType type) async {
    try {
      emit(NotificationGetLoading());
      Response response = await DioHelper.getData(
        url: type == NotificationType.Student
            ? STUDENT_GET_ALL_NOTIFICATIONS : TEACHER_GET_ALL_NOTIFICATIONS,
        token: type == NotificationType.Student ? studentToken : teacherToken,
      );
      if(response.data['status']){
        notificationResponseModel = NotificationResponseModel.fromJson(response.data);
      } else
        noNotifications = true;
      emit(NotificationGetSuccess());
    } catch (e) {
      emit(NotificationGetError());
      throw e;
    }
  }
}

enum NotificationType { Teacher, Student }
