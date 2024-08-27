import 'package:sonat_hrm_rewarded/src/service/api/dio_interceptor.dart';

class BalanceApi {
  static const String _pathBalance = "/balances";

  static Future getCurrentBalance() {
    return DioClient.instance.get('$_pathBalance/current');
  }
}
