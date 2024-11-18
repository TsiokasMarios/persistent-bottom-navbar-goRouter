import 'package:flutter/widgets.dart';
import 'api.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  // static final Dio _dio = Dio();
  final Api _api = Api();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<bool> get(){
    return _api.dio.get('/branches').then((response) {
      return true;
    }).catchError((error) {
      return false;
    });
  }

}
