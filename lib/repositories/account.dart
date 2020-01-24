import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/account/account.dart';
import 'package:guildwars2_companion/models/account/token_info.dart';
import 'package:guildwars2_companion/services/account.dart';
import 'package:guildwars2_companion/utils/token.dart';

class AccountRepository {
  final AccountService accountService;

  AccountRepository({
    @required this.accountService
  });

  Future<TokenInfo> getTokenInfo(String token) async {
    TokenInfo tokenInfo = await accountService.getTokenInfo(token);
    
    await TokenUtil.setToken(token);
    
    return tokenInfo;
  }

  Future<Account> getAccount(String token) {
    return accountService.getAccount(token);
  }
}