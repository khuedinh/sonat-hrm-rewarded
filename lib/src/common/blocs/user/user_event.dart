part of "user_bloc.dart";

sealed class UserEvent extends Equatable {}

class FetchUserInfo extends UserEvent {
  @override
  List<Object?> get props => [];
}

class FetchCurrentBalance extends UserEvent {
  @override
  List<Object?> get props => [];
}

class RefreshCurrentBalance extends UserEvent {
  @override
  List<Object?> get props => [];
}

class UpdateUserAndCurrentBalance extends UserEvent {
  final Map<String, dynamic> data;

  UpdateUserAndCurrentBalance({
    required this.data,
  });

  @override
  List<Object?> get props => [];
}
