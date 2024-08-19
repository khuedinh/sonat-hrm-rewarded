import 'package:sonat_hrm_rewarded/src/service/api/api_utils.dart';
import 'package:sonat_hrm_rewarded/src/service/api/dio_interceptor.dart';

class BenefitApi {
  static const String _path = "/benefits";

  static Future getListBenefit() {
    return DioClient.instance.get('$_path/all');
  }
}
