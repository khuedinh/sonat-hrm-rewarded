import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:deepcopy/deepcopy.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:sonat_hrm_rewarded/src/models/notification.dart';
import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';
import 'package:sonat_hrm_rewarded/src/service/api/notification_api.dart';

part 'notification_event.dart';
part 'notification_state.dart';

const String kNotificationKey = 'notification';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    final logger = Logger();
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message == null) return;

      logger.d(message.data);
      add(ReceiveNotiEvent(
          title: message.notification?.title ?? "",
          body: message.notification?.body ?? "",
          data: message.data));
    });

    on<GetUnreadNotiEvent>((event, emit) async {
      final res = await NotificationApi.getUnreadCount();

      emit(
        state.copyWith(
          unreadCount: res.count,
        ),
      );
    });

    on<GetNotiListEvent>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
      ));

      final res = await NotificationApi.getNotifications(page: 1);
      final notiList = res.data;

      emit(
        state.copyWith(
          isLoading: false,
          notiList: notiList,
          hasReachedMax: res.page == res.totalPages,
        ),
      );
    });

    on<LoadNotiEvent>((event, emit) async {
      if (state.hasReachedMax) return;
      final res =
          await NotificationApi.getNotifications(page: state.currentPage + 1);
      final itemList = res.data;

      emit(state.copyWith(
          currentPage: state.currentPage + 1,
          notiList: List.of(state.notiList)..addAll(itemList!),
          hasReachedMax: res.page == res.totalPages ? true : false));
    }, transformer: droppable());

    on<RefreshEvent>((event, emit) async {
      emit(state.copyWith(isRefreshLoading: true));

      final res = await NotificationApi.getNotifications(page: 1);
      final itemList = res.data;

      return emit(state.copyWith(
          isRefreshLoading: false,
          currentPage: 1,
          notiList: itemList,
          hasReachedMax: res.page == res.totalPages ? true : false));
    });

    on<ReadNotiEvent>((event, emit) async {
      final itemList = state.notiList.deepcopy() as List<NotificationData>;
      final index =
          itemList.indexWhere((element) => element.id == event.notiId);
      if (index < 0) return;
      itemList[index].isRead = true;
      emit(state.copyWith(
        notiList: itemList,
      ));

      final unreadCountRes = await NotificationApi.getUnreadCount();

      emit(state.copyWith(
        unreadCount: unreadCountRes.count,
      ));

      final res = await NotificationApi.readNotification(notiId: event.notiId);
      if (res == null) return;
    });

    on<ReceiveNotiEvent>((event, emit) async {
      final unreadCountRes = await NotificationApi.getUnreadCount();
      TransactionHistoryData data = event.data as TransactionHistoryData;
      NotificationData newNoti = NotificationData(
        createdAt: data.createdAt,
        deletedAt: data.deletedAt,
        employeeEmail: data.employeeEmail,
        id: data.id,
        isRead: false,
        transactionHistory: data,
        updatedAt: data.updatedAt,
      );

      final itemList = state.notiList..add(newNoti);

      emit(state.copyWith(
        unreadCount: unreadCountRes.count,
        notiList: itemList,
      ));
    });
  }
}
