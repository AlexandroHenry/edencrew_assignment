import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// bytes 응답(HTML 스크래핑)은 본문 수만 바이트를 숫자 배열로 출력해 메모리를 고갈시키고,
// EUC-KR/손상 UTF-8 본문을 그대로 출력하면 debugPrint가 앱을 종료시킬 수 있으므로
// ResponseType.bytes 응답은 크기만 기록하는 커스텀 인터셉터를 공통으로 사용한다.
Dio createDio({String tag = 'DIO'}) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
      sendTimeout: const Duration(seconds: 12),
    ),
  );
  if (kDebugMode) {
    dio.interceptors.add(_SafeLogInterceptor(tag));
  }
  return dio;
}

class _SafeLogInterceptor extends Interceptor {
  const _SafeLogInterceptor(this.tag);

  final String tag;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('[$tag] → ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    debugPrint(
      '[$tag] ← ${response.statusCode} ${response.requestOptions.uri} '
      '(${_responseBodyLength(response)} bytes)',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('[$tag] ✗ ${err.requestOptions.uri}: ${err.message}');
    handler.next(err);
  }

  int _responseBodyLength(Response<dynamic> response) {
    final data = response.data;
    if (data is List<int>) {
      return data.length;
    }
    if (data is String) {
      return data.length;
    }
    if (data is List) {
      return data.length;
    }
    if (data is Map) {
      return data.length;
    }
    return 0;
  }
}
