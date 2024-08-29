import 'package:sonat_hrm_rewarded/src/models/notification.dart';
import 'package:sonat_hrm_rewarded/src/service/api/api_utils.dart';
import 'package:sonat_hrm_rewarded/src/service/api/dio_interceptor.dart';

class NotificationApi {
  static const String _path = "/notifications";

  static Future registerFCMToken({
    required String token,
  }) async {
    return await DioClient.instance
        .post('$_path/device-token', data: {'deviceToken': token});
  }

  static Future<NotificationListRes> getNotifications({
    int? page,
    int? pageSize = 30,
  }) async {
    return NotificationListRes.fromJson(await DioClient.instance.get(
        '$_path/history',
        queryParameters:
            ApiUtils.processQueryParams({"page": page, "pageSize": pageSize})));
  }

  static Future readNotification({
    required String notiId,
  }) async {
    return await DioClient.instance.patch('$_path/history',
        data: {'isRead': true, 'notificationHistoryId': notiId});
  }

  static Future<UnreadNotiRes> getUnreadCount() async {
    return UnreadNotiRes.fromJson(
        await DioClient.instance.get('$_path/history/count-unread'));
  }
}
