import 'package:sonat_hrm_rewarded/src/service/api/dio_interceptor.dart';

class UserApi {
  static const String _pathUser = "/employees";

  static Future getUserInfo() {
    return DioClient.instance.get('$_pathUser/current/info');
  }
}
