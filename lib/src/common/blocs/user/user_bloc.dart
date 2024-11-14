import "package:equatable/equatable.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sonat_hrm_rewarded/src/models/balance.dart";
import "package:sonat_hrm_rewarded/src/models/transaction_history.dart";
import "package:sonat_hrm_rewarded/src/models/user.dart";
import "package:sonat_hrm_rewarded/src/service/api/balance_api.dart";
import "package:sonat_hrm_rewarded/src/service/api/user_api.dart";

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message == null) return;

      add(UpdateUserAndCurrentBalance(data: message.data));
    });

    on<FetchUserInfo>((UserEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingUserInfo: true));

      final response = await UserApi.getUserInfo();

      emit(state.copyWith(
        userInfo: UserInfo.fromJson(response),
        isLoadingUserInfo: false,
      ));
    });

    on<FetchCurrentBalance>((UserEvent event, Emitter emit) async {
      if (state.currentBalance != null) return;
      emit(state.copyWith(isLoadingCurrentBalance: true));

      final response = await BalanceApi.getCurrentBalance();

      emit(state.copyWith(
        currentBalance: CurrentBalance.fromJson(response),
        isLoadingCurrentBalance: false,
      ));
    });

    on<RefreshCurrentBalance>((UserEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingCurrentBalance: true));

      final response = await BalanceApi.getCurrentBalance();

      emit(state.copyWith(
        currentBalance: CurrentBalance.fromJson(response),
        isLoadingCurrentBalance: false,
      ));
    });

    on<UpdateUserAndCurrentBalance>((event, emit) async {
      TransactionHistoryData data = TransactionHistoryData.fromJson(event.data);

      if (data.type == TransactionType.gain &&
          data.event == TransactionEvent.recognition) {
        final CurrentBalance newBalance = CurrentBalance(
          id: state.currentBalance!.id,
          currentPoint: data.currency == CurrencyType.points
              ? state.currentBalance!.currentPoint + data.amount
              : state.currentBalance!.currentPoint,
          currentCoin: data.currency == CurrencyType.coins
              ? state.currentBalance!.currentCoin + data.amount
              : state.currentBalance!.currentCoin,
          employeeEmail: state.currentBalance!.employeeEmail,
        );

        emit(
          state.copyWith(
            currentBalance: newBalance,
            userInfo: UserInfo(
              id: state.userInfo!.id,
              email: state.userInfo!.email,
              name: state.userInfo!.name,
              positionId: state.userInfo!.positionId,
              position: state.userInfo!.position,
              balance: newBalance,
              userRecognition: UserRecognition(
                id: state.userInfo!.userRecognition.id,
                totalSent: state.userInfo!.userRecognition.totalSent,
                totalReceive: state.userInfo!.userRecognition.totalReceive,
                employeeEmail: state.userInfo!.userRecognition.employeeEmail,
                totalRecognition:
                    state.userInfo!.userRecognition.totalRecognition + 1,
              ),
              activeBenefit: state.userInfo!.activeBenefit,
            ),
          ),
        );
      }
    });
  }
}
