part of "home_bloc.dart";

class HomeState extends Equatable {
  const HomeState({
    this.isLoadingLeaderboard = true,
    this.listLeaderboard = const [],
  });

  final bool isLoadingLeaderboard;
  final List<LeaderboardData> listLeaderboard;

  HomeState copyWith({
    List<LeaderboardData>? listLeaderboard,
    bool? isLoadingLeaderboard,
  }) {
    return HomeState(
      listLeaderboard: listLeaderboard ?? this.listLeaderboard,
      isLoadingLeaderboard: isLoadingLeaderboard ?? this.isLoadingLeaderboard,
    );
  }

  @override
  List<Object?> get props => [
        listLeaderboard,
        isLoadingLeaderboard,
      ];
}
