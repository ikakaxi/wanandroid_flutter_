import 'package:dio/dio.dart';

class NetWorkUtil extends Dio {

  factory NetWorkUtil() => _sharedInstance();

  static NetWorkUtil _instance = NetWorkUtil._();

  NetWorkUtil._() {
    options.baseUrl = 'https://www.wanandroid.com';
    options.connectTimeout = 30000;
    options.receiveTimeout = 30000;
    options.responseType = ResponseType.json;
  }

  static NetWorkUtil _sharedInstance() {
    return _instance;
  }

  void GET(String url, Map<String, String> param, Function successBack, Function errorBack) async {

    try {
      Response<dynamic> response = await _instance.get(url, queryParameters: param);
      if (null != response) {
        successBack(response.data);
      }
    } on DioError catch (error) {
      if (null != error){
        errorBack(error.error);
      }
    }
  }

  void POST(String url, Map<String, String> param, Function successBack, Function errorBack) async {

    try {
      Response<dynamic> response = await _instance.post(url, queryParameters: param);
      if (null != response) {
        successBack(response.data);
      }
    } on DioError catch (error) {
      if (null != error){
        errorBack(error.error);
      }
    }
  }
}