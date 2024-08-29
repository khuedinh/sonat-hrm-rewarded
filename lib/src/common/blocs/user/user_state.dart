part of "user_bloc.dart";

class UserState extends Equatable {
  const UserState({
    this.userInfo,
    this.currentBalance,
    this.isLoadingUserInfo = true,
    this.isLoadingCurrentBalance = false,
  });

  final UserInfo? userInfo;
  final CurrentBalance? currentBalance;
  final bool isLoadingUserInfo;
  final bool isLoadingCurrentBalance;

  UserState copyWith({
    UserInfo? userInfo,
    CurrentBalance? currentBalance,
    bool? isLoadingUserInfo,
    bool? isLoadingCurrentBalance,
  }) {
    return UserState(
      userInfo: userInfo ?? this.userInfo,
      currentBalance: currentBalance ?? this.currentBalance,
      isLoadingUserInfo: isLoadingUserInfo ?? this.isLoadingUserInfo,
      isLoadingCurrentBalance:
          isLoadingCurrentBalance ?? this.isLoadingCurrentBalance,
    );
  }

  @override
  List<Object?> get props => [
        userInfo,
        currentBalance,
        isLoadingUserInfo,
        isLoadingCurrentBalance,
      ];
}
