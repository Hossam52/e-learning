part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

///
class NotificationGetLoading extends NotificationState {}

class NotificationGetSuccess extends NotificationState {}

class NotificationDeletedSuccess extends NotificationState {
  final String message;
  NotificationDeletedSuccess(this.message);
}

class NotificationGetError extends NotificationState {}

class NotificationGetMoreLoading extends NotificationState {}

class NotificationGetMoreSuccess extends NotificationState {}

class NotificationGetMoreError extends NotificationState {}
