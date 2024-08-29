part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final List<NotificationData> notiList;
  final bool hasReachedMax;
  final int currentPage;
  final bool isRefreshLoading;
  final int unreadCount;

  const NotificationState({
    this.isLoading = true,
    this.hasReachedMax = false,
    this.notiList = const [],
    this.currentPage = 1,
    this.isRefreshLoading = false,
    this.unreadCount = 0,
  });

  NotificationState copyWith(
      {bool? isLoading,
      List<NotificationData>? notiList,
      bool? hasReachedMax,
      String? errorMessage,
      int? currentPage,
      String? htmlContent,
      bool? isRefreshLoading,
      int? unreadCount}) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notiList: notiList ?? this.notiList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isRefreshLoading: isRefreshLoading ?? this.isRefreshLoading,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        notiList,
        hasReachedMax,
        currentPage,
        isRefreshLoading,
        unreadCount
      ];
}
