part of "home_bloc.dart";

sealed class HomeEvent extends Equatable {}

class InitLeaderboard extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class RefreshLeaderboard extends HomeEvent {
  @override
  List<Object?> get props => [];
}
