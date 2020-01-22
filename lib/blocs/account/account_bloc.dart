import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/account/account.dart';
import 'package:guildwars2_companion/models/account/token_info.dart';
import 'package:guildwars2_companion/repositories/account.dart';
import 'package:guildwars2_companion/utils/token.dart';
import './bloc.dart';


class AccountBloc extends Bloc<AccountEvent, AccountState> {
  @override
  AccountState get initialState => LoadingAccountState();

  final AccountRepository accountRepository;

  AccountBloc({
    @required this.accountRepository
  }) {
    add(SetupAccountEvent());
  }

  @override
  Stream<AccountState> mapEventToState(
    AccountEvent event,
  ) async* {
    if (event is AuthenticateEvent) {
      yield LoadingAccountState();
      yield* _authenticate(event.token);
    } else if (event is SetupAccountEvent) {
      yield LoadingAccountState();
      if (await TokenUtil.tokenPresent()) {
        yield* _authenticate(await TokenUtil.getToken());
        return;
      }
      yield await _getUnauthenticated(null);
    } else if (event is AddTokenEvent) {
      yield LoadingAccountState();
      yield* _addToken(event.token);
    } else if (event is RemoveTokenEvent) {
      yield LoadingAccountState();
      yield* _removeToken(event.token);
    } else if (event is UnauthenticateEvent) {
      await TokenUtil.removeToken();
      yield await _getUnauthenticated(null);
    }
  }

  Stream<AccountState> _authenticate(String token) async* {
    try {
      TokenInfo tokenInfo = await accountRepository.getTokenInfo(token);

      await TokenUtil.setToken(token);
      yield AuthenticatedState(
        await accountRepository.getAccount(token),
        tokenInfo
      );
    } catch (_) {
      yield await _getUnauthenticated("Invalid token");
    }
  }

  Stream<AccountState> _addToken(String token) async* {
    try {
      Account account = await accountRepository.getAccount(token);

      await TokenUtil.addToTokenList('$token;${account.name};${DateTime.now()}');
      yield await _getUnauthenticated("Token added", tokenAdded: true);
    } catch (_) {
      yield await _getUnauthenticated("Invalid token");
    }
  }

  Stream<AccountState> _removeToken(String token) async* {
    await TokenUtil.removeFromTokenList(token);
    yield await _getUnauthenticated("Token removed");
  }  

  Future<UnauthenticatedState> _getUnauthenticated(String message, { bool tokenAdded = false }) async {
    return UnauthenticatedState(
      await TokenUtil.getTokenList(),
      message,
      tokenAdded
    );
  }
}
