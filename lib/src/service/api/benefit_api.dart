import 'package:sonat_hrm_rewarded/src/service/api/api_utils.dart';
import 'package:sonat_hrm_rewarded/src/service/api/dio_interceptor.dart';

class BenefitApi {
  static const String _pathBenefit = "/benefits";
  static const String _pathCategorie = "/categories";

  static Future getListCategories() {
    return DioClient.instance.get('$_pathCategorie/all');
  }

  static Future getListBenefit({required Map<String, dynamic> queryParams}) {
    final queryString = ApiUtils.processQueryParams(queryParams);
    return DioClient.instance.get('$_pathBenefit/all?$queryString');
  }

  static Future redeemBenefit({required Map<String, dynamic> data}) {
    return DioClient.instance.post('$_pathBenefit/redeem', data: data);
  }
}
