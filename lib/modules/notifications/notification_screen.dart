import 'dart:developer';

import 'package:e_learning/models/general_apis/notification_response_model.dart';
import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';
import 'package:e_learning/modules/following_list/teacher_view/teacher_profile_view.dart';
import 'package:e_learning/modules/notifications/cubit/notification_cubit.dart';
import 'package:e_learning/modules/notifications/notification_build_item.dart';
import 'package:e_learning/modules/notifications/notification_post/notification_post_screen.dart';
import 'package:e_learning/modules/profile/student_profile_view.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/load_more_data.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen(
      {Key? key, required this.type, required this.cubitContext})
      : super(key: key);

  final NotificationType type;
  final BuildContext cubitContext;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool first = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationCubit.get(widget.cubitContext).getAllNotifications(widget.type);
  }

  @override
  void didChangeDependencies() {
    // NotificationCubit.get(widget.cubitContext).getAllNotifications(widget.type);
    if (first) {
      NotificationCubit.get(widget.cubitContext)
          .readAllNotifications(widget.type);
      first = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: NotificationCubit.get(widget.cubitContext),
      child: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationDeletedSuccess)
            showSnackBar(
                context: context,
                text: state.message,
                backgroundColor: Colors.green);
        },
        builder: (context, state) {
          NotificationCubit cubit = NotificationCubit.get(context);
          return responsiveWidget(
            responsive: (_, deviceInfo) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(context.tr.notifications),
                  centerTitle: true,
                  leading: defaultBackButton(context, deviceInfo.screenHeight),
                ),
                body: SingleChildScrollView(
                  child: Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        state is! NotificationGetLoading,
                    fallbackBuilder: (context) => DefaultLoader(),
                    widgetBuilder: (context) => cubit.noNotifications
                        ? noData(context.tr.no_notifications_up_till_now)
                        : cubit.notificationResponseModel == null ||
                                state is NotificationGetError
                            ? NoDataWidget(
                                onPressed: () =>
                                    cubit.getAllNotifications(widget.type))
                            : Column(
                                children: [
                                  ListView.separated(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: cubit.notificationResponseModel!
                                        .notifications!.data!.length,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    separatorBuilder: (context, index) =>
                                        Divider(height: 0),
                                    itemBuilder: (context, index) {
                                      var notification = cubit
                                          .notificationResponseModel!
                                          .notifications!
                                          .data![index];
                                      Student? student =
                                          notification.studentSender;
                                      Teacher? teacher =
                                          notification.teacherSender;
                                      String image = getImage(student, teacher);
                                      return Dismissible(
                                        key: UniqueKey(),
                                        onDismissed: (direction) {
                                          cubit.deleteNotification(widget.type,
                                              notificationId: notification.id!);
                                          cubit.notificationResponseModel!
                                              .notifications!.data!
                                              .remove(notification);
                                        },
                                        confirmDismiss: (direction) async {
                                          return showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text(context.tr
                                                        .sure_delete_notification),
                                                    actions: [
                                                      defaultTextButton(
                                                          text: context
                                                              .tr.confirm,
                                                          textColor:
                                                              Colors.green,
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  true)),
                                                      defaultTextButton(
                                                          text:
                                                              context.tr.cancel,
                                                          textColor: Colors.red,
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  false)),
                                                    ],
                                                    content:
                                                        Text(context.tr.data),
                                                  ));
                                        },
                                        child: NotificationBuildItem(
                                          image: image,
                                          title: notification.title!,
                                          body: notification.body!,
                                          date: notification.date!,
                                          onTap: () async {
                                            if (notification.post != null) {
                                              log('post');
                                              navigateToPost(notification);
                                            } else if (notification.video !=
                                                null) {
                                              log('champion');
                                              navigateToChampion(notification);
                                            } else if (notification.champion !=
                                                null) {
                                              log('video');
                                              navigateToVideo(notification);
                                            } else {
                                              log('personal profile');
                                              navigateToPersonalProfile(
                                                  notification);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  LoadMoreData(
                                    isLoading:
                                        state is NotificationGetMoreLoading,
                                    onLoadingMore: () {
                                      cubit
                                          .getMoreAllNotifications(widget.type);
                                    },
                                  )
                                ],
                              ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String getImage(Student? student, Teacher? teacher) {
    if (student != null)
      return student.image!;
    else if (teacher != null)
      return teacher.image!;
    else
      return '';
  }

  void navigateToPost(NotificationData notification) async {
    log(notification.post!.id.toString());
    await navigateTo(context, NotificationPostScreen(post: notification.post!));
  }

  void navigateToVideo(NotificationData notification) {
    log(notification.video!.id.toString());
  }

  void navigateToChampion(NotificationData notification) {
    log(notification.video!.id.toString());
  }

  void navigateToPersonalProfile(NotificationData notification) {
    late Widget child;
    if (notification.studentSender != null)
      child = StudentProfileView(
        isFriend: false,
        // student: notification.studentSender!,
        id: notification.studentSender!.id,
      );
    else {
      child = TeacherProfileView(
          teacher: notification.teacherSender!,
          isAdd: false,
          cubit: StudentCubit.get(context));
    }
    navigateTo(context, child);
  }
}
