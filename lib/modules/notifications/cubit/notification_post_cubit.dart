import 'dart:developer';

import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/modules/notifications/cubit/notification_post_states.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPostCubit extends Cubit<NotificationPostState> {
  NotificationPostCubit() : super(IntialNotificationPost());
  static NotificationPostCubit get(BuildContext context) =>
      BlocProvider.of<NotificationPostCubit>(context);
  Post? post;
  Future<void> getAllPostDetails(int postId) async {
    try {
      emit(LoadingPostState());
      final response = await DioHelper.postData(
          url: GET_POST_BY_ID, data: {'post_id': postId});
      if (response.data['status'] == null || response.data['status'] != true)
        throw '';
      post = Post.fromJson(response.data['student']);

      emit(SuccessPostState());
    } catch (e) {
      emit(ErrorPostState());
    }
  }
}
