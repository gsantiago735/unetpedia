import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:unetpedia/utils/local_storage.dart';
import 'package:unetpedia/core/constants/constant_api.dart';

class Api {
  final dio = createDio();
  final dioFormData = createDioFormData();

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: ConstantApi.url,
      receiveTimeout: const Duration(minutes: 3),
      connectTimeout: const Duration(minutes: 3),
      sendTimeout: const Duration(minutes: 3),
    ));
    dio.interceptors.addAll({AppInterceptors(dio)});
    return dio;
  }

  static Dio createDioFormData() {
    var dio = Dio(BaseOptions(
      baseUrl: ConstantApi.url,
      connectTimeout: const Duration(hours: 1),
      receiveTimeout: const Duration(hours: 1),
      sendTimeout: const Duration(hours: 1),
    ));
    dio.interceptors.addAll({AppInterceptors(dio)});
    return dio;
  }
}

class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var accessToken = LocalStorage.getAccessToken();

    log("Token de acceso -> $accessToken");

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("====================================================================");
    log(err.message.toString());
    log(err.response.toString());
    handler.next(err);
  }
}
