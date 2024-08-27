import 'package:sonat_hrm_rewarded/src/service/api/dio_interceptor.dart';

class NotificationApi {
  static const String _path = "/notifications";
  static final Map<String, String> _suffixMap = {
    'device-token': '/device-token',
  };

  static Future registerFCMToken({
    required String token,
  }) async {
    return await DioClient.instance.post('$_path${_suffixMap['device-token']}',
        data: {'deviceToken': token});
  }
}
