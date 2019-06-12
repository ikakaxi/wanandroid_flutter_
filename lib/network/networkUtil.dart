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

  void GET(String url, Map<String, dynamic> param, Function successBack, Function errorBack) async {

    try {
      Response<dynamic> response = await _instance.get(url, queryParameters: param);
      if (response.statusCode == 200) {
        if (response.data["errorCode"] == -1) {
          errorBack(response.data["errorMsg"]);
        } else {
          successBack(response.data);
        }
      } else {
        errorBack(response.statusMessage);
      }
    } on DioError catch (error) {
      if (null != error){
        errorBack(error.message);
      }
    }
  }

  void POST(String url, Map<String, dynamic> param, Function successBack, Function errorBack) async {

    try {
      Response<dynamic> response = await _instance.post(url, queryParameters: param);
      if (response.statusCode == 200) {
        if (response.data["errorCode"] == -1) {
          errorBack(response.data["errorMsg"]);
        } else {
          successBack(response.data);
        }
      } else {
        errorBack(response.statusMessage);
      }
    } on DioError catch (error) {
      if (null != error){
        errorBack(error.message);
      }
    }
  }
}