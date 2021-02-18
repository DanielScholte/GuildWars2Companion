import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/account/account.dart';
import 'package:guildwars2_companion/models/account/token_entry.dart';
import 'package:guildwars2_companion/models/account/token_info.dart';
import 'package:guildwars2_companion/features/account/services/account.dart';
import 'package:guildwars2_companion/features/account/services/token.dart';

class AccountRepository {
  final AccountService accountService;
  final TokenService tokenService;

  AccountRepository({
    @required this.accountService,
    @required this.tokenService
  });

  Future<List<TokenEntry>> getTokens() {
    return accountService.getTokens();
  }

  Future<void> addToken(TokenEntry token) {
    return accountService.addToken(token);
  }

  Future<void> removeToken(int tokenId) {
    return accountService.removeToken(tokenId);
  }

  Future<TokenInfo> getTokenInfo(String token) async {
    TokenInfo tokenInfo = await accountService.getTokenInfo(token);
    
    await tokenService.setToken(token);
    
    return tokenInfo;
  }

  Future<Account> getAccount(String token) {
    return accountService.getAccount(token);
  }

  Future<bool> tokenPresent() {
    return tokenService.tokenPresent();
  }

  Future<String> getCurrentToken() {
    return tokenService.getToken();
  }

  Future<bool> removeCurrentToken() {
    return tokenService.removeToken();
  }
}