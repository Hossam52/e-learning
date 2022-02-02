part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

///
class NotificationGetLoading extends NotificationState {}

class NotificationGetSuccess extends NotificationState {}

class NotificationGetError extends NotificationState {}
