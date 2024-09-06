import 'package:sonat_hrm_rewarded/src/service/api/api_utils.dart';
import 'package:sonat_hrm_rewarded/src/service/api/dio_interceptor.dart';

class RecognitionApi {
  static const String _path = "/recognitions";

  static Future getHistory(queryParams) {
    final formatQueryParams = ApiUtils.processQueryParams(queryParams);
    return DioClient.instance
        .get('$_path/history', queryParameters: formatQueryParams);
  }

  static Future getEmployees() {
    return DioClient.instance.get('/employees');
  }

  static Future getRecognitionValues() {
    return DioClient.instance.get('$_path/value');
  }

  static Future sendRecognition(Map<String, dynamic> data) {
    return DioClient.instance.post("$_path/give-points", data: data);
  }

  static Future getBalance() {
    return DioClient.instance.get("/balances/current");
  }

  static Future getGroups() {
    return DioClient.instance.get("/groups");
  }

  static Future getGroupMembers(String groupId) {
    return DioClient.instance.get("/groups/$groupId");
  }

  static Future getLeaderboard() {
    return DioClient.instance.get('$_path/leaderboard');
  }
}
