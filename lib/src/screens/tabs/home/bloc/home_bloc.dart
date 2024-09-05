import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sonat_hrm_rewarded/src/models/leaderboard.dart";
import "package:sonat_hrm_rewarded/src/service/api/recognition_api.dart";

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<FetchLeaderboard>((HomeEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingLeaderboard: true));

      final response = await RecognitionApi.getLeaderboard();

      if (response is List) {
        final List<LeaderboardData> listLeaderboard = response
            .map((e) => LeaderboardData.fromJson(e as Map<String, dynamic>))
            .toList();

        emit(state.copyWith(
          listLeaderboard: listLeaderboard,
          isLoadingLeaderboard: false,
        ));
        return;
      }

      emit(state.copyWith(isLoadingLeaderboard: false));
    });
  }
}
