import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

class DioInterceptor extends Interceptor {
  //The following token logic was implemented
  //To avoid having to look into SharedPreferences on every request
  //Now, the token is stored in a variable
  //SharedPrefs are only checked now when
  //Such as:
  //1. When the app starts and token is empty
  //2. When the token has expired

  static String? token;


  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint("Sending request with options: ${options.path}");
    debugPrint("Sending request with data: ${options.data.toString()}");

    //On every request
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    final context = shellNavigatorKey.currentContext;

    context?.go('/second');
    return;

    //Check if there is a valid token
    //This function will try to see if there is a valid token either
    //In memory (token variable) or in shared preferences
    //If there is a token but it has expired, it will try to refresh it

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    // debugPrint('Handler stuff' + handler.toString());
    // debugPrint('Response stuff' + response.toString());

    if (response.data["AccessToken"] != null) {
      token = response.data["AccessToken"];
    }

    if (response.statusCode == 422) {
      debugPrint('Validation error');
      debugPrint(response.data.toString());
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('Error handler stuff' + handler.toString());
    debugPrint('Some kind of error happened: ' + err.toString());
    super.onError(err, handler);
  }
}
