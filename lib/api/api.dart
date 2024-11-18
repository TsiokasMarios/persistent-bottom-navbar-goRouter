import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'dio_interceptor.dart';

class Api {
  final dio = createDio();

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  static Dio createDio() {
    var dio = Dio(
      BaseOptions(
        baseUrl: "http://5.75.133.209:8001/api/",
      ),
    );

    debugPrint("Creating Dio");
    dio.interceptors.add(DioInterceptor());
    return dio;
  }
}
