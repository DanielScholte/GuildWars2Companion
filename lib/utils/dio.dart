import 'package:dio/dio.dart';
import 'package:guildwars2_companion/services/configuration.dart';
import 'package:guildwars2_companion/services/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class DioUtil {

  final TokenService tokenService;
  final ConfigurationService configurationService;

  DioUtil({
    this.tokenService,
    this.configurationService
  });

  Dio getDioInstance({
    bool includeTokenInterceptor = true
  }) {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: Urls.baseUrl,
        followRedirects: false,
        validateStatus: (status) => status < 500,
        connectTimeout: 7500,
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        if (configurationService.language != 'en') {
          options.headers.addAll({'Accept-Language': configurationService.language});
        }

        return options;
      }
    ));

    if (includeTokenInterceptor) {
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          return options..headers.addAll({
            'Authorization': 'Bearer ${await tokenService.getToken()}',
          });
        }
      ));
    }

    return dio;
  }
}