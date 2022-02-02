
import 'package:dio/dio.dart';
import 'package:e_learning/shared/componants/constants.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://algorithm.demo.carmartapp.com/elearning/public/',
        receiveDataWhenStatusError: true,
        followRedirects: false,
        validateStatus: (status) => true,
        headers: {
          'Content-Type': 'application/json',
          'Apipassword' : '1795S',
          'lang' : lang,
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
    Options? options,
  }) async {
    dio.options.headers = {
      'Authorization': token != null ? 'Bearer $token' :'',
      'Apipassword' : '1795S',
      'lang' : lang,
    };

    return await dio.get(
      url,
      queryParameters: query,
      options: options,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
    Options? options,
  }) async
  {
    dio.options.headers =
    {
      'Content-Type' : 'application/json',
      'Authorization': token != null ? 'Bearer $token' :'',
      'Apipassword' : '1795S',
      'lang' : lang,
    };

    return await dio.post(
      url,
      queryParameters: query,
      data: data,
      options: options,
    );
  }
  static Future<Response> postFormData({
    required String url,
    required FormData formData,
    Map<String, dynamic>? query,
    String? token,
    Options? options,
  }) async
  {
    dio.options.headers =
    {
      'Authorization': token != null ? 'Bearer $token' :'',
      'Apipassword' : '1795S',
      'lang' : lang,
    };

    return await dio.post(
      url,
      queryParameters: query,
      data: formData,
      options: options,
    );
  }
  /// Put Data Function
  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async
  {
    dio.options.headers =
    {
      'Content-Type' : 'application/json',
      'lang':lang,
      'Authorization': token != null ? 'Bearer $token' :'',
      'Apipassword' : '1795S',
    };
    return dio.put(
      url,
      data: (data)!,
      queryParameters: query,
    );
  }
  /// Delete data function
  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers =
    {
      'Content-Type' : 'application/json',
      'lang':lang,
      'Authorization': token != null ? 'Bearer $token' :'',
      'Apipassword' : '1795S',
    };

    return dio.delete(
      url,
      data: data,
      queryParameters: query,
    );
  }
}