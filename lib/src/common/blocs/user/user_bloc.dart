import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sonat_hrm_rewarded/src/models/balance.dart";
import "package:sonat_hrm_rewarded/src/models/user.dart";
import "package:sonat_hrm_rewarded/src/service/api/balance_api.dart";
import "package:sonat_hrm_rewarded/src/service/api/user_api.dart";

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<InitUserInfo>((UserEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingUserInfo: true));

      final response = await UserApi.getUserInfo();
      print(response);

      emit(state.copyWith(
        userInfo: UserInfo.fromJson(response),
        isLoadingUserInfo: false,
      ));
    });

    on<GetCurrentBalance>((UserEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingCurrentBalance: true));

      final response = await BalanceApi.getCurrentBalance();

      emit(state.copyWith(
        currentBalance: CurrentBalance.fromJson(response),
        isLoadingCurrentBalance: false,
      ));
    });
  }
}
