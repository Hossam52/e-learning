import 'package:e_learning/modules/notifications/cubit/notification_cubit.dart';
import 'package:e_learning/modules/notifications/notification_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
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
  void didChangeDependencies() {
    if (first) 
    {
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
                              onPressed: () =>
                                  cubit.getAllNotifications(widget.type))
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
                                    ? notification.studentSender
                                    : notification.teacherSender;
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
                                              title: Text(
                                                  'هل انت متأكد من حذف هذا التنبيه'),
                                              actions: [
                                                defaultTextButton(
                                                    text: 'تأكيد',
                                                    textColor: Colors.green,
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true)),
                                                defaultTextButton(
                                                    text: 'إلغاء',
                                                    textColor: Colors.red,
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false)),
                                              ],
                                              content: Text('data'),
                                            ));
                                  },
                                  child: NotificationBuildItem(
                                    image: sender.image!,
                                    title: notification.title!,
                                    body: notification.body!,
                                    date: notification.date!,
                                    onTap: () {},
                                  ),
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
