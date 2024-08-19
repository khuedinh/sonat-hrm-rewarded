import 'package:sonat_hrm_rewarded/src/service/api/dio_interceptor.dart';

class RecognitionApi {
  static const String _path = "/recognitions";

  static Future getHistory() {
    return DioClient.instance.get('$_path/history');
  }
}
