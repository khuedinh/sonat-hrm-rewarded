class ApiUtils {
  static Map<String, dynamic> processQueryParams(
      Map<String, dynamic> queryParameters) {
    Map<String, dynamic> result = {};

    if (queryParameters.isNotEmpty) {
      queryParameters.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          result[key] = value;
        }
      });
    }

    return result;
  }
}
