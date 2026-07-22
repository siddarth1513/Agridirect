import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class DioClient {
  late final Dio dio;
  final SecureStorage _secureStorage = SecureStorage();

  // Android emulator loopback points to localhost. Use localhost for Web/iOS.
  static const String baseUrl = 'http://127.0.0.1:8000';

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _secureStorage.getRefreshToken();
            if (refreshToken != null) {
              try {
                // Setup fresh client for refresh request to prevent interceptor loops
                final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
                final response = await refreshDio.post(
                  '/api/auth/token/refresh/',
                  data: {'refresh': refreshToken},
                );

                if (response.statusCode == 200) {
                  final access = response.data['access'];
                  final refresh = response.data['refresh'] ?? refreshToken;

                  await _secureStorage.saveTokens(access: access, refresh: refresh);

                  // Re-try original request with new access token
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $access';
                  
                  final cloneReq = await dio.request(
                    options.path,
                    options: Options(
                      method: options.method,
                      headers: options.headers,
                    ),
                    data: options.data,
                    queryParameters: options.queryParameters,
                  );
                  return handler.resolve(cloneReq);
                }
              } catch (e) {
                await _secureStorage.clearAll();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
}
