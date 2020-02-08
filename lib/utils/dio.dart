import 'package:dio/dio.dart';
import 'package:guildwars2_companion/services/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class DioUtil {

  final TokenService tokenService;

  DioUtil({
    this.tokenService,
  });

  Dio getDioInstance({
    bool includeTokenInterceptor = true
  }) {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: Urls.baseUrl,
        followRedirects: false,
        validateStatus: (status) => status < 500
      ),
    );

    if (includeTokenInterceptor) {
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          return options..headers = {
            'Authorization': 'Bearer ${await tokenService.getToken()}',
          };
        }
      ));
    }

    return dio;
  }
}