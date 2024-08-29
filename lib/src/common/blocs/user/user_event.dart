part of "user_bloc.dart";

sealed class UserEvent extends Equatable {}

class InitUserInfo extends UserEvent {
  @override
  List<Object?> get props => [];
}

class GetCurrentBalance extends UserEvent {
  @override
  List<Object?> get props => [];
}
