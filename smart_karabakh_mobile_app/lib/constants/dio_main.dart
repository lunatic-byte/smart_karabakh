import 'package:dio/dio.dart';

import 'const_methods.dart';

class DioMain {
  static Dio dio = Dio();

  static DioMain dioMain = DioMain._();

  DioMain._();

  factory DioMain() {
    return dioMain;
  }

  Future<dynamic> getRawData(String url) async {
    var response = await dio.get(url);
    myLog(response.data);
    return response.data;
  }

  Future<dynamic> postRawData(String url, Map<String, dynamic> data) async {
    //For userData update process responses are: 'done', "low_balance", 'error', "user_exists"
    var response = await dio.post(url, data: data);
    myLog(response.data);
    return response.data;
  }
}
