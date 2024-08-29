import 'package:sonat_hrm_rewarded/src/service/api/api_utils.dart';
import 'package:sonat_hrm_rewarded/src/service/api/dio_interceptor.dart';

class BenefitApi {
  static const String _pathBenefit = "/benefits";
  static const String _pathCategorie = "/categories";

  static Future getListCategories() {
    return DioClient.instance.get('$_pathCategorie/all');
  }

  static Future getListBenefits({required Map<String, dynamic> queryParams}) {
    final formatQueryParams = ApiUtils.processQueryParams(queryParams);
    return DioClient.instance
        .get('$_pathBenefit/all', queryParameters: formatQueryParams);
  }

  static Future getBenefitDetails({required String benefitId}) {
    return DioClient.instance.get('$_pathBenefit?id=$benefitId');
  }

  static Future redeemBenefit(String benefitId) {
    return DioClient.instance
        .post('$_pathBenefit/redeem', data: {'benefitId': benefitId});
  }

  static Future getListClaimedBenefits() {
    return DioClient.instance.get('$_pathBenefit/claim/me');
  }

  static Future toggleArchiveBenefit(String id, String action) {
    return DioClient.instance.patch('$_pathBenefit/claim', data: {
      'id': id,
      "action": action,
    });
  }
}
