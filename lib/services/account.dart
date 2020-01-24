import 'package:dio/dio.dart';
import '../models/account/account.dart';
import '../models/account/token_info.dart';
import '../utils/dio.dart';
import '../utils/urls.dart';

class AccountService {
  Dio _dio;

  AccountService() {
    _dio = DioUtil.getDioInstance(
      includeTokenInterceptor: false
    );
  }


  Future<Account> getAccount(String token) async {
    final response = await _dio.get(
      Urls.accountUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return Account.fromJson(response.data);
    }

    throw Exception();
  }

  Future<TokenInfo> getTokenInfo(String token) async {
    final response = await _dio.get(
      Urls.tokenInfoUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return TokenInfo.fromJson(response.data);
    }

    throw Exception();
  }
}
