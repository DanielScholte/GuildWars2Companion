import 'dart:convert';

import 'package:guildwars2_companion/models/account/account.dart';
import 'package:guildwars2_companion/models/account/token_info.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:http/http.dart' as http;

class AccountRepository {
  Future<Account> getAccount(String token) async {
    final response = await http.get(
      Urls.accountUrl,
      headers: {
        'Authorization': 'Bearer $token',
      }
    );

    if (response.statusCode == 200) {
      return Account.fromJson(json.decode(response.body));
    }

    return null;
  }

  Future<TokenInfo> getTokenInfo(String token) async {
    final response = await http.get(
      Urls.tokenInfoUrl,
      headers: {
        'Authorization': 'Bearer $token',
      }
    );

    if (response.statusCode == 200) {
      return TokenInfo.fromJson(json.decode(response.body));
    }

    return null;
  }
}