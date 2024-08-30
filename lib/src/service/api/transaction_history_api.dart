import 'package:sonat_hrm_rewarded/src/service/api/api_utils.dart';
import 'package:sonat_hrm_rewarded/src/service/api/dio_interceptor.dart';

class TransactionHistoryApi {
  static const String _pathTransactionHistory = "/transaction-histories";

  static Future getTransactionHistory({
    required Map<String, dynamic> queryParams,
  }) {
    final formatQueryParams = ApiUtils.processQueryParams(queryParams);
    return DioClient.instance.get('$_pathTransactionHistory/current',
        queryParameters: formatQueryParams);
  }
}
