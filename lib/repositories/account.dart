import 'package:dio/dio.dart';
import 'package:guildwars2_companion/models/account/account.dart';
import 'package:guildwars2_companion/models/account/token_info.dart';
import 'package:guildwars2_companion/utils/dio.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class AccountRepository {
  Dio _dio;

  AccountRepository() {
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