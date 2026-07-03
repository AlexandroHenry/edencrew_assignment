import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// kDebugMode일 때만 응답/요청을 콘솔에 출력한다.
Dio createDio() {
  final dio = Dio();
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ),
    );
  }
  return dio;
}
