part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetUnreadNotiEvent extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class GetNotiListEvent extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class LoadNotiEvent extends NotificationEvent {
  const LoadNotiEvent();

  @override
  List<Object> get props => [];
}

class RefreshEvent extends NotificationEvent {
  const RefreshEvent();

  @override
  List<Object> get props => [];
}

class ReceiveNotiEvent extends NotificationEvent {
  final String title;
  final String body;
  final Map<String, dynamic> data;

  const ReceiveNotiEvent(
      {required this.title, required this.body, required this.data});

  @override
  List<Object> get props => [title, body, data];
}

class ReadNotiEvent extends NotificationEvent {
  final String notiId;

  const ReadNotiEvent({required this.notiId});

  @override
  List<Object> get props => [notiId];
}
