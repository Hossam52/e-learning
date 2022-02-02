import 'package:e_learning/modules/notifications/cubit/notification_cubit.dart';
import 'package:e_learning/modules/notifications/notification_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key, required this.type}) : super(key: key);

  final NotificationType type;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationCubit()..getAllNotifications(type),
      child: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {},
        builder: (context, state) {
          NotificationCubit cubit = NotificationCubit.get(context);
          return responsiveWidget(
            responsive: (_, deviceInfo) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('التنبيهات'),
                  centerTitle: true,
                  leading: defaultBackButton(context, deviceInfo.screenHeight),
                ),
                body: Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      state is! NotificationGetLoading,
                  fallbackBuilder: (context) => DefaultLoader(),
                  widgetBuilder: (context) => cubit.noNotifications
                      ? noData('لا يوجد اشعارات حتى الان')
                      : state is NotificationGetError
                          ? NoDataWidget(
                              onPressed: () => cubit.getAllNotifications(
                                  type))
                          : ListView.separated(
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
                                var sender = notification.studentSender != null
                                    ? notification.studentSender : notification.teacherSender;
                                return NotificationBuildItem(
                                  image: sender.image!,
                                  title: notification.title!,
                                  body: notification.body!,
                                  date: '24/11/2021',
                                  onTap: () {},
                                );
                              },
                            ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
